import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

serve(async (req) => {
  // Handle CORS preflight
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

    const { user_id, question, ingredients = [] } = await req.json()

    if (!question) {
      return new Response(JSON.stringify({ error: 'Question is required' }), { status: 400 })
    }

    const prompt = `You are a professional nutritionist and kitchen assistant for the ProDiet app.
    The user is asking: "${question}"
    The user has these ingredients available: ${ingredients.join(', ')}.
    
    Provide a concise, helpful answer. If they ask for a recipe, suggest one based on their ingredients.
    Keep the tone professional yet encouraging.
    Return the response in this JSON format:
    {
      "answer": "Your detailed answer here",
      "suggested_recipe": "Optional recipe name if applicable"
    }`

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
