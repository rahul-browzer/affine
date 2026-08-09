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
| Lium / spend | **~$182,464** · cum ~$15,298 · **avail ~$172.5k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 d203** ~50/80 @01:29Z |
| F11 | **n80 e203** ~11/80 @01:31Z |
| F12 | **n80 d203** ~47/80 @01:30Z |
| F13 | **n80 d203** ~22/80 @01:31Z |
| F14 | **n80 e203** live (salvage a1 warmups OK; d203 was FP) |
| F15 | **CPU merge→/tmp** p432 (preempted gocryptfs hang) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 d203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80 e203** |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80 d203** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80 e203** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 merge432→/tmp |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p432 F15:** calm-wolf `/root`=gocryptfs; GPU-auto save hung WCHAN=request_wait_answer
@.tmp≈49.7 GiB — killed + `merge_recover_pass432.sh` (contig+/tmp). Do **not**
let post_train GPU-merge to `/root` on gocryptfs hosts.
**F14:** salvage a1 health+comp 200 → e203 n80; recover still finishing warmups.
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F10/F12 n80** (near done) → margin; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. **Poll F11/F13/F14 n80** → same decision rule.
3. **F15:** wait merge432 DONE → SKIP_MERGE post_train → chall+n80 d203.
4. Hold CONFIRM slots; F16 after a tear.
