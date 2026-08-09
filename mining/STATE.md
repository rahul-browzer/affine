# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37 **REFUTE**.
**F38–F46 live** (9 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,641** · cum ~$19,030 · **avail ~$168.6k** |
| miner / burn | τ10 free · 0 sub · **~$246.6/h** (9) ≪$833 · free **11** |
| F38 | **n80 @12/80** (a203) |
| F39 | RL train (~175/200 S*) |
| F40 | **chall recover264** (poll~24/120; DEADMAN 19:42Z) |
| F41–F42 | RL / BoN train |
| F43 | **n80 @28/80** (a203) |
| F44 | online-DPO train (~step5+) |
| F45 | teacher+king loading → lastN train |
| F46 | **NEW** Genesis lastN bootstrap (p519) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 n80 @12/80 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL train |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 chall recover264 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL train |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 n80 @28/80 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 eng load |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 bootstrap |

kh: `/tmp/mine-fNN.kh`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/king-init LoRA.
Open: H133–H141. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8; `--chall-repo`=/v1/models id.
**p506:** `dd87f25e` COUNT=3 blacklisted.
**p519:** rented F46 Genesis×lastN; soft=21:02Z deadman=21:32Z.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F43 / F38**: n80→decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F40**: recover264→n80→decision (DEADMAN=19:42Z).
3. **F44/F45/F46**: await train/bootstrap → merge → n80.
4. **F39/F41/F42**: train→merge→n80.
5. Free slots → orthogonal (**not** LoRA-RL-Λ2 / BoN / DPO / lastN-cell / past-king FT/raw).
