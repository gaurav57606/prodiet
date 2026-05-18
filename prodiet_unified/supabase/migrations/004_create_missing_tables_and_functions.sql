-- Migration: 004_create_missing_tables_and_functions.sql
-- Description: Create ai_cache, rate_limits, fasting_sessions tables and increment_cache_hit(TEXT) RPC.

-- 1. AI CACHE TABLE
CREATE TABLE IF NOT EXISTS public.ai_cache (
  query_hash TEXT PRIMARY KEY,
  namespace TEXT NOT NULL,
  response_json JSONB NOT NULL,
  hit_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now(),
  expires_at TIMESTAMPTZ NOT NULL
);

-- 2. FASTING SESSIONS TABLE
CREATE TABLE IF NOT EXISTS public.fasting_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE NOT NULL,
  start_time TIMESTAMPTZ NOT NULL,
  end_time TIMESTAMPTZ,
  target_duration_hours INTEGER,
  completed BOOLEAN DEFAULT false,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 3. RATE LIMITS TABLE
CREATE TABLE IF NOT EXISTS public.rate_limits (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  ip_address TEXT,
  action TEXT NOT NULL,
  logged_at TIMESTAMPTZ DEFAULT now()
);

-- 4. FUNCTION DEFINITION: increment_cache_hit(TEXT)
CREATE OR REPLACE FUNCTION public.increment_cache_hit(hash TEXT)
RETURNS VOID AS $$
BEGIN
  UPDATE public.ai_cache
  SET hit_count = hit_count + 1
  WHERE query_hash = hash;
END;
$$ LANGUAGE plpgsql;

-- 5. SECURE SEARCH PATHS FOR FUNCTIONS
ALTER FUNCTION public.increment_cache_hit(TEXT) SET search_path = public;

-- 6. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.ai_cache ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fasting_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rate_limits ENABLE ROW LEVEL SECURITY;

-- 7. DEFINE RLS POLICIES

-- Policies for ai_cache
DROP POLICY IF EXISTS "Authenticated users can select cache entries" ON public.ai_cache;
CREATE POLICY "Authenticated users can select cache entries" ON public.ai_cache
  FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Service role can manage cache entries" ON public.ai_cache;
CREATE POLICY "Service role can manage cache entries" ON public.ai_cache
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- Policies for fasting_sessions
DROP POLICY IF EXISTS "Users can manage own fasting sessions" ON public.fasting_sessions;
CREATE POLICY "Users can manage own fasting sessions" ON public.fasting_sessions
  FOR ALL USING ((SELECT auth.uid()) = user_id) WITH CHECK ((SELECT auth.uid()) = user_id);

-- Policies for rate_limits
DROP POLICY IF EXISTS "Users can view own rate limits" ON public.rate_limits;
CREATE POLICY "Users can view own rate limits" ON public.rate_limits
  FOR SELECT USING ((SELECT auth.uid()) = user_id);

DROP POLICY IF EXISTS "Service role can manage rate limits" ON public.rate_limits;
CREATE POLICY "Service role can manage rate limits" ON public.rate_limits
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- 8. INDEXES FOR ESCALATING QUERY PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_fasting_sessions_user_id ON public.fasting_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_ai_cache_namespace ON public.ai_cache(namespace);
CREATE INDEX IF NOT EXISTS idx_rate_limits_user_id ON public.rate_limits(user_id);
