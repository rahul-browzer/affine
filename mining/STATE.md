# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9/F12** **REFUTE**.
**F10/F11/F13–F23 live** (13 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$181,975** · cum ~$15,773 · **avail ~$172.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$456.4/h** (13 mine-*) ≪ $833/h · free slots **7** |
| n80 | F10~64 F11~73 F13~31 F14~42 F15~34 F17 **started** F19~11 |
| other | F16 engines load; F18/F20 chall load; F21 **teacher recover447**; F22/F23 DL |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z | F10 **n80** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z | F11 **n80** ~73 |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z | F13 **n80** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z | F14 **n80** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z | F15 **n80** |
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 engines load post-merge |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **n80 d203** @02:37Z |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 chall load |
| mine-f19-1 | eager-comet-12 | 3.135.191.208:20127 | ~14:12Z | F19 **n80** |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 chall load |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **teacher p447 load** |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 DL chall |
| mine-f23-1 | lunar-matrix-eb | 204.9.206.244:40301 | ~14:31Z | F23 DL chall |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9/F12**/king-init refs.
Open: H105–H106/H108–H118/F10–F11/F13–F23. F5 needs traj.
**Earner×high-Λ2 LoRA queue exhausted** — raw-base screens (F17–F23).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 gate.
**p447:** F21 teacher Triton ENOENT → recover447 unique TCACHE util=0.72 (king left).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Confirm F21** `:8000=200` + chall promptable → n80; if teacher ENOENT again → tear/replace (B200 hardware?).
2. **Poll F11** (~73) + F10/F17/F19 → >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
3. Confirm F20 `:8002=200` + n80; F16 engines→n80; F18/F22/F23 boot.
4. Hold CONFIRM slots until a screen clears +0.015.
5. If slot frees: rent next raw-base (**af-k1 unmodified** / F5 if traj ready).
