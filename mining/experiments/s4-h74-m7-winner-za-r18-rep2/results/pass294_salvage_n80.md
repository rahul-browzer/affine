# H74 pass294 — recover264 salvage → n80 vs Tok

**UTC:** 2026-08-08T11:12Z–11:29Z · pod `mine-h74-1` / brave-orbit-28

## What happened
- p293 left recover264 loading isolated chall (bare → preempt).
- Attempt1: health=200 @ poll=33 (11:18:52Z); settle 60s; writable diverse w1
  → Triton ghost ENOENT
  `EAUHKKZRGQP45BZT…/__triton_launcher…so` @11:19:54Z; urllib hung ~180s;
  n_so **16→22**.
- **SALVAGE:** freeze same TCACHE mode=555; relaunch chall_pid=20134;
  health=200 @ poll=31 (11:28:01Z); salvage w1/w2/w3 all **200**;
  triple-promptable → rearm form+watch_n80_retry @11:29:17Z.
- Markers: `h74_chall_freeze_pass264.done`, `h74_chall_serve.done`.
- TCACHE=`/root/.triton/isolated/h74_chall_p260_a1_1786187602_17163`
  mode=555 n_so=22.

## n80
- `run_sim_duel.py` live vs `Tok331102/affine-5EqYW8McUc-af10`
  @ `eb8bf9a…` block-hash **a203** · chall `/root/h74/merged`.
- Progress just started (no decision yet).

## Decision
Continue await `h74_decision.json`. FALSE_PROBE≠REFUTE; salvage path OK.
