# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9/F12** **REFUTE**.
**F10/F11/F13–F22 live** (12 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,077** · cum ~$15,671 · **avail ~$172.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$392.8/h** (12 mine-*) ≪ $833/h · free slots **8** |
| n80 | F10~47 F11~57 F13~11 F14~23 F15~16 |
| other | F16 **merge**; F17 chall pending; F18–F21 **bootstrap**; F22 **bootstrap** B300 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80** (f203 after 400s) |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 **n80** (restarted) |
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **merge** |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **serve** T+K |
| mine-f18-1 | cosmic-matrix-19 | 86.38.238.54:40300 | ~14:06Z | F18 **bootstrap** |
| mine-f19-1 | eager-comet-12 | 3.135.191.208:20127 | ~14:12Z | F19 **bootstrap** |
| mine-f20-1 | lunar-raven-37 | 152.236.142.235:40301 | ~14:15Z | F20 **bootstrap** |
| mine-f21-1 | lunar-comet-f7 | 150.136.71.147:20300 | ~14:19Z | F21 **bootstrap** B200 |
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 **bootstrap** B300 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9/F12**/king-init refs.
Open: H105–H106/H108–H117/F10–F11/F13–F22. F5 needs traj.
**Earner×high-Λ2 LoRA queue exhausted** — raw-base screens (F17–F22).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 gate (catalog $/h can lie).
**p444:** H200 catalog = only COUNT liars; calm-shark B200@$4.4 hung (no pod) → tore attempt; rented B300 COUNT=8 @$63.6.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F10/F11/F13–F22** → >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. Hold CONFIRM slots until a screen clears +0.015.
3. If slot frees: rent next raw-base (Bittob / af-k1 unmodified) or F5 if traj ready.
4. Watch F21 B200 + F22 B300 for SM/CUDA — tear if unrecoverable.
