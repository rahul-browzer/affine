# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37 **REFUTE**.
**F38–F45 live** (8 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,735** · cum ~$18,970 · **avail ~$168.7k** |
| miner / burn | τ10 free · 0 sub · **~$223.4/h** (8) ≪$833 · free **12** |
| F38 | chall recover264 poll~12/120 (t/k OK) |
| F39–F41 | RL train / merge / RL |
| F42 | BoN train |
| F43 | **n80 @1/80** (a203; pipe aborted stale DEADMAN — retry saved) |
| F44 | **teacher recover332** launched (bare-TCACHE ENOENT) |
| F45 | tok DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 chall recover264 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL train |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 merge_lora |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL train |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 **n80 @1/80** |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 **teacher recover→train** |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 tok DL |

kh: `/tmp/mine-fNN.kh` (f44/f45: `*-1.known_hosts`). Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/king-init LoRA.
Open: H133–H139 + **H140/F45 last-N full-rank RL**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8; `--chall-repo`=/v1/models id.
**p506:** `dd87f25e` COUNT=3 blacklisted.
**p516:** F44 bare teacher TCACHE ENOENT → recover332 isolated; F43 DEADMAN still stale `06:36Z` (pipe abort; n80 via retry).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F44**: await teacher `:8000=200` → prewarm → online-DPO train.
2. **F43**: n80→decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear. Patch DEADMAN on next rent.
3. **F38**: recover264 → n80 → decision.
4. **F39–F42/F45**: train→merge→n80 / launch train.
5. Free slots → orthogonal (**not** LoRA-RL-Λ2 / BoN / DPO / F45-cell / past-king FT/raw).
