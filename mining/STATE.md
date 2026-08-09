# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F15**/F19 **REFUTE**.
**F16–F18,F20–F24 live** (8 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,563** · cum ~$16,196 · **avail ~$171.6k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$312.1/h** (8 mine-*) ≪ $833/h · free slots **12** |
| n80 | F20~60 F17~48 F21~47 F24~15 F16~11 F18 just started |
| other | F22 everest DL (~28G incompletes growing); F23 king DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **n80 ~11** |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~48** |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **n80 started** (recover454 OK) |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 **n80 ~60** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **n80 ~47** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 everest DL |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 king DL |
| mine-f24-1 | calm-raven-15 | 152.236.142.237:40299 | ~14:54Z | F24 **n80 ~15** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F15**/F19/king-init refs.
Open: H111–H113/H115–H119/F16–F18/F20–F24. F5 needs traj. F25 next rent.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F20 (~60)** — finish first; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. Poll F17/F21/F18/F16/F24 — same rule.
3. **Define+rent F25** = raw `golden-crown/…AzSJF` @ `ee37f4f0` (last earning reign member not raw-screened). Clone F19 bootstrap→h120. Burn room ~$520/h.
4. F22: if incompletes stall, Range-resume (hub≥1.27 never resumes `.incomplete`).
5. Hold CONFIRM slots until a screen clears +0.015.
