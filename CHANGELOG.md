# Changelog

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
* Tested (outside this repo): 60-min fast-forward soak, tunneling stress test, shot map, real-time end-to-end runs.
