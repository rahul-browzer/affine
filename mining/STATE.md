# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F39/**F43/F47** **REFUTE**.
**F40–F42, F44–F46 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish live screens, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$178,090** · cum ~$19,645 · **avail ~$168.1k** |
| miner / burn | τ10 free · 0 sub · **~$167/h** (6) ≪$833 · free **14** |
| F40 | n80 c203 @~48/80 |
| F41 | n80 e203 @~60/80 |
| F42 | n80 d203 @~35/80 |
| F44 | chall recover264 loading GPUs4,5 (~36GB); :8002→200 then p529 d203 |
| F45 | n80 a203 @~23/80 |
| F46 | n80 d203 just started (p529); engines 200 |
| F47 | **REFUTE** base_x=2.244 band; rm mine-f47-1 |
| HF | unconst **public storage full** — local MERGED ok; push blocked |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 n80 c203 |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 n80 e203 |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 n80 d203 |
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 recover264→p529 d203 |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 n80 a203 |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 n80 d203 |

kh: `/tmp/mine-fNN.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F39**/F43/**F47**/king-init LoRA.
HF Hub push of merged ckpts blocked until storage freed/Pro.
Raw non-Albedo bases fail baseline band (F47 2.24×) — not a crown path alone.

## Next action

1. **F41** (~60/80) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F40/F42/F45/F46**: n80→decision.
3. **F44**: wait chall :8002=200 + recover264 DONE → p529 d203 n80 (FP≠REFUTE).
4. No backfill; free slots idle (operator).
