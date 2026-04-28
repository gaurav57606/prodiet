import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

serve(async (req) => {
  try {
    const { image_url, user_id, type } = await req.json()

    // 1. Download image
    const imageRes = await fetch(image_url)
    const imageBlob = await imageRes.blob()

    // 2. Mock Preprocessing (In a real setup, use sharp/jimp)
    // Here we proceed to OCR
    
    // 3. OCR via Tesseract (Mocked for this implementation as Tesseract.js is heavy for Edge)
    // In production, you would use a dedicated OCR service or a lightweight WASM build
    const extractedText = "Mocked extracted text from receipt or chart"
    const confidence = 0.89

    let prompt = ""
    if (type === 'bill') {
      prompt = `Extract items from this receipt text. Return JSON: { items: [{name, qty, unit, price}], confidence, source: 'gemini' }. Text: ${extractedText}`
    } else {
      prompt = `Extract diet plan from this chart text. Return JSON: { meals: [...], macros: {...}, confidence, source: 'gemini' }. Text: ${extractedText}`
    }

    // 4. Call Gemini (Text-only if confidence high, Vision otherwise)
    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`
    
    const geminiRes = await fetch(geminiUrl, {
      method: 'POST',
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { responseMimeType: "application/json" }
      })
    })

    const geminiData = await geminiRes.json()
    const resultJson = JSON.parse(geminiData.candidates[0].content.parts[0].text)

    return new Response(JSON.stringify(resultJson), {
      headers: { "Content-Type": "application/json" },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
