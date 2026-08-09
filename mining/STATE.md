# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24 **REFUTE**.
**F17,F22,F23,F25,F26 live** (5 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,104** · cum ~$16,637 · **avail ~$171.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$206.7/h** (5 mine-*) ≪ $833/h · free slots **15** |
| n80 | F17~30 F25~20 |
| other | F22 everest ~50G+inc; F23 Tok ~63G+inc; F26 pip→Tok DL→full-FT |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~30** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL ~50G |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 Tok DL ~63G |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 **n80 ~20** |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 **full-FT bootstrap** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/king-init LoRA.
Open: H112/H117–H118/H120/F17/F22/F23/F25 + **H121/F26**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F26**: bootstrap→Tok DL→full-FT train on 8×H200; after train.done → finalize+serve+n80.
2. Poll F17 (~30) / F25 (~20): >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
3. F22/F23: incompletes still growing — Range-resume only if mtime freeze.
4. Hold CONFIRM slots until a screen clears +0.015. Free slot → next structural (F5 if traj).
