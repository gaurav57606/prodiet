-- Migration: 003_security_and_performance_fixes.sql
-- Description: Fixes RLS, search paths, and adds missing indexes.

-- 1. FORCE ENABLE RLS ON ALL TABLES
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.fasting_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_cache ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rate_limits ENABLE ROW LEVEL SECURITY;

-- 2. ADD MISSING INDEXES FOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_fasting_sessions_user_id ON public.fasting_sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_inventory_user_id ON public.inventory(user_id);
CREATE INDEX IF NOT EXISTS idx_meals_user_id ON public.meals(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_water_logs_user_id ON public.water_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_achievements_user_id ON public.achievements(user_id);

-- 3. OPTIMIZE RLS POLICIES (Use cached auth.uid())
-- We drop and recreate with (SELECT auth.uid()) for better performance at scale.

-- Users
DROP POLICY IF EXISTS "Users can select own profile" ON public.users;
CREATE POLICY "Users can select own profile" ON public.users FOR SELECT USING ((SELECT auth.uid()) = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING ((SELECT auth.uid()) = id);

-- Meals
DROP POLICY IF EXISTS "Users can manage own meals" ON public.meals;
CREATE POLICY "Users can manage own meals" ON public.meals FOR ALL USING ((SELECT auth.uid()) = user_id);

-- Water Logs
DROP POLICY IF EXISTS "own_water" ON public.water_logs;
DROP POLICY IF EXISTS "Users can manage own water logs" ON public.water_logs;
CREATE POLICY "Users can manage own water logs" ON public.water_logs FOR ALL USING ((SELECT auth.uid()) = user_id);

-- Inventory
DROP POLICY IF EXISTS "own_inventory" ON public.inventory;
DROP POLICY IF EXISTS "Users can manage own inventory" ON public.inventory;
CREATE POLICY "Users can manage own inventory" ON public.inventory FOR ALL USING ((SELECT auth.uid()) = user_id);

-- Fasting Sessions
DROP POLICY IF EXISTS "own_fasting" ON public.fasting_sessions;
CREATE POLICY "Users can manage own fasting" ON public.fasting_sessions FOR ALL USING ((SELECT auth.uid()) = user_id);

-- 4. SECURITY DEFINER FIXES
-- Fix search path to prevent hijacking
ALTER FUNCTION public.handle_new_user() SET search_path = public, auth;
ALTER FUNCTION public.increment_cache_hit(UUID) SET search_path = public;

-- Revoke public execution of handle_new_user (should only be triggered by Auth)
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM public;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM anon;
REVOKE EXECUTE ON FUNCTION public.handle_new_user() FROM authenticated;
