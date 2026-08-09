# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37 **REFUTE**.
**F38–F47 live** (10 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,611** · cum ~$19,060 · **avail ~$168.6k** |
| miner / burn | τ10 free · 0 sub · **~$278.6/h** (10) ≪$833 · free **10** |
| F38/F43/F40 | n80 @19/80 · @38/80 · started 10:04Z |
| F39/F41/F42 | RL / RL / BoN train |
| F44/F45 | online-DPO · lastN RL train |
| F46/F47 | Genesis lastN boot · **raw Coder boot (p520)** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 n80 @19/80 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL train |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 live |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL train |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 n80 @38/80 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 lastN RL |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 bootstrap |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 coder boot |

kh: `/tmp/mine-fNN.kh`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/king-init LoRA.
Open: H133–H142. F5 needs traj. FALSE_PROBE≠REFUTE; COUNT>=8.
**p506:** `dd87f25e` COUNT=3 blacklisted.
**p520:** rented F47 raw Qwen3-Coder; soft=21:07Z deadman=21:37Z.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F43 / F38 / F40**: n80→decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F47**: await DL+serve → n80 raw Coder screen.
3. **F44/F45/F46**: await train/bootstrap → merge → n80.
4. **F39/F41/F42**: train→merge→n80.
5. Free slots → orthogonal (not LoRA-RL-Λ2 / BoN / DPO / lastN / past-king FT/raw-Albedo).
