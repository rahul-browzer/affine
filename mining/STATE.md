# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F16**/F19–**F21**/F24 **REFUTE**.
**F17,F18,F22,F23,F25 live** (5 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,172** · cum ~$16,569 · **avail ~$171.2k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$217.3/h** (5 mine-*) ≪ $833/h · free slots **15** |
| n80 | F18~70 F17~16 F25~5 (retry2 after 400) |
| other | F22 everest DL ~47G (1 incomplete); F23 Tok incomplete ~28G |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~16** |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **n80 ~70** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 Tok DL |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 **n80 ~5** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F16**/F19–**F21**/F24/king-init refs.
Open: H112–H113/H117–H118/H120/F17–F18/F22/F23/F25. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F18 (~70)** — first finish among remaining; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. F25 (~5 retry2): continue; F17 (~16) growing.
3. F22/F23: DLs growing — Range-resume only if mtime freeze.
4. **Rent full-FT family** (H121/F26) into a free slot — earner×Λ2 LoRA class closed
   (F9–F16 all ≤0; F16 m=−0.076). Not another raw past-earner. Hold CONFIRM slots.
