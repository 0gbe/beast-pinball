# Beast PinBall

A browser pinball game by **Ogbe (@_0gbe)**, starring the vinyl-toy crew and an eyeball for a ball.

**Play:** https://0gbe.github.io/beast-pinball/

* Static site, no build step. All paths are relative (works from the `/beast-pinball/` sub-path).
* Character sprites are embedded as data URIs inside `js/beast-pinball.js`, so the repo is text-only.
* Controls: `Z` / Left Shift = left flipper, `/` / Right Shift = right flipper, hold `Space` = plunger,
  `X` `.` `↑` = nudge, `P` pause, `M` sound. On phones: tap left/right half, hold bottom-right to plunge.
* High scores are saved per device until a Supabase project is connected; see `backend/README.md`
  and paste the project URL + publishable key into `js/config.js`.

## Files
```
index.html (page + styles)
js/beast-pinball.js  the whole game in one file, sections in this order:
  assets-data (sprites as data URIs), physics (960 Hz collisions), tables, eyeball,
  dmd (dot-matrix), audio (Web Audio synth), scores (high score adapters), render, game
js/config.js         leaderboard config (Supabase URL + publishable key)
backend/             Supabase SQL + setup guide;  NOTES.md design notes;  CHANGELOG.md
```

Local play: `python3 -m http.server` in this folder, then open http://localhost:8000/
