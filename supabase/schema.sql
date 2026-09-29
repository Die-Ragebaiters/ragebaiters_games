-- Ragebaiters Gaming: im Supabase SQL Editor einmal ausführen.
create extension if not exists pgcrypto;

create table public.games (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 100),
  status_label text not null default 'IN ENTWICKLUNG',
  description text not null default '',
  accent text not null default 'cyan' check (accent in ('cyan', 'coral', 'acid')),
  short_code text,
  tags text[] not null default '{}',
  url text,
  sort_order integer not null default 0,
  is_active boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.bug_reports (
  id uuid primary key default gen_random_uuid(),
  game_id uuid references public.games(id) on delete set null,
  title text not null check (char_length(title) between 1 and 120),
  description text not null check (char_length(description) between 1 and 4000),
  severity text not null default 'medium' check (severity in ('low','medium','high','critical')),
  reporter_contact text,
  status text not null default 'open' check (status in ('open','in_progress','resolved','closed')),
  admin_note text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create or replace function public.set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;
create trigger games_updated_at before update on public.games for each row execute function public.set_updated_at();
create trigger bug_reports_updated_at before update on public.bug_reports for each row execute function public.set_updated_at();

alter table public.games enable row level security;
alter table public.bug_reports enable row level security;

-- Öffentliche Besucher dürfen nur aktive Games lesen und Fehler anonym einreichen.
create policy "public reads active games" on public.games for select using (is_active = true);
create policy "public submits bug reports" on public.bug_reports for insert with check (true);

-- Jeder angemeldete Supabase-Auth-Nutzer ist ein Teammitglied.
-- Falls nicht alle Auth-Nutzer Admin sein sollen, diese zwei Policies durch eine profiles/admin-Prüfung ersetzen.
create policy "team manages games" on public.games for all to authenticated using (true) with check (true);
create policy "team manages bug reports" on public.bug_reports for all to authenticated using (true) with check (true);
