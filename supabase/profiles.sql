-- Run this in the Supabase SQL editor (Dashboard > SQL Editor) for the
-- dehfiaibuvconewthtoo project. The anon key the app ships with can't
-- run DDL, so this can't be applied from the client.
--
-- One row per authenticated user, keyed to auth.users(id). Row-level
-- security restricts every operation to the owning user, so the anon-key
-- client can only ever see or touch its own row.

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null check (char_length(trim(display_name)) > 0),
  avatar_style text not null check (avatar_style in ('a1', 'a2', 'a3', 'a4', 'a5')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Individuals can view their own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Individuals can insert their own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

create policy "Individuals can update their own profile"
  on public.profiles for update
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- No delete policy: there's no account-deletion flow in the app yet, so
-- rows are only removable via the auth.users cascade above. Add one here
-- if/when a "delete my account" feature ships.

-- Keep updated_at current on every update.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
  before update on public.profiles
  for each row
  execute function public.set_updated_at();
