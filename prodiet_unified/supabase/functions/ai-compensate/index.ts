import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  try {
    // ── AUTH GUARD ──────────────────────────────────────
    const authHeader = req.headers.get('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401, headers: { 'Content-Type': 'application/json' }
      })
    }
    const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } }
    })
    const { data: { user }, error: authError } = await userClient.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401, headers: { 'Content-Type': 'application/json' }
      })
    }

    const { user_id, missed_meal_id, remaining_macros } = await req.json()

    const prompt = `You are an AI macro specialist for ProDiet.
    A user missed a meal (ID: ${missed_meal_id}).
    Their remaining macro targets for today are: ${JSON.stringify(remaining_macros)}.
    
    Calculate how they should adjust their remaining meals (assuming they have 1-2 meals left) to stay on track.
    Return a JSON response with this structure:
    {
      "adjustment_summary": "Short explanation of the adjustment",
      "new_targets": {
        "calories": 0,
        "protein_g": 0,
        "carbs_g": 0,
        "fat_g": 0
      },
      "tips": ["Tip 1", "Tip 2"]
    }
    Be realistic. If they missed too many calories, don't just dump them all into one meal.`

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`

    const geminiRes = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { responseMimeType: 'application/json' }
      })
    })

    const geminiData = await geminiRes.json()
    
    // Null-safe Gemini response parsing
    const candidate = geminiData.candidates?.[0]
    if (!candidate || candidate.finishReason !== 'STOP') {
      const reason = candidate?.finishReason ?? 'NO_CANDIDATES'
      throw new Error(`Gemini returned no valid content. Reason: ${reason}`)
    }
    const rawText = candidate.content?.parts?.[0]?.text
    if (!rawText) {
      throw new Error('Gemini response had no text content')
    }
    const result = JSON.parse(rawText)

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }
})
