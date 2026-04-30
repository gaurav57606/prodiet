import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { corsHeaders } from '../_shared/cors.ts'

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  try {
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
    const result = JSON.parse(geminiData.candidates[0].content.parts[0].text)

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
