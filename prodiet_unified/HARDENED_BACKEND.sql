-- PRODIET UNIFIED SUPABASE SCHEMA & SECURITY POLICIES
-- HARDENED VERSION: 2.0.0

-- 1. EXTENSIONS
create extension if not exists "uuid-ossp";

-- 2. TABLES

-- USERS (Primary Profile)
create table if not exists users (
  id uuid references auth.users on delete cascade primary key,
  email text unique not null,
  full_name text,
  avatar_url text,
  daily_water_goal_ml integer default 2000,
  daily_calorie_goal integer default 2500,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- MEALS
create table if not exists meals (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references users(id) on delete cascade not null,
  name text not null,
  meal_type text not null check (meal_type in ('breakfast', 'lunch', 'dinner', 'snack')),
  calories float8 default 0,
  protein_g float8 default 0,
  carbs_g float8 default 0,
  fat_g float8 default 0,
  ingredients jsonb default '[]'::jsonb,
  status text default 'pending' check (status in ('pending', 'eaten', 'skipped')),
  planned_date date default current_date not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- WATER LOGS
create table if not exists water_logs (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references users(id) on delete cascade not null,
  amount_ml integer not null,
  date date default current_date not null,
  logged_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- USER DEVICES (Registry)
create table if not exists user_devices (
  id uuid default uuid_generate_v4() primary key,
  user_id uuid references users(id) on delete cascade not null,
  device_id text not null,
  fcm_token text,
  platform text check (platform in ('android', 'ios', 'web')),
  app_version text,
  last_seen timestamp with time zone default timezone('utc'::text, now()) not null,
  is_active boolean default true,
  notification_capability boolean default true,
  unique(user_id, device_id)
);

-- 3. INDEXING FOR PERFORMANCE
create index if not exists idx_meals_user_date on meals(user_id, planned_date);
create index if not exists idx_water_user_date on water_logs(user_id, date);
create index if not exists idx_user_devices_token on user_devices(fcm_token);

-- 4. ROW LEVEL SECURITY (RLS)

-- Enable RLS
alter table users enable row level security;
alter table meals enable row level security;
alter table water_logs enable row level security;
alter table user_devices enable row level security;

-- Policies: Users
create policy "Users can view own profile" on users for select using (auth.uid() = id);
create policy "Users can update own profile" on users for update using (auth.uid() = id);

-- Policies: Meals
create policy "Users can view own meals" on meals for select using (auth.uid() = user_id);
create policy "Users can insert own meals" on meals for insert with check (auth.uid() = user_id);
create policy "Users can update own meals" on meals for update using (auth.uid() = user_id);
create policy "Users can delete own meals" on meals for delete using (auth.uid() = user_id);

-- Policies: Water Logs
create policy "Users can view own water logs" on water_logs for select using (auth.uid() = user_id);
create policy "Users can insert own water logs" on water_logs for insert with check (auth.uid() = user_id);
create policy "Users can update own water logs" on water_logs for update using (auth.uid() = user_id);
create policy "Users can delete own water logs" on water_logs for delete using (auth.uid() = user_id);

-- Policies: User Devices
create policy "Users can manage own devices" on user_devices for all using (auth.uid() = user_id);

-- 5. AUTOMATIC UPDATED_AT TRIGGER
create or replace function handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger tr_users_updated_at before update on users for each row execute procedure handle_updated_at();
create trigger tr_meals_updated_at before update on meals for each row execute procedure handle_updated_at();
create trigger tr_water_logs_updated_at before update on water_logs for each row execute procedure handle_updated_at();
