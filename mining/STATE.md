# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F39/**F43** **REFUTE**.
**F40–F42, F44–F47 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish F38–F47, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,176** · cum ~$19,558 · **avail ~$168.2k** |
| miner / burn | τ10 free · 0 sub · **~$199/h** (7) ≪$833 · free **13** |
| F39 | **REFUTE** m=+0.00267 z=0.41; rm mine-f39-1 |
| F40 | n80 c203 @~34/80 |
| F41 | n80 e203 @~45/80 |
| F42 | n80 d203 @~20/80 |
| F44 | merge done; chall up; n80 starting |
| F45 | visual restored; **n80 a203 @6/80** |
| F46 | visual restored; **recover264** chall load |
| F47 | n80 @~53/80 |
| HF | unconst **public storage full** — local MERGED ok; push blocked |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 c203 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 n80 e203 |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 n80 d203 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 n80 starting |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 n80 a203 |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 recover264→n80 |
| mine-f47-1 | golden-matrix-bb | 38.255.28.18:20099 | ~22:07Z | F47 n80 |

kh: `/tmp/mine-fNN.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F39**/F43/king-init LoRA.
HF Hub push of merged ckpts blocked until storage freed/Pro.
F45/F46 last-N save needs `inplace_restore_visual.py` before chall (done p528).

## Next action

1. **F46**: recover264 → chall :8002=200 → n80 → decision.
2. **F45/F47/F41** (~near done) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
3. **F40/F42/F44**: n80→decision. No backfill; free slots idle (operator).
