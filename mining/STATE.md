# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9** **REFUTE**.
**F10–F15 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,625** · cum ~$15,138 · **avail ~$172.6k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 d203** ~15/80 @01:06Z |
| F11 | FALSE_PROBE×2 quarantined; **n80 d203 relaunched** @01:07Z |
| F12 | **n80 d203** ~5/80 @01:06Z |
| F13 | CPU merge recover393 (shard write live) |
| F14 | **CPU merge recover393** after GPU save hang (p428) |
| F15 | train early + teacher.done; king DL pending |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 d203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80 d203** (post-FP) |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 CPU merge → post_train |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 CPU merge recover393 |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 train |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
recover264=chall; king-only relaunch; seed chall from **pathfile** then king TCACHE.
**Fixed `watch_n80_retry`** (`retry_${hyp}_n80*`). **king_recover = live Tok af10**.
**H32:** drop a203+c203; `retry_*_d203first`. Kill longwait by PID before re-arm.
**p428 F14:** GPU merge save hang (tmp=49.7 GiB, write_bytes=4096) →
`merge_recover_pass393.sh` CPU merge live → SKIP_MERGE=1 post_train.
**p428 F11:** 2nd FALSE_PROBE (chall 400) quarantined; d203 n80 rearmed @01:07Z.
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F10 + F12 n80** → margin; if >+0.015 CONFIRM k=4; if ≤0 REFUTE+tear.
2. **F11:** watch n80 d203; if FALSE_PROBE again → recover264 (chall) + d203 rearm.
3. **F13/F14:** wait CPU merge DONE → SKIP_MERGE post_train → freeze → n80 d203.
4. F15 train→merge→n80. Hold CONFIRM slots; F16 after a tear.
