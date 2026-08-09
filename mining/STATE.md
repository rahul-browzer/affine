# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24 **REFUTE**.
**F17,F22,F23,F25,F26,F27,F28,F29 live** (8 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$180,994** · cum ~$16,747 · **avail ~$171.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$290.7/h** (8 mine-*) ≪ $833/h · free slots **12** |
| n80 | F17~57 F25~44 F23 just started |
| other | F22 everest~54G; F26 train~12/60; F27~5/60; F28 Tok DL; F29 pip/boot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~57** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL ~54G |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 **n80 started** |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 **n80 ~44** |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 **full-FT ~12/60** |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 **full-FT ~5/60** |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 Tok DL→train |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 **golden-FT boot** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/king-init LoRA.
Open: H112/H117–H118/H120/F17/F22/F23/F25 + H121–**H124**/F26–**F29**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. Poll F17 (~57) / F25 (~44) / F23 (just started): >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. Poll F26 (~12/60) / F27 (~5/60) → train.done → finalize+serve+n80; F28/F29 DL→train.
3. F22: everest incomplete still growing — Range-resume only if mtime freeze.
4. Hold CONFIRM slots until a screen clears +0.015. Free slot → next structural (F5 if traj).
