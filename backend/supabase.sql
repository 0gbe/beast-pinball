-- Beast PinBall global high scores (Supabase free tier).
-- Paste into Supabase Dashboard -> SQL Editor -> Run.
create table if not exists public.scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 12 and name ~ '^[A-Z0-9 _.!?-]+$'),
  score bigint not null check (score >= 0 and score <= 999999999),
  created_at timestamptz not null default now()
);
create index if not exists scores_score_idx on public.scores (score desc);

alter table public.scores enable row level security;

-- Anyone may read the board.
create policy "scores are public" on public.scores
  for select to anon, authenticated using (true);

-- Anyone may add a score (no updates / deletes from the browser).
create policy "anyone can add a score" on public.scores
  for insert to anon, authenticated with check (true);

grant select, insert on public.scores to anon, authenticated;

-- Optional: global "Today's Challenge" board. Create it, then set dailyTable: 'daily_scores' in js/config.js.
create table if not exists public.daily_scores (
  id bigint generated always as identity primary key,
  day date not null,
  name text not null check (char_length(name) between 1 and 12 and name ~ '^[A-Z0-9 _.!?-]+$'),
  score bigint not null check (score >= 0 and score <= 999999999),
  secs int not null check (secs >= 0 and secs <= 86400),
  created_at timestamptz not null default now()
);
create index if not exists daily_scores_day_idx on public.daily_scores (day, score desc);
alter table public.daily_scores enable row level security;
create policy "daily scores are public" on public.daily_scores
  for select to anon, authenticated using (true);
create policy "anyone can add a daily score" on public.daily_scores
  for insert to anon, authenticated with check (true);
grant select, insert on public.daily_scores to anon, authenticated;
