# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F15**/F19/**F20** **REFUTE**.
**F16–F18,F21–F25 live** (8 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,473** · cum ~$16,268 · **avail ~$171.5k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$313.3/h** (8 mine-*) ≪ $833/h · free slots **12** |
| n80 | F24~34 F16~26 F18~20 F21~16 F17~9 (F17/F21 restarted after 400 FP) |
| other | F25 serve DONE_LAUNCH; F23 king DL 91%; F22 everest DL 83% (~38G) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **n80 ~26** |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~9** (retry3) |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **n80 ~20** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **n80 ~16** (restart) |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL ~38G |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 king DL 91% |
| mine-f24-1 | calm-raven-15 | 152.236.142.237:40299 | ~14:54Z | F24 **n80 ~34** |
| mine-f25-1 | eager-orbit-09 | 3.135.191.208:20126 | ~15:20Z | F25 serve launched |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F15**/F19/**F20**/king-init refs.
Open: H111–H113/H116–H120/F16–F18/F21–F25. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F24 (~34)** then F16/F18 — first finish; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. F21/F17: confirm retry n80 healthy (engines 200); do not treat mid-retry as done.
3. F25: await engines promptable → n80.
4. F22/F23: DL still growing — Range-resume only if incompletes stall (mtime freeze).
5. Hold CONFIRM slots until a screen clears +0.015. Next rent only after free slot + new family.
