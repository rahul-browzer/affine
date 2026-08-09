# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F3/F6–**F8** **REFUTE**.
**F4+F9–F14 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,833** · cum ~$14,518 · **avail ~$172.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$239.4/h** (7 mine-*) ≪ $833/h · free slots **13** |
| F4 / F9 | n80 d203 ~48/80 · **~59/80** (nearest) |
| F10 / F11 | chall :8002 load · merge live |
| F12 / F13 / F14 | train · train · bootstrap Bittob (p420) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 n80 d203 |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | F9 n80 d203 |
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 chall→n80 |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 merge |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 train |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 train |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F3/F6–F8**/king-init refs.
Open: H100/F4 H104/F9 H105–H109/F10–F14. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
recover264=chall; king-only relaunch; seed chall from **pathfile** then king TCACHE.
**Fixed `watch_n80_retry`** (`retry_${hyp}_n80*`). **king_recover = live Tok af10**.
**H32:** drop a203+c203; `retry_*_d203first`. Kill longwait by PID before re-arm.
Next unused earner: everest12 / af-k1 → **F15**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Await F9 screen** (~59/80) → m>+0.015 CONFIRM k=4; m≤0/gate → tear.
2. Then F4 d203 (~48/80). F10 chall→n80; F11 merge→n80; F12–F14→n80.
3. Free slot: rent **F15** (everest12/af-k1) if burn≪833 and no CONFIRM
   demand; else hold CONFIRM slots.
