# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F15** **REFUTE**.
**F16–F24 live** (9 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,609** · cum ~$16,150 · **avail ~$171.6k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$336.5/h** (9 mine-*) ≪ $833/h · free slots **11** |
| n80 | F19~62 F20~46 F17~31 F21~11 |
| other | **F16 teacher453 loading**; **F18 recover454 loading**; F22/F23 boot; F24 engines loading |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **teacher453** → n80 |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~31** |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **recover454** teacher+chall |
| mine-f19-1 | eager-comet-12 | 3.135.191.208:20127 | ~14:12Z | F19 **n80 ~62** |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 **n80 ~46** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **n80 ~11** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 bootstrap |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 bootstrap |
| mine-f24-1 | calm-raven-15 | 152.236.142.237:40299 | ~14:54Z | F24 teacher up; king/chall load |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F15**/king-init refs.
Open: H111–H119/F16–F24. F5 needs traj. F25 next rent.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Confirm F18 recover454** — :8000/:8002 promptable → n80 d203; else re-fire / hardware-suspect.
2. **Confirm F16 teacher453** — :8000 promptable → n80; else re-fire `relaunch_teacher_pass332`.
3. Poll F19 (~62) / F20 / F17 / F21 — >+0.015 CONFIRM; ≤0 REFUTE+tear.
4. Push F22–F24 to n80; **Define+rent F25** (11 free slots, burn ≪$833).
5. Hold CONFIRM slots until a screen clears +0.015.
