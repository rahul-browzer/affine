# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F38/**F43** **REFUTE**.
**F39–F42, F44–F47 live** (8 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish F38–F47, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,363** · cum ~$19,372 · **avail ~$168.4k** |
| miner / burn | τ10 free · 0 sub · **~$223.4/h** (8) ≪$833 · free **12** |
| F38 | **REFUTE** m=−0.05342 z=−5.30 (p526; torn down) |
| F39 | n80 @19/80 a203 |
| F40/F41 | n80 @47/80 b203 · @22/80 d203 |
| F42 | BoN train ~step145/150 |
| F44 | online-DPO ~step75 (many gap-skips) |
| F45/F46 | lastN RL ~step105 / ~step90 |
| F47 | n80 d203 @18/80 (king lagging ~14) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 n80 @19/80 |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 @47/80 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 n80 @22/80 |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN ~145/150 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO ~75 |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 lastN RL ~105 |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 lastN RL ~90 |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 n80 d203 @18/80 |

kh: `/tmp/mine-fNN.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F38**/F43/king-init LoRA.
F47 chall bare TCACHE n_so~7 (king n_so≥22) — watch mid-n80 Triton.

## Next action

1. **F40** (~47/80) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear (no replace).
2. **F47** n80 → decision (first non-Albedo base).
3. **F39/F41**: n80→decision.
4. **F42/F44/F45/F46**: train→merge→n80; tear on resolve, do not backfill.
