# Global high scores for Beast PinBall

The game is a static site (GitHub Pages). Scores are stored by the high score adapter in `js/beast-pinball.js`:

* **Default:** `localStorage` (each browser keeps its own board).
* **Global:** fill in `js/config.js` with a Supabase project URL and *publishable* key and every
  player sees the same board. If Supabase is unreachable the game silently falls back to local.

## One-time Supabase setup (free plan, about 5 minutes)

1. Go to https://supabase.com and click **Start your project → Continue with GitHub**
   (sign in with the `0gbe` GitHub account; no credit card needed on the Free plan).
2. **New project** → name `beast-pinball`, pick any region close to players, set a DB password (save it).
3. Dashboard → **SQL Editor** → paste `backend/supabase.sql` → **Run**.
4. Dashboard → **Connect** (or Project Settings → API Keys) → copy the **Project URL** and the
   **Publishable key** (`sb_publishable_…`). Never use the `sb_secret_…` key in the game.
5. Paste them into `js/config.js`, commit, push. Done.

Notes
* Free projects pause after ~7 days with little database activity; a few games a day keeps it
  awake. If it pauses, click **Resume project** in the dashboard (data is kept). The game keeps
  working with local scores while paused.
* Browser games can't fully stop a determined cheater from posting a fake score. The table
  constraints cap names/scores; you can delete bad rows in the Table Editor at any time.
