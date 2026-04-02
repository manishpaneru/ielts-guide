-- ============================================================
--  Learn With Trang — Supabase Schema
--  Run this in the Supabase SQL Editor (once, on a fresh project)
-- ============================================================

-- ── Test history ─────────────────────────────────────────────
create table if not exists test_history (
  id           uuid        default gen_random_uuid() primary key,
  session_id   text        not null,
  user_id      uuid        references auth.users(id) on delete set null,
  section      text        not null,
  band         numeric(3,1),
  correct      integer,
  total        integer,
  time_taken   integer,
  wrong_answers jsonb,
  created_at   timestamptz default now()
);

alter table test_history enable row level security;

create policy "Anyone can insert history"
  on test_history for insert with check (true);

create policy "Anyone can read history"
  on test_history for select using (true);

create policy "Authenticated can delete history"
  on test_history for delete using (auth.role() = 'authenticated');


-- ── App data (admin content, packages, hidden items, etc.) ───
create table if not exists app_data (
  key         text        primary key,
  value       jsonb       not null default '{}',
  updated_at  timestamptz default now()
);

alter table app_data enable row level security;

create policy "Anyone can read app data"
  on app_data for select using (true);

create policy "Authenticated can insert app data"
  on app_data for insert with check (auth.role() = 'authenticated');

create policy "Authenticated can update app data"
  on app_data for update using (auth.role() = 'authenticated');

create policy "Authenticated can delete app data"
  on app_data for delete using (auth.role() = 'authenticated');


-- ── Student profiles ──────────────────────────────────────────
create table if not exists profiles (
  id          uuid        primary key references auth.users(id) on delete cascade,
  name        text        not null,
  email       text        not null,
  role        text        not null default 'student',
  created_at  timestamptz default now()
);

alter table profiles enable row level security;

create policy "Users can read all profiles"
  on profiles for select using (auth.role() = 'authenticated');

create policy "Users can insert own profile"
  on profiles for insert with check (auth.uid() = id);

create policy "Users can update own profile"
  on profiles for update using (auth.uid() = id);


-- ── Practice results (mini quiz scores) ──────────────────────
create table if not exists practice_results (
  id           uuid        default gen_random_uuid() primary key,
  user_id      uuid        references auth.users(id) on delete set null,
  session_id   text,
  package_id   text        not null,
  package_name text,
  score        integer,
  total        integer,
  wrong_answers jsonb,
  created_at   timestamptz default now()
);

alter table practice_results enable row level security;

create policy "Anyone can insert practice results"
  on practice_results for insert with check (true);

create policy "Anyone can read practice results"
  on practice_results for select using (true);
