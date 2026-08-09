# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F36 **REFUTE**.
**F37–F43 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,886** · cum ~$18,820 · **avail ~$168.9k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$186.7/h** (7 mine-*) ≪ $833/h · free slots **13** |
| F37 | **n80 @50/80** (bh=a203) healthy t/k/c=200 |
| F38 | train DONE 189 steps (mean_r_last20=−0.061); **merge save live** |
| F40 | RL ~110/200; **king recover p512 live** (prior ABORT left shm hang) |
| F41 | RL retrain live (teacher:200) |
| F42 | BoN train live (max_steps=150) |
| F43 | DPO done; **merge LoRA live** (shard write) |
| F39 | RL train live |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 **n80 ~50/80** |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 **merge→n80** |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL train |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 RL + **king332 p512** |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL retrain |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 **merge→n80** |

kh: per-pod `/tmp/mine-fNN.kh` (host-key churn). Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F36**/king-init LoRA.
Open: H132–H136 RL + H137 BoN-CE + **H138/F43 offline DPO**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p512:** F40 king shm-hang after ABORT → re-fire king332 (train untouched).
**p511:** F41 teacher:200 + retrain mean_r≠0; not tear.
**p506:** `dd87f25e`/golden-wolf-48 COUNT=3 — blacklisted.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F37**: await n80 → decision; if m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F40**: await king332 p512 promptable (:8001=200); train→merge→n80.
3. **F38/F43**: await merge.done → chall serve → n80.
4. **F39/F41/F42**: train→merge→n80.
5. Free slots → **orthogonal family** (not RL-Λ2 base; not BoN cell; not past-king FT/raw).
