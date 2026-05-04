-- Initial Schema Migration for ProDiet

-- 1. Users table
CREATE TABLE IF NOT EXISTS public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  name TEXT,
  onboarding_complete BOOLEAN DEFAULT false,
  daily_water_goal_ml INT DEFAULT 2000,
  daily_calorie_goal INT DEFAULT 2000,
  target_weight_kg NUMERIC,
  weight_kg NUMERIC,
  height_cm NUMERIC,
  age INT,
  fitness_goal TEXT,
  activity_level TEXT,
  dietary_preferences TEXT[],
  allergies TEXT[],
  variety_preference TEXT,
  fcm_token TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Meals table
CREATE TABLE IF NOT EXISTS public.meals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  calories INT,
  protein_g NUMERIC,
  carbs_g NUMERIC,
  fat_g NUMERIC,
  meal_type TEXT,
  status TEXT DEFAULT 'pending',
  planned_date DATE,
  scheduled_time TIME,
  ingredients JSONB,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Water logs table
CREATE TABLE IF NOT EXISTS public.water_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  amount_ml INT NOT NULL,
  logged_at TIMESTAMPTZ DEFAULT now(),
  date DATE NOT NULL
);

-- 4. Diet plans table
CREATE TABLE IF NOT EXISTS public.diet_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  name TEXT,
  days JSONB,
  is_active BOOLEAN DEFAULT true,
  generated_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Progress entries table
CREATE TABLE IF NOT EXISTS public.progress_entries (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  weight_kg NUMERIC NOT NULL,
  logged_at TIMESTAMPTZ DEFAULT now(),
  notes TEXT
);

-- 6. Achievements table
CREATE TABLE IF NOT EXISTS public.achievements (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT,
  description TEXT,
  type TEXT,
  milestone INT,
  earned_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(user_id, type, milestone)
);

-- 7. Notifications table
CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT,
  body TEXT,
  type TEXT DEFAULT 'system',
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 8. Shopping list table
CREATE TABLE IF NOT EXISTS public.shopping_list (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  ingredient_name TEXT,
  quantity NUMERIC,
  unit TEXT,
  is_purchased BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 9. Inventory table
CREATE TABLE IF NOT EXISTS public.inventory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES public.users(id) ON DELETE CASCADE,
  ingredient_name TEXT,
  quantity NUMERIC,
  unit TEXT,
  expiry_date DATE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- ENABLE ROW LEVEL SECURITY
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diet_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress_entries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.shopping_list ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.inventory ENABLE ROW LEVEL SECURITY;

-- RLS POLICIES

-- Users
CREATE POLICY "Users can select own profile" ON public.users FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users FOR UPDATE USING (auth.uid() = id);
CREATE POLICY "Users can insert own profile" ON public.users FOR INSERT WITH CHECK (auth.uid() = id);

-- Meals
CREATE POLICY "Users can manage own meals" ON public.meals FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Water Logs
CREATE POLICY "Users can manage own water logs" ON public.water_logs FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Diet Plans
CREATE POLICY "Users can manage own diet plans" ON public.diet_plans FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Progress Entries
CREATE POLICY "Users can manage own progress entries" ON public.progress_entries FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Achievements
CREATE POLICY "Users can view own achievements" ON public.achievements FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own achievements" ON public.achievements FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Notifications
CREATE POLICY "Users can manage own notifications" ON public.notifications FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Shopping List
CREATE POLICY "Users can manage own shopping list" ON public.shopping_list FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Inventory
CREATE POLICY "Users can manage own inventory" ON public.inventory FOR ALL USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- INDEXES
CREATE INDEX IF NOT EXISTS idx_meals_user_date ON public.meals(user_id, planned_date);
CREATE INDEX IF NOT EXISTS idx_water_user_date ON public.water_logs(user_id, date);
CREATE INDEX IF NOT EXISTS idx_progress_user_date ON public.progress_entries(user_id, logged_at);

-- UPDATED_AT TRIGGER
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_updated_at();
