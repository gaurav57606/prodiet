import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ── AUTH GUARD ──────────────────────────────────────
    const authHeader = req.headers.get('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } }
    })
    const { data: { user }, error: authError } = await userClient.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    // ── INPUT VALIDATION ───────────────────────────────
    const { imageBase64, mimeType = 'image/jpeg' } = await req.json()
    if (!imageBase64) {
      return new Response(JSON.stringify({ error: 'imageBase64 required' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    const prompt = `You are a grocery bill scanner.
Look at this image and extract all food/grocery items.
For each item found, return a JSON array with this exact structure:
[
  {
    "name": "Rice",
    "quantity": 1,
    "unit": "kg",
    "category": "Grains"
  }
]
Categories must be one of: Grains, Protein, Dairy, Vegetables, Fruits, Oils, Spices, Other
If quantity is unclear, default to 1.
If unit is unclear, default to "pcs".
Return ONLY the JSON array, no other text.`

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`

    const geminiRes = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{
          parts: [
            { text: prompt },
            { inlineData: { mimeType, data: imageBase64 } }
          ]
        }],
        generationConfig: { responseMimeType: 'application/json' }
      })
    })

    const geminiData = await geminiRes.json()

    // ── NULL-SAFE RESPONSE PARSING ─────────────────────
    const candidate = geminiData.candidates?.[0]
    if (!candidate || candidate.finishReason !== 'STOP') {
      const reason = candidate?.finishReason ?? 'NO_CANDIDATES'
      throw new Error(`Gemini returned no valid content. Reason: ${reason}`)
    }

    const rawText = candidate.content?.parts?.[0]?.text
    if (!rawText) {
      throw new Error('Gemini response had no text content')
    }

    const items = JSON.parse(rawText)

    return new Response(JSON.stringify({ items, rawText }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })

  } catch (error) {
    console.error('[ocr-pipeline] Error:', error.message)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }
})
