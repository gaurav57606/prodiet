import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

serve(async (req) => {
  try {
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
    
    if (!geminiData.candidates?.[0]?.content?.parts?.[0]?.text) {
      throw new Error('Invalid response from Gemini')
    }

    const result = JSON.parse(geminiData.candidates[0].content.parts[0].text)

    return new Response(JSON.stringify(result), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
