# Beast PinBall — design notes

Title: **Beast PinBall**. Repo will be `0gbe/beast-pinball`, served at https://0gbe.github.io/beast-pinball/.
Art: four 3D vinyl-toy characters (Ogbe's NFTs; Ogbe is not the artist, so never credit the art to him). Style = soft studio render, toy-like, glossy.

## Pillars
1. **It never gets stuck.** Reliability beats everything.
2. **Rich, not simple art.** Lit inserts, glow, metal rails, plastic ramps, particles, shake, DMD. From v1.7 the bar is @akidcalledbeast's own game: wet street, reflections, grounded shadows, chunky neon HUD.
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
19 s countdown (was 60 s in the first build; shortened at Ogbe's request) (DMD + big on-table number + ring). Ring of 6 bumpers around a giant eye "core" bumper that watches the
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

## v1.4 features (how they work)
* Eye Mood: `G.eyeMood` 0..2 eases toward the combo target (2X combo = 1 focused, 3X+ = 2 frenzy) while the 4 s combo window is open, then back to 0 at 0.8/s. `drawEye` uses the original colours when mood is 0 (tested pixel-identical to v1.3).
* Beast Wake-Up: `G.beastsAwake[4]` is separate from the multiball `charsLit`. Triggers: toy hit, or HYPNO = left orbit (upward spinner shot), BRIM = right ramp, HOOD = left inlane, RACC = right inlane. Party = 75K + 25K per extra party (cap 200K), 2.5 s, then reset; reset each ball.
* Daily Challenge: `challengeFor(day)` = FNV hash of the Puerto Rico date into the 10-goal pool, never the same goal two days running. Board: localStorage `beastPinball.daily.v1` (last 14 days); optional Supabase table `daily_scores` when `dailyTable` is set in config.js. Achievability is checked with `tests/daily-tune.mjs` (autoplay completion rates).

## v1.5 features (how they work)
* Heartbeat Drain: `heartbeat()` runs each step; danger = any ball in play with y > 900, vy > 300, not in the plunger lane (the same test as the scared pupil). One `heartbeat` SFX per 0.9 s at most; `G.heartPulse` drives a dim red edge gradient and fades at 4/s once the danger ends. It is cleared on drain, pause and game over.
* Share Your Score: `shareText()` = "I scored N on Beast PinBall by @_0gbe" + today's challenge result + "Can you beat it?" (game credit only; never an art credit). Desktop opens `https://x.com/intent/post?text=…&url=https://0gbe.github.io/beast-pinball/`. Coarse-pointer devices try `navigator.share` first (a cancel counts as done) and fall back to the intent URL. Focused overlay buttons keep native Enter/Space.

## v1.6 sound (how it works)
* **Everything is original.** Each sound is generated by our own Python DSP (`tools/sound/dsp.py`, numpy/scipy only) in `tools/sound/design.py`. Techniques: modal and FM synthesis, Karplus-Strong, a Minnaert bubble model for the wet sounds, polyBLEP oscillators, filter sweeps, transient shaping, tape saturation, and convolution reverb with IRs we generate ourselves. No samples. Renders are deterministic (seeded with crc32 of name and variant).
* **Pipeline:** `python3 tools/sound/design.py` renders `sound-masters/*.wav` (48 kHz mono, plus report.json). Then `python3 tools/sound/encode.py` makes Opus (48 kbps; 56 for keys and pad) and MP3 (LAME V6), checks the decoded true peak of every file (≤ -1.0 dBTP, re-trimming if needed) and writes `js/sounds-data.js` (`window.BEAST_SOUNDS = {opus, mp3}`, base64). `node tests/audio-demo.mjs` renders `audio-demo/gameplay-demo.*` and `audio-demo/sound-board.*` through the real game audio graph in an OfflineAudioContext. Headless real-time audio is too slow to record, so the events from a fast-forwarded autoplay are logged and rendered sample-exactly.
* **Mastering per sound:** HP/DC cleanup, category EQ (frequency slots: flippers and hits in the low-mid "thock", spinner and ticks up top, stingers full range, music carved at 2.5 kHz), gentle 2:1 compression, then loudness normalized to a category target (momentary-max LUFS: flip -20.5, hit -18.5, spin -27, tick -25, heart -23, stinger -15, big -13.5, warn -17, ui -25, music kit -19, ambience -30), and a true-peak limiter at -1.5 dBTP.
* **Runtime (`js/audio.js`):**
  * `DEF` sets each sound's bus, gain, pitch/velocity drift, max voices, retrigger gap, stereo width, reverb send and music duck depth.
  * Variants play round-robin with a random pick.
  * Graph: category buses → master EQ → glue compressor (-20 dB, 2:1) → -5 dB trim (the compressor adds makeup gain) → limiter (-4 dB, 20:1, 1 ms) → 4x-oversampled soft clipper (ceiling -1.2 dBFS) → mute gain.
  * Music bus: -9.5 dB, EQ dip at 2.5 kHz, ducked by stingers.
  * Sounds are decoded at load on an OfflineAudioContext. The AudioContext is created on the first gesture (with a silent buffer for the iOS unlock) and resumed on later gestures and when the tab becomes visible.
  * If the browser can't decode Opus it uses the MP3 set.
  * `callout()` is now a no-op.
* **Music:** `SONGS.main` is 92 BPM boom-bap with 60% swing (Am9-Fm9-Dm9-Em9 keys, A-minor bass, pentatonic plucks, bubbles). `SONGS.bonus` is 140 BPM half-time with phrygian plucks, a watery pad and 32nd-note hat rolls. A 25 ms lookahead scheduler runs about 0.2 s ahead, and humanized velocities and random rims and bubbles keep it from looping.
* **Loudness check (v1.6):**
  * Gameplay demo: -16.3 LUFS integrated, -2.5 dBFS peak, 0 clipped samples.
  * Music alone: about -19 LUFS.
  * Worst-case pile-up test (300+ overlapping sounds plus stingers): peak -2.0 dBFS.
* **Tests:** `node tests/v16-sound.mjs` checks decode, the MP3 fallback, that every triggered sound is mapped, gap limiting, the pile-up ceiling, that there is no TTS, mute, the iPhone 13 tap unlock, and 0 console errors.

## v1.7 visuals (how it works)
* **Reference:** @akidcalledbeast's game as seen in @Rafsby's clips (`/workspace/akcb-ref/rafsby-thumb1.jpg`, `rafsby-thumb2.jpg`): wet asphalt and wood with glossy reflections, crisp grounded shadows, chunky charcoal HUD boxes with electric cyan `#00C8FF`, acid lime `#D4FF00` and hot magenta `#FF1F8E` borders, spray-paint crowns and ticks. Palette lives in `NEON` in `js/render.js`; toy pad colours are `CHAR_NEON` (Hypno magenta, Brim lime, Hood cyan, Racc violet).
* **Layers (all in `js/render.js`):**
  * `buildBg(G, which)`: one offscreen canvas per table and scale (rebuilt on resize). Floor (`mainFloor` / `voidFloor`: `paintArt()` draws the painted playfield (see below), then a light darkening wash, the cyan ring around the painted eye at (280,652), the shooter-lane channel, and the Void's THE VOID lettering + golden-eye halos), static wet reflections (`reflect()` = additive glow streaks), neon trim, `apron()`, then soft shadows via `softShadow()` (the shape is drawn 5000 units off-canvas and only its blurred shadow lands back; works in Safari, no `ctx.filter`), chrome rails/gates/posts, sling plastics, ramp mouths, scoop, unlit inserts, toy pads (with silhouette cast shadows), bumper bases, and a light vignette last. If a toy image wasn't loaded yet, the canvas is marked `missing` and rebuilt once it is.
  * `buildFg(G)`: the acrylic ramps (tint, frosted edges, chrome side rails, screws, glints) + a faint glass streak, drawn after the playfield balls and before ramp-riding balls.
  * Per frame: cached sprites only (`sprite()` / `glow()` / `ring()`; cache cleared on resize): lit insert lenses + additive bloom, bumper floor-ring pulse + hit bloom + spinning sticker + gloss cap, flipper bat + shadow sprites (mirrored for the right bat so the highlight stays on top), toy glows/rings, ball contact shadow / reflection / gloss, golden-eye halos, flasher pools.
* **Reactive flashers:** `updateFx()` watches existing state only (bumper/sling flash rising, drop targets going down, a ball entering a ramp, `beastsAwake` count rising, Beast Party, Multiball, core-eye hits) and drives `R.fx.{cyan,lime,mag}`, decaying at 3.2/s. No game logic or scoring changes.
* **Eyeball:** `BP.drawEye` is untouched (the v1.4 test still compares it pixel-for-pixel with v1.3); the shadow, reflection and gloss are drawn around it in `frame()`.
* **The Void countdown:** number baseline y=646 (between the eyes at (200,620) and (360,620)), label at y=672 below them.
* **Painted playfields (2nd pass):** source art `assets/playfield-main-art.jpg` / `assets/playfield-void-art.jpg` (720x1280). `python3 tools/optimize-playfield-art.py` crops the part that shows on the table, scales it (main k=600/720 so the painted pupil lands on the VOID insert at table (280,650); void k=0.85 so the golden vortex lands behind the giant eye at (280,330)), softens it slightly and writes `assets/playfield-main.jpg` (~70 KB) and `assets/playfield-void.jpg` (~91 KB). `tools/build-assets-data.py` embeds them as `pfmain` / `pfvoid` JPEG data URIs. In `render.js`, `ART.main` / `ART.bonus` hold the table rect each image fills and the fallback base colour; `paintArt()` fills the base colour, draws the image and fades its bottom edge into the base. If an image isn't decoded yet the background is marked `missing` and rebuilt when it arrives. To re-align, edit the crop/scale in the optimize script and the rect in `ART`.
* **Removed in the 2nd pass:** `asphalt()`, `puddle()`, `streetPaint()`, `sprayDecals()`, `centerEye()`, the box junction / zebra / road text, and the Void's procedural ripples, spiral and rings (the painted art does that job now).
* **HUD (2nd pass, replaces the orange DMD look):** `game.js` `updateDMD()` still renders the hidden 128x32 DMD (tests read `G.dmd`) and also fills `G.hud` = `{kind:'play'|'msg'|'bonus'|'attract', ...}`. `drawHUD()` in `render.js` paints the HUD into `R.hudC` and redraws only when `JSON.stringify(G.hud)` changes. Pieces: `hudBack` (charcoal, magenta side panel behind the pause/sound buttons; its small BEAST PINBALL label is hidden when `R.hudBtnBottom` > 127, i.e. big phone buttons), `hbox` (score box with /// ticks + crown), `hpill` (slanted pills), `brushTag` (magenta brush stroke behind callouts), `htext` (italic 900, auto-fit, dark stroke + glow). Layout: box (14,10,502,82), bottom row y=100 h=36 with left (x14 w178), centre (x202 w126), right (x338 w178) pills. `hype()` adds "!" to big callouts (PARTY, MULTIBALL, JACKPOT, SKILL SHOT...), never to OVER / FAILED.
* **Perf check:** `node tests/v17-perf.mjs` (busy 3-ball scene, flashing bumpers). v1.6 baseline is kept in `tests/fixtures/render-v1.6.js` (+ `style-v1.6.css`, `index-v1.6.html`). Screens: `TAG=after node tests/v17-shots.mjs` -> `screenshots-v1/19-after-*.png`; 2nd pass `node tests/shots17b.mjs` -> `screenshots-v1/20-v17b-{main,void,mobile}.png` (`HUD=1` also writes HUD crops to /tmp).

## v1.8 features (how they work)
* **Sleepy Eye** (`game.js` `sleepyEye()` runs every physics step): `cradled(b, D)` = ball in play, speed < 60, a pressed + enabled flipper fully raised, and the ball sitting on top of it (closest point on the flipper axis < r + 12 + 5). `b.restT` counts the cradle time; from 8 s `b.droop` ramps 0..1 over 2.4 s. A new flipper press while `restT >= 8` (or within the 0.5 s grace after it rolled off) calls `wakeUp()`: `add(10000)`, `G.msg('WAKE UP!', '+10,000')`, sound `wakeup`, popup. Leaving the flipper (0.15 s grace before 8 s, 0.5 s after), drain, pause (`togglePause`) and tilt reset it via `resetSleep()`. `frameFx` eases the visual lid `b.lid` (snaps open on wake, eases open on reset); `BP.drawEye(..., { droop })` draws the lids only when droop > 0.
* **Neon Sputter**: the tilt-warning branch of `nudge()` calls `sputter()` (`G.sputterAt` / `G.sputterUntil = clock + 0.9`, sound `sputter`). `G.neonLevel()` returns 1 (steady), 0.5 or 0.12 from a deterministic stutter (first 1/26 s always dark, steady for the last 18 %). `render.js` puts it in `R.neon` each frame: `hbox` / `hpill` multiply their neon stroke + glow by it (it is part of the HUD cache key), lit inserts and flasher glows are dimmed by it, and `neonSputter()` blacks out the pre-rendered table-edge trim and apron neon on "off" frames (slightly over-bright on "on" frames). `sputterStop()` (+ `BP.audio.stop('sputter')`) runs on pause, full tilt, `startBall` and game over.
* **Next Rival**: `showEntry()` calls `showRival()`, which re-reads the board (`G.store.list(10)`) and uses `G.nextRival(score, list)`: the lowest score that is still above yours -> "GAP SHORT OF NAME"; nothing above -> "#1 NEW HIGH SCORE!" (or "TIED WITH NAME FOR #1"); score 0 -> no line. Shown in `#entry-rival` (CSS `.rival`, `.rival.top` in lime, single line with ellipsis).
* **Millionaire Wink**: `step()` calls `millionaireWink()` the first time `G.score >= 1,000,000` in a game (`G.winked`, reset by `resetGameState`). `G.winkAmount()` gives the lid curve over 0.8 s (ease shut 38 %, hold, ease open) and `G.winkLook()` blends the gaze toward the player in `frameFx` (visual `b.gx/gy` only). `drawEye(..., { wink })` draws one tilted lid + smile lash line.
* **Sounds**: `tools/sound/design.py` has `sputter` (warn, -21 LUFS), `wakeup` (stinger, -17) and `wink` (ui, -22); `python3 tools/sound/add_sounds.py sputter wakeup wink` masters and encodes only those and merges them into `js/sounds-data.js`. `BP.audio.stop(name)` fades out a playing sound.
* **Tests**: `node tests/v18-features.mjs` (all 4 features, mobile fit, 20 sim minutes of autoplay) -> `screenshots-v1/21-v18-*.png` and `test-report-v1.8.json`.

## Publishing (text-only repo)
**Live game:** https://0gbe.github.io/beast-pinball/ served by the GitHub *user site* repo **0gbe/0gbe.github.io**
(GitHub Pages publishes user-site repos from `main` automatically; the user can't sign in on the web to enable
Pages on a project repo). The game lives in the folder `beast-pinball/` of that repo; the repo root has a small
`index.html` that redirects to `beast-pinball/` and a `.nojekyll`.

**Daily update procedure**
1. Edit the dev source in `/workspace/eyeball-pinball` (split js/*.js, css/, assets/), run the tests.
2. Rebuild `publish-copy/` with `python3 tools/build-publish.py` (does all of this): `python3 tools/build-assets-data.py`, concatenate js in this order: assets-data, physics,
   tables, eyeball, dmd, sounds-data, audio, scores, render, game → `js/beast-pinball.js`; inline css/style.css into index.html;
   keep `js/config.js` separate (Supabase keys). No og:image (binary PNGs can't be pushed).
3. Re-test publish-copy in headless Chromium from a `/beast-pinball/` sub-path (0 console errors, sprites load).
4. ONE `push_files` commit to **0gbe/0gbe.github.io**, branch `main`, every path prefixed `beast-pinball/`.
   The connector allows max 4 `$file:` arguments per call, so pass the 4 big files (index.html, js/beast-pinball.js,
   README.md, NOTES.md) as `$file:` and the small ones (config.js, CHANGELOG.md, backend/*, .nojekyll) as literal text.
   Updating existing files with push_files needs no SHAs.
5. Optional mirror: same files (no prefix) to **0gbe/beast-pinball** (source mirror; Pages is NOT enabled there).
6. Poll https://0gbe.github.io/beast-pinball/ until it serves the new version (Pages builds take ~1-2 min).

## Suggested ideas
* 2026-11-24: Soft "tick" (existing audio tick sound, currently unused) once per second during the last 5 seconds of The Void countdown, synced with the red flashing number. Status: approved by Ogbe 2026-11-25, built in v1.3.
* 2026-11-25: Eye Mood: the eyeball's iris changes color with your combo streak (calm, focused, bloodshot "frenzy" glow). Status: approved by Ogbe 2026-11-25, built in v1.4.
* 2026-11-25: Blink Save: once per ball, a perfectly timed double-flip makes the eyeball "blink" and phase through the drain once. Status: passed (not chosen by Ogbe, 2026-11-25).
* 2026-11-25: Beast Wake-Up: hitting each of the 4 small characters lights them up; light all 4 for a short "Beast Party" jackpot with a drum hit. Status: approved by Ogbe 2026-11-25, built in v1.4.
* 2026-11-25: Daily Challenge: one seeded goal per day (e.g. 3 ramps in 20s) with its own mini leaderboard. Status: approved by Ogbe 2026-11-25, built in v1.4.
* 2026-11-25: Ghost Replay: a faint ghost eyeball replays the top high score's last ball on the attract screen. Status: passed (not chosen by Ogbe, 2026-11-25).
* 2026-11-25: Stare-Down Hurry-Up: knocking down all 3 drop targets starts a 150K value counting down on the DMD; shoot the eye scoop before it runs out to collect what's left. Status: passed (not chosen by Ogbe, 2026-11-25).
* 2026-11-25: Dizzy Eye: a big spinner rip (e.g. 20+ spins) makes the eyeball's iris swirl dizzily for a few seconds, and the next shot scores a "Dizzy" bonus. Status: passed (not chosen by Ogbe, 2026-11-25).
* 2026-11-25: Heartbeat Drain: when the ball heads for the drain (the existing "scared" pupil moment), a soft heartbeat thump plays and the table edges pulse dim red. Status: approved by Ogbe 2026-11-25, built in v1.5.
* 2026-11-25: Share Your Score: a Share button on game over opens a ready-to-post X message with the score, today's challenge result and the game link. Status: approved by Ogbe 2026-11-25, built in v1.5.
* 2026-11-25: Secret Beanie Code: a hidden flipper code on the title screen (e.g. L L R R L R) gives the eyeball a tiny green beanie for that game, a nod to Ogbe's own BEAST. Status: passed (not chosen by Ogbe, 2026-11-25).
* 2026-11-26: Follow the Leader: one toy flashes at a time on the main table; hit it within a few seconds and the next one lights, with the value doubling along the chain (different from Beast Wake-Up, which takes any order). Status: passed (2026-11-26).
* 2026-11-26: Called Shot: while the eyeball rests on a held flipper, its iris stares at one lit shot; make that exact shot within 3 seconds for a "Called Shot" bonus. Status: passed (2026-11-26).
* 2026-11-26: Rising Tide: soft rain ripples and drip sounds grow on the wet street puddles as your score gets close to the next Void threshold, so you can feel the teleport coming. Status: passed (2026-11-26).
* 2026-11-26: Personal Best Pace: a small line on the DMD at the start of each ball shows how far ahead or behind you are versus your own best game at that same ball. Status: passed (2026-11-26).
* 2026-11-26: Raccoon Bandit: once a game at random, RACC "steals" the lit bonus value with a cheeky squeak; hit RACC within 10 seconds to win it back doubled. Status: passed (2026-11-26).
* 2026-11-27: Gold Bumper Fever: every 50 pop-bumper hits turns the 3 bumpers gold for 10 seconds, and each hit while gold scores 5x. Status: passed (not chosen by Ogbe, 2026-11-27).
* 2026-11-27: Sleepy Eye: if the eyeball rests on a held flipper for 8+ seconds its eyelids slowly droop, and the next flip snaps it awake with a small "WAKE UP!" bonus. Status: approved by Ogbe 2026-11-27, built in v1.8.
* 2026-11-27: Neon Sputter: on each tilt warning the table's neon trim flickers and buzzes like a failing street sign for a moment, then steadies. Status: approved by Ogbe 2026-11-27, built in v1.8.
* 2026-11-27: Next Rival: the game-over screen shows the score just above yours on the high-score board and how close you came (e.g. "12,400 short of JAY"). Status: approved by Ogbe 2026-11-27, built in v1.8.
* 2026-11-27: Millionaire Wink: the first time your score passes 1,000,000 in a game, the eyeball turns to the player and gives a slow one-eyelid wink. Status: approved by Ogbe 2026-11-27, built in v1.8.
