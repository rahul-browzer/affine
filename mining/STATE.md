# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17** **REFUTE**.
**F22,F23,F25–F31 live** (9 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$180,907** · cum ~$16,872 · **avail ~$170.9k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$318.7/h** (9 mine-*) ≪ $833/h · free slots **11** |
| n80 | F25~68 F23~37 |
| other | F22 everest ~40G incomplete (growing); F26–F30 train; F31 pip |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest ~40G incomplete (growing) |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 **n80 ~37** |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 **n80 ~68** |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 **full-FT train** |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 **full-FT train** |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 **full-FT train** |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 **full-FT train** |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 **full-FT train** |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 **Bittob-FT pip** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/king-init LoRA.
Open: H117–H118/H120/F22/F23/F25 + H121–**H126**/F26–**F31**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. Poll F25 (~68): >+0.015 CONFIRM k=4; ≤0 REFUTE+tear. F23 ~37 still early.
2. Poll F26–F30 train.done → finalize+serve+n80. F31: Bittob DL→full-FT.
3. F22 everest incomplete ~40G still growing — Range-resume **only if mtime freeze**.
4. Hold CONFIRM slots until a screen clears +0.015. Free slot → TalentPigs full-FT or F5 if traj.
