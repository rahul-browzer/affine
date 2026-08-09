# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F3/F6–**F8** **REFUTE**.
**F4+F9–F15 live** (8 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,833** · cum ~$14,550 · **avail ~$172.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$271.3/h** (8 mine-*) ≪ $833/h · free slots **12** |
| F9 / F4 | n80 d203 **~72/80** · **~68/80** (nearest screens) |
| F10 | **recover264 live** (p422 Triton ENOENT FALSE_PROBE) |
| F11 / F12 | post_train (chall load) · merge_lora live |
| F13 / F14 | train live · train live |
| F15 | bootstrap |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 n80 d203 ~68/80 |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | F9 n80 d203 ~72/80 |
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 recover264→n80 |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 post_train |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 merge |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 train |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 train |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F3/F6–F8**/king-init refs.
Open: H100/F4 H104/F9 H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
recover264=chall; king-only relaunch; seed chall from **pathfile** then king TCACHE.
**Fixed `watch_n80_retry`** (`retry_${hyp}_n80*`). **king_recover = live Tok af10**.
**H32:** drop a203+c203; `retry_*_d203first`. Kill longwait by PID before re-arm.
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Await F9 screen** (~72/80) → m>+0.015 CONFIRM k=4; m≤0/gate → tear.
2. Then F4 (~68/80). Confirm F10 recover264 → chall :8002=200 → n80 d203.
3. F11–F15→n80. Free slot: rent **F16** (af-k1) if burn≪833 and no CONFIRM;
   else hold CONFIRM slots.
