# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9** **REFUTE**.
**F10–F15 live** (6 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,368** · cum ~$15,394 · **avail ~$172.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 e203** ~20/80 @01:47Z |
| F11 | **king435 loading** (:8001=000, ~36 GiB/GPU) + **longwait 0/360** (p436) |
| F12 | **n80 d203** ~71/80 @01:48Z (nearest done) |
| F13 | **n80 d203** ~50/80 @01:47Z |
| F14 | **n80 d203** just launched @01:47Z |
| F15 | **n80 e203** ~1/80 (d203 FP→e203); watcher **d203first** (p436) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 e203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **king435 + longwait** |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203 ~71/80** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80 d203** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80 d203** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 **n80 e203** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p436:** F15 recover264 rearmed bare a203 → killed+repointed **d203first** (live e203 duel kept);
templates F10–F15 `relaunch_chall_pass264` patched. F11 e203 wait@56/120 → **longwait 360**
while king435 loads (seeded n_so=24, util=0.72). Next earner: **af-k1**→**F16** after tear.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F12 n80** (~71/80) → margin; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. **Poll F11** `:8001=200` + promptable + `h106_king_recover_pass435.done`; confirm longwait launches n80.
3. **Poll F10/F13/F14/F15** → same decision rule (F15 mid e203 after d203 FP).
4. Hold CONFIRM slots; F16 after a tear.
