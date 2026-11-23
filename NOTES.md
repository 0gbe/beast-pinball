# Beast PinBall — design notes

Title: **Beast PinBall**. Repo will be `0gbe/beast-pinball`, served at https://0gbe.github.io/beast-pinball/.
Art: the user's (@_0gbe) four 3D vinyl-toy characters. Style = soft studio render, toy-like, glossy.

## Pillars
1. **It never gets stuck.** Reliability beats everything.
2. **Rich, not simple art.** Lit inserts, glow, metal rails, plastic ramps, particles, shake, DMD.
3. **The crew is on the table, small.** Characters are toys standing on the playfield, never the background.
4. **The ball is an eye.** It rolls, looks around, blinks, dilates.

## What we borrowed from the classics
| From | Feature here |
|---|---|
| Twilight Zone / Addams Family | skill shot into blinking top lane; combos across ramps + orbit; callouts |
| Medieval Madness | center drop bank guarding the scoop ("knock the door down") |
| Attack from Mars | multiball with jackpots on ramps, super jackpot at the scoop after 2 jackpots |
| Theatre of Magic | mission progression (4 character missions → wizard-ish "Beast Mode" 2x) |
| Space Cadet / Pinball FX | readable inserts that tell you what to shoot, digital bonus table, teleport FX |
| Every Williams/Bally | slingshots, pop bumpers, spinner on orbit, kickback, ball save, tilt warnings, E-Y-E lanes w/ lane change → bonus X |

## Table layout (logical 600x1000 units, ball r=11)
* Playfield x 20..540, shooter lane 540..580 with one-way gate at the top.
* Top: E-Y-E rollover lanes (skill shot). 3 pop bumpers. Left orbit with spinner.
* Mid: left ramp (plastic, cyan) → right inlane; right ramp (wireform, magenta) → left inlane. Ramps are
  "path" shots: once the ball crosses the mouth upward fast enough it rides a spline, so it can never stall on a ramp.
* Eye scoop (center) behind a 3-bank of drop targets. Scoop awards: super jackpot > start multiball > start mission > 10K.
* Characters as standup targets: HYPNO (floral, upper left), BRIM (hat, right), HOOD (hoodie, left), RACC (raccoon, right).
  Hit all 4 → multiball lit.
* Slings, inlanes/outlanes, kickback (left outlane), one-way wire gates at both side walls that steer falling balls
  back toward the flippers (added after soak tests showed side-wall balls dropping straight into the outlanes).

## Bonus table "The Void"
Triggered when score ≥ threshold (250K, 1M, 2.5M, 5M, 8M, then +4M). Only fires when exactly one ball is in normal
play on the main table (never mid-multiball / ramp / scoop). Hypno-spiral teleport transition (from HYPNO's glasses).
60 s countdown (DMD + big on-table number + ring). Ring of 6 bumpers around a giant eye "core" bumper that watches the
ball, 12 golden eyes (one pink super eye). Drains on the bonus table are free (ball re-served from the top). 2x scoring.
Return: same transition, ball appears in the eye scoop and is kicked out with a 6 s ball save. Next threshold is at
least +250K above the current score so you can't chain teleports.

## Physics / anti-stuck
* Fixed 120 Hz game step × 8 substeps = 960 Hz collision. Velocity cap 3200 u/s → max 3.3 units per substep vs ball radius 11:
  no tunneling (verified: 1,500 max-speed wall shots + 600 max-speed flipper drops, 0 escapes).
* Flippers are swept capsules with surface velocity (ω × r) applied at the contact point.
* Friction is Coulomb-style and only on real impacts (no static friction), so balls can't "stick" on posts or slopes.
* Geometry rules learned from soak tests: no flat tops (ramp mouths have pointed roofs), no gaps narrower than
  a ball next to a toy (moved RACC), inlane guides end above the flipper base (no notch).
* Watchdog: ball moving < 26 units in 4 s (outside the plunger, not cradled on a held flipper) → nudge; 3rd time → eject
  via the scoop (main) or re-serve (bonus). Out-of-bounds / NaN → re-serve into the shooter lane without losing the ball.

## Eyeball
Veins are 3D polylines on a unit sphere rotated by a rolling orientation matrix (axis ⟂ velocity, angle = distance / r).
Iris gaze = velocity direction when fast, nearest target when slow, the player when held in the scoop; foreshortened ellipse.
Iris striations spin with rolling distance. Impacts dilate the pupil; strong hits blink (knit balaclava eyelids, max ~1/s).
Pupil shrinks ("scared") when it's falling toward the drain.

## Leaderboard
`js/scores.js` adapter: LocalScores (localStorage) + SupabaseScores (REST, publishable key on `apikey` header) wrapped in
HybridScores (remote when configured, local fallback). Names are A-Z 0-9 and a few symbols, max 12 chars.
Recommended backend: Supabase free tier (sign in with GitHub). See backend/README.md.

## Ideas for the daily updates
* Real ramp-under/over layering with ball shadows on plastics; habitrail sounds.
* A character "mode" art cut-in on the DMD (pixelated character portraits).
* Lock-based multiball (lock 2 eyes in the scoop), mystery award, extra-ball lane.
* More bonus tables (rotate: The Void, Hat Heist, Raccoon Alley).
* Mobile haptics (`navigator.vibrate`) on flips/bumpers; nudge by device shake.
* Replay score / match animation; per-player initials with daily/weekly global boards.
* Settings: ball save time, music volume, left-handed controls.
