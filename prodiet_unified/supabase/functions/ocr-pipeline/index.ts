import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

serve(async (req) => {
  try {
    const { imageBase64, mimeType = 'image/jpeg' } = await req.json()

    if (!imageBase64) {
      return new Response(JSON.stringify({ error: 'imageBase64 required' }), { status: 400 })
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
            {
              inlineData: {
                mimeType,
                data: imageBase64,
              }
            }
          ]
        }],
        generationConfig: { responseMimeType: 'application/json' }
      })
    })

    const geminiData = await geminiRes.json()
    const rawText = geminiData.candidates[0].content.parts[0].text
    const items = JSON.parse(rawText)

    return new Response(JSON.stringify({ items, rawText }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { status: 500 })
  }
})
