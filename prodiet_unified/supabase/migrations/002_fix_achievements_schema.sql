-- Sync achievements table with Flutter domain model
-- Migration: 002_fix_achievements_schema.sql

-- 1. Add missing columns to achievements
ALTER TABLE public.achievements 
ADD COLUMN IF NOT EXISTS streak_count INT DEFAULT 0,
ADD COLUMN IF NOT EXISTS badge_image_path TEXT;

-- 2. Create sessions table (requested in audit criteria)
CREATE TABLE IF NOT EXISTS public.sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  device_name TEXT,
  last_active TIMESTAMPTZ DEFAULT now(),
  fcm_token TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS on sessions
ALTER TABLE public.sessions ENABLE ROW LEVEL SECURITY;

-- Sessions Policy
CREATE POLICY "Users can manage own sessions" 
ON public.sessions FOR ALL 
USING (auth.uid() = user_id) 
WITH CHECK (auth.uid() = user_id);

-- Add index for user_id on sessions
CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON public.sessions(user_id);
