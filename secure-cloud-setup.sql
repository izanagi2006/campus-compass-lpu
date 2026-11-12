-- Campus Compass secure account + public community schema
-- Run once in the Supabase SQL Editor for the configured project.
-- Browser code must use the publishable/anon key only. Never expose service_role.

create extension if not exists pgcrypto;

create table if not exists public.cc_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  course text not null default '',
  batch text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.cc_private_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{"roadmap":"frontend","checks":[]}'::jsonb,
  updated_at timestamptz not null default now()
);

-- Public contributions are readable by everyone; only signed-in users may publish.
-- The payload must contain public content only. Do not include email addresses or private profile fields.
create table if not exists public.cc_public_posts (
  id text primary key,
  payload jsonb not null,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

-- Community-added companies are public to read and require a signed-in author to add.
create table if not exists public.cc_companies (
  id text primary key,
  payload jsonb not null,
  created_by uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.cc_profiles enable row level security;
alter table public.cc_private_data enable row level security;
alter table public.cc_public_posts enable row level security;
alter table public.cc_companies enable row level security;

-- A student can read and change only their own profile.
drop policy if exists "Students read own profile" on public.cc_profiles;
create policy "Students read own profile" on public.cc_profiles for select to authenticated using (auth.uid() = id);
drop policy if exists "Students insert own profile" on public.cc_profiles;
create policy "Students insert own profile" on public.cc_profiles for insert to authenticated with check (auth.uid() = id);
drop policy if exists "Students update own profile" on public.cc_profiles;
create policy "Students update own profile" on public.cc_profiles for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Roadmap and personal progress are private to the account owner.
drop policy if exists "Students read own private data" on public.cc_private_data;
create policy "Students read own private data" on public.cc_private_data for select to authenticated using (auth.uid() = user_id);
drop policy if exists "Students insert own private data" on public.cc_private_data;
create policy "Students insert own private data" on public.cc_private_data for insert to authenticated with check (auth.uid() = user_id);
drop policy if exists "Students update own private data" on public.cc_private_data;
create policy "Students update own private data" on public.cc_private_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- All visitors can read public community posts. Only authenticated authors can create posts.
drop policy if exists "Everyone reads community posts" on public.cc_public_posts;
create policy "Everyone reads community posts" on public.cc_public_posts for select to anon, authenticated using (true);
drop policy if exists "Signed-in students publish posts" on public.cc_public_posts;
create policy "Signed-in students publish posts" on public.cc_public_posts for insert to authenticated with check (auth.uid() = created_by);

-- Public company directory: everyone can read, signed-in students can add entries.
drop policy if exists "Everyone reads company directory" on public.cc_companies;
create policy "Everyone reads company directory" on public.cc_companies for select to anon, authenticated using (true);
drop policy if exists "Signed-in students add companies" on public.cc_companies;
create policy "Signed-in students add companies" on public.cc_companies for insert to authenticated with check (auth.uid() = created_by);

grant select on public.cc_public_posts, public.cc_companies to anon, authenticated;
grant insert on public.cc_public_posts, public.cc_companies to authenticated;
grant select, insert, update on public.cc_profiles, public.cc_private_data to authenticated;

-- Automatically create a private profile row when an account is registered.
create or replace function public.cc_handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.cc_profiles (id, full_name, course, batch)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name', ''),
    coalesce(new.raw_user_meta_data ->> 'course', ''),
    coalesce(new.raw_user_meta_data ->> 'batch', '')
  ) on conflict (id) do nothing;
  insert into public.cc_private_data (user_id)
  values (new.id) on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists cc_on_auth_user_created on auth.users;
create trigger cc_on_auth_user_created
after insert on auth.users
for each row execute procedure public.cc_handle_new_user();
