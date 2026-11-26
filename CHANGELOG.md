# Changelog

## v1.6 — 2026-11-26
* Totally original sound: every sound in the game was replaced by a new, cohesive set designed and rendered from scratch with our own synthesis code (`tools/sound/`). No samples, presets, sound libraries or third-party audio. The sound is wet and watery (bubbles, drips, plinks), with vinyl-toy knocks and squeaks and punchy MPC/SPD-style drums.
* 38 game sounds (61 files with variations) covering flippers, bumpers, slings, drops, spinner, lanes, ramps, scoop, toys, Beast Wake-Up, Beast Party drum, multiball, jackpots, the Void teleport, the Void ticks, the heartbeat, drain, ball save, launch, Today's Challenge, high score, tilt and the menu buttons. Plus a new music engine: a swung boom-bap groove for the main table and a half-time watery groove for the Void, sequenced live from the rendered kit, so it never loops exactly.
* Mixed and mastered: every sound is loudness-matched per category, cleaned with EQ, gently compressed and limited to -1.5 dBTP (each file is -1.0 dBTP or lower after encoding). In the game there are category buses, music ducking under big moments, a shared reverb, stereo placement by table position, small pitch/level changes on every hit, voice limits, and a master glue compressor, limiter and soft clipper, so a 4-ball multiball pile-up never clips. A rendered gameplay capture measures -16.3 LUFS integrated with a -2.5 dBFS peak.
* The spoken callouts (browser text-to-speech voices, which aren't ours) are retired. Stingers now carry those moments: combo, lit, mission, beast mode, ball saved, challenge complete, welcome to the Void.
* Sounds are embedded as base64 Opus with an MP3 fallback for Safari and older iOS (1.3 MB). They are decoded at page load, and iOS audio still unlocks on the first tap.

## v1.5 — 2026-11-25
* Heartbeat Drain: when the ball heads for the drain (the moment the eyeball's pupil shrinks in fear), a soft synthesized heartbeat plays and the table edges pulse a dim red. At most one beat every 0.9 s. It fades out quickly when the ball is saved, and stops when it drains, on pause and at game over. The plunger lane never triggers it.
* Share Your Score: a SHARE ON X button on the game-over screen opens a ready-to-post X message (x.com/intent/post) with your score, today's challenge name and whether you beat it, and the game link. Phones use the system share sheet when available and fall back to the X link. Works with mouse, touch and keyboard (Enter/Space on the button) and doesn't touch the name entry or the high score list.
## v1.4 — 2026-11-25
* Eye Mood: the eyeball's iris follows your combo streak. Calm (the classic look) normally, a focused electric-blue iris on a 2X combo, and a bloodshot red "frenzy" glow at 3X and up. It eases back to calm a couple of seconds after the combo ends.
* Beast Wake-Up: each of the 4 toys on the main table wakes up (glows, brightens and hops) when you hit it or the shot right next to it: Hypno = left orbit, Brim = right ramp, Hood = left inlane, Racc = right inlane. Wake all 4 for a BEAST PARTY: dot-matrix callout, synthesized drum hit, 75,000 (+25,000 for each further party in a game, up to 200,000). The toys go back to sleep after the party and at the start of every ball.
* Today's Challenge: one goal per day, picked from the date (Puerto Rico time) out of 10 (Ramp Rush, Void Walker, Wake the Beasts, Bumper Bash, Spin Doctor, Drop Zone, Toy Tapper, Combo Craze, Multiball Mania, Half a Million). Shown on the title screen and the dot-matrix attract loop, with a progress line on the apron while you play. Finishing it gives +100,000 and a callout. Games that finish it go on a "Today's Challenge" board (name, score, time to finish), saved on this device. A global Supabase board is optional and off by default.
## v1.3 — 2026-11-25
* The Void: a soft tick plays once per second during the last 5 seconds of the countdown (5, 4, 3, 2, 1).

## v1.2 — 2026-11-23
* Removed the art credits that named Ogbe as the artist (title screen, playfield apron, dot-matrix attract page, page description, README). The game credit "by Ogbe" stays.

## v1.1 — 2026-11-23
* The Void bonus round now lasts 19 seconds (was 60). Countdown, ring and DMD timer match; 6 s ball save on return kept.
* Title screen shows "Beast PinBall" with "by Ogbe" underneath; dot-matrix attract mode shows "BY OGBE".

## v1 — 2026-11-23
First playable version of **Beast PinBall**.
* Main table: 3 pop bumpers, 2 slingshots, E-Y-E top lanes with skill shot + lane change → bonus multiplier (up to 6X),
  left orbit + spinner, left plastic ramp and right wireform ramp (cross-feeding the inlanes), eye scoop,
  3-bank drop targets, 4 character standup toys, kickback, ball save, tilt with 2 warnings, combos, 4 missions,
  Beast Multiball (3 balls, jackpots, super jackpot), Beast Mode 2x, extra ball, end-of-ball bonus.
* Bonus table "The Void" at 250K / 1M / 2.5M / 5M / 8M …: 60 s (19 s from v1.1), golden eyes, giant watching eye bumper.
* Eyeball ball: rolling veins, gaze, spinning iris, dilation, blinking.
* 128x32 orange dot-matrix display with attract mode; Web Audio synth SFX + music; speech callouts.
* Keyboard + touch controls; portrait layout scales to any screen.
* High scores with name entry (local now; Supabase-ready global adapter).
