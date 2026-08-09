# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F43/**F47** **REFUTE**.
**F44–F46 live** (3 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456. Operator: finish live screens, **do not replace**, drift burn ≤$120/h.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$177,975** · cum ~$19,760 · **avail ~$168.0k** |
| miner / burn | τ10 free · 0 sub · **~$83/h** (3) ≪$833 · free **17** |
| F44 | n80 d203 p529 @~34/80 |
| F45 | **n80 d203 p529 attempt1** @~0/80 (p536 cutover) |
| F46 | n80 d203 p529 @~39/80 |
| HF | unconst **public storage full** — local MERGED ok; push blocked |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f44-1 | swift-matrix-65 | 152.236.142.237:40300 | ~21:28Z | F44 n80 d203 p529 |
| mine-f45-1 | lunar-matrix-d4 | 38.255.28.21:20099 | ~21:35Z | F45 n80 **d203 p529** |
| mine-f46-1 | swift-comet-18 | 152.236.142.241:40061 | ~22:02Z | F46 n80 d203 p529 |

kh: `/tmp/mine-fNN.kh`. SSH key `~/.ssh/id_ed25519`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F43**/F47/king-init LoRA.
HF Hub push of merged ckpts blocked until storage freed/Pro.
Raw non-Albedo bases fail baseline band (F47 2.24×) — not a crown path alone.

## Next action

1. **F46** (~39/80) → decision; m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F44** (~34/80) → decision.
3. **F45** d203 p529 just restarted (p536); wait for decision.
4. No backfill; free slots idle (operator).
