import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')

const supabase = createClient(SUPABASE_URL!, SUPABASE_SERVICE_ROLE_KEY!)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }
  try {
    const params = await req.json()
    const { user_id, fitness_goal, activity_level, dietary_preferences, allergies, days = 7 } = params

    // 1. Build cache key
    const cacheKey = `meal_plan::${fitness_goal}_${activity_level}_${dietary_preferences}_${allergies}`.toLowerCase()
    const hash = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(cacheKey))
    const hashHex = Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('')

    // 2. Check cache
    const { data: cached } = await supabase
      .from('ai_cache')
      .select('response_json')
      .eq('query_hash', hashHex)
      .maybeSingle()

    if (cached) {
      // Update hit count
      await supabase.rpc('increment_cache_hit', { hash: hashHex })
      return new Response(JSON.stringify(cached.response_json), {
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      })
    }

    // 3. Call Gemini
    const prompt = `Generate a ${days}-day healthy meal plan for a user with goal: ${fitness_goal}, activity: ${activity_level}, prefs: ${dietary_preferences}, allergies: ${allergies}. Return JSON: { days: [{breakfast, lunch, dinner, snacks}], summary: {calories, protein, carbs, fat} }`

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

    // 4. Store in cache
    await supabase.from('ai_cache').upsert({
      namespace: 'mealPlan',
      query_hash: hashHex,
      response_json: resultJson,
      expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
    })

    return new Response(JSON.stringify(resultJson), {
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    })
  } catch (error) {
    return new Response(JSON.stringify({ error: error.message }), { 
      status: 500,
      headers: { ...corsHeaders, "Content-Type": "application/json" }
    })
  }
})
