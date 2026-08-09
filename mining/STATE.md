# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F37 **REFUTE**.
**F38–F47 live** (10 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish F38–F47, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,467** · cum ~$19,203 · **avail ~$168.5k** |
| miner / burn | τ10 free · 0 sub · **~$278.6/h** (10) ≪$833 · free **10** |
| F43/F38/F40 | n80 @73/80 · @48/80 · @19/80 |
| F41 | **n80 d203 live** (p523 rearm; a203 FP loop broken) |
| F39 | merge done; chall loading (:8002=000) |
| F42/F44/F45 | idle eng (train/merge path) |
| F46/F47 | boot / bootstrap |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 n80 @48/80 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 chall load |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 @19/80 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 n80 d203 |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 n80 @73/80 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 online-DPO |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 lastN RL |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 bootstrap |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 coder boot |

kh: `/tmp/mine-fNN.kh` (known_hosts). SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F37**/king-init LoRA.
**p523:** F41 stale `retry_*_d203first` still a203-first + FP→N80_DONE; fixed via `retry_h136_n80_d203first_p523.sh`.

## Next action

1. **F43** (~73/80) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear (no replace).
2. **F38/F40/F41**: n80→decision same rule.
3. **F39**: await chall :8002→n80.
4. **F42/F44/F45/F46/F47**: train/boot→n80; tear on resolve, do not backfill.
