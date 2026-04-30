import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const SUPABASE_ANON_KEY = Deno.env.get('SUPABASE_ANON_KEY')!
const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY')!

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // ── AUTH GUARD ──────────────────────────────────────
    const authHeader = req.headers.get('Authorization')
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return new Response(JSON.stringify({ error: 'Missing authorization header' }), {
        status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    // Verify the JWT against Supabase Auth
    const userClient = createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {
      global: { headers: { Authorization: authHeader } }
    })
    const { data: { user }, error: authError } = await userClient.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      })
    }

    // Use service role for DB operations
    const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY)

    const params = await req.json()
    const { fitness_goal, activity_level, dietary_preferences, allergies, days = 7 } = params

    // ── CACHE CHECK ──────────────────────────────────────
    const cacheKey = `mealPlan::${fitness_goal}_${activity_level}_${dietary_preferences}_${allergies}`.toLowerCase()
    const hash = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(cacheKey))
    const hashHex = Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, '0')).join('')

    const { data: cached } = await supabase
      .from('ai_cache')
      .select('response_json, expires_at')
      .eq('query_hash', hashHex)
      .maybeSingle()

    if (cached) {
      const expires = new Date(cached.expires_at)
      if (expires > new Date()) {
        await supabase.rpc('increment_cache_hit', { hash: hashHex })
        return new Response(JSON.stringify(cached.response_json), {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        })
      }
      // Stale — delete and regenerate
      await supabase.from('ai_cache').delete().eq('query_hash', hashHex)
    }

    // ── GEMINI CALL ──────────────────────────────────────
    const prompt = `Generate a ${days}-day healthy meal plan for a user with goal: ${fitness_goal}, activity: ${activity_level}, prefs: ${dietary_preferences}, allergies: ${allergies}. Return JSON: { days: [{breakfast, lunch, dinner, snacks}], summary: {calories, protein, carbs, fat} }`

    const geminiUrl = `https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${GEMINI_API_KEY}`
    const geminiRes = await fetch(geminiUrl, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: { responseMimeType: "application/json" }
      })
    })

    const geminiData = await geminiRes.json()

    // ── NULL-SAFE RESPONSE PARSING ────────────────────────
    const candidate = geminiData.candidates?.[0]
    if (!candidate || candidate.finishReason !== 'STOP') {
      const reason = candidate?.finishReason ?? 'NO_CANDIDATES'
      throw new Error(`Gemini returned no valid content. Reason: ${reason}`)
    }

    const rawText = candidate.content?.parts?.[0]?.text
    if (!rawText) {
      throw new Error('Gemini response had no text content')
    }

    const resultJson = JSON.parse(rawText)

    // ── STORE IN CACHE ────────────────────────────────────
    await supabase.from('ai_cache').upsert({
      namespace: 'mealPlan',
      query_hash: hashHex,
      response_json: resultJson,
      hit_count: 0,
      created_at: new Date().toISOString(),
      expires_at: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString(),
    })

    return new Response(JSON.stringify(resultJson), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  } catch (error) {
    console.error('[ai-meal-plan] Error:', error.message)
    return new Response(JSON.stringify({ error: error.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' }
    })
  }
})
