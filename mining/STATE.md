# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F12**/F14/F15 **REFUTE**.
**F13,F16–F24 live** (10 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,703** · cum ~$16,060 · **avail ~$171.7k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$368.5/h** (10 mine-*) ≪ $833/h · free slots **10** |
| n80 | F13~70 F17~25 F19~55 F20~40 **F21 just started** |
| other | **F16 teacher453 loading**; F18 king; F22/F23/F24 boot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z | F13 **n80 ~70** |
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **teacher453** → n80 |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~25** |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 king only |
| mine-f19-1 | eager-comet-12 | 3.135.191.208:20127 | ~14:12Z | F19 **n80 ~55** |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 **n80 ~40** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **n80 d203 started** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 bootstrap |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 bootstrap |
| mine-f24-1 | calm-raven-15 | 152.236.142.237:40299 | ~14:54Z | F24 boot |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F12/F14/F15**/king-init refs.
Open: H108/H111–H119/F13/F16–F24. F5 needs traj. F25 next rent.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Confirm F16 teacher453** — :8000 promptable → n80 d203; else re-fire `relaunch_teacher_pass332`.
2. **Poll F13** (~70) — >+0.015 CONFIRM; ≤0 REFUTE+tear.
3. Poll F21 n80 (just started); F17/F19/F20; push F18/F22–F24 to n80.
4. **Define+rent F25** (new structural family) — 10 free slots, burn ≪$833.
5. Hold CONFIRM slots until a screen clears +0.015.
