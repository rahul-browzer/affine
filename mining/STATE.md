# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F36 **REFUTE**.
**F37–F44 live** (8 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,830** · cum ~$18,876 · **avail ~$168.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$214.7/h** (8 mine-*) ≪ $833/h · free slots **12** |
| F37 | **n80 @60/80** (bh=a203) healthy t/k/c=200 |
| F38 | merge.done; **chall :8002 loading** (push+serve) |
| F40 | RL ~120/200; king332 recover live (:8001 loading) |
| F41 | RL retrain ~35/200 |
| F42 | BoN ~30/150 |
| F43 | DPO done; **merge shard write** |
| F39 | RL ~120/200 (S* reward live) |
| F44 | **bootstrap/pip** (online DPO screen) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 **n80 ~60/80** |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 **chall load→n80** |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL train |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 RL + king332 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 RL retrain |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 **merge→n80** |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 **bootstrap** |

kh: `/tmp/mine-fNN.kh` (f44: `/tmp/mine-f44-1.known_hosts`). Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F36**/king-init LoRA.
Open: H132–H136 RL + H137 BoN-CE + H138 offline DPO + **H139/F44 online DPO**.
F5 needs traj. FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p512:** F40 king recover still settling. **p506:** `dd87f25e` COUNT=3 blacklisted.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F37**: await n80 → decision; if m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F38/F43**: await chall:200 → n80; **F44**: await bootstrap→teacher→train.
3. **F40**: await king332 promptable; train→merge→n80.
4. **F39/F41/F42**: train→merge→n80.
5. Free slots → **orthogonal family** (not RL-Λ2 base; not BoN/DPO cell; not past-king FT/raw).
