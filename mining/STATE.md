# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37/**F43** **REFUTE**.
**F38–F42, F44–F47 live** (9 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish F38–F47, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,429** · cum ~$19,308 · **avail ~$168.4k** |
| miner / burn | τ10 free · 0 sub · **~$246.6/h** (9) ≪$833 · free **11** |
| F38 | n80 @66/80 (a203) — next decision |
| F39 | n80 @2/80 (a203) |
| F40/F41 | n80 @31/80 b203 · @11/80 d203 |
| F42 | BoN train ~step130/150 (mean_r oscillating) |
| F44 | online-DPO ~step57 (many gap-skips) |
| F45/F46 | lastN RL ~step80 / training |
| F47 | **n80 LIVE** d203 @1/80 (p525: king shm→health; eng 200×3) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 n80 @66/80 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 n80 @2/80 |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 @31/80 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 n80 @11/80 |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 lastN RL |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 gen-lastN RL |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 n80 d203 @1/80 |

kh: `/tmp/mine-fNN.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/F43/king-init LoRA.
F47 chall bare TCACHE n_so~7 (king n_so≥22) — watch mid-n80 Triton; king478 needs seed≥16.

## Next action

1. **F38** (~66/80) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear (no replace).
2. **F47** n80 → decision same rule (first non-Albedo base).
3. **F40/F41/F39**: n80→decision.
4. **F42/F44/F45/F46**: train→merge→n80; tear on resolve, do not backfill.
