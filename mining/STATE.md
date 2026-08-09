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

## Next action — KING-WATCH MODE (operator 2026-08-09T10:45Z, see GOAL)

1. **Wind down to one pod this pass.** Keep the healthiest of F44/F45/F46 as
   `mine-watch-1` (warm duel stack, ≤$32/h); `rm` the other two now — do not
   wait for their n80s, the class is closed and the answer is ≈−0.05.
2. **Snapshot the warm stack** to `experiments/warm-stack/` (Triton cache tar +
   exact serve/merge commands) so a fresh pod is one pass from PROMPTABLE.
3. Merge the best Tok-init winner-zA artifact (H64 r=18) on the watch pod and
   leave it ready. HF push is blocked (storage full) — keep it local, that is
   fine for a warm stack.
4. Then every pass: record live king S, check watch pod, renew TTL, stop.
   **Idle is correct.** Trigger: king with **S < 0.035** → re-screen immediately.
