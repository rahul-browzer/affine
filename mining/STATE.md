# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F12** **REFUTE** (F10 p450).
**F13–F23 live** (11 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,811** · cum ~$15,937 · **avail ~$171.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$400.4/h** (11 mine-*) ≪ $833/h · free slots **9** |
| n80 | F13~53 F14~62 F15~61 F17~1 F19~37 F20~19 |
| other | F16 tchr000 k/c200; F18 k200 only; F21 t200 k/c000; F22/F23 boot |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z | F13 **n80 ~53** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z | F14 **n80 ~62** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z | F15 **n80 ~61** |
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 post_train; tchr dead |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 ~1/80** (post king449) |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 king only |
| mine-f19-1 | eager-comet-12 | 3.135.191.208:20127 | ~14:12Z | F19 **n80 ~37** |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 **n80 ~19** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **k/c down** recover |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 bootstrap |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F12**/king-init refs.
Open: H108–H118/F13–F23. F5 needs traj. F24 next rent.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Rent F24** (raw af-k1, H119) — slot free; burn headroom ~$433/h; scaffold from F17/F20.
2. **F21** recover king+chall (health 200/000/000) → completions → n80.
3. **Poll F14/F15** (~62/61 near done) + F13/F19/F20 → >+0.015 CONFIRM; ≤0 REFUTE+tear.
4. Confirm F16/F18/F22/F23 → n80; F17 progressing.
5. Hold CONFIRM slots until a screen clears +0.015.
