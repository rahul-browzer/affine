# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9/F12** **REFUTE**.
**F10/F11/F13–F17 live** (7 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,272** · cum ~$15,474 · **avail ~$172.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$207.7/h** (7 mine-*) ≪ $833/h · free slots **13** |
| F10 | **n80 f203** ~3/80 (e203→f203 after teacher 400) |
| F11 | **n80 d203** ~14/80 |
| F13 | **n80** ~26/80 |
| F14 | **n80 d203** ~11/80 |
| F15 | **n80** ~15/80 |
| F16 | **bootstrap** af-k1 (venv ok, DL/train next) |
| F17 | **bootstrap** raw genesis (just rented p439) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 f203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80 d203** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 **n80** |
| mine-f16-1 | calm-wolf-2f | 152.236.142.236:40311 | ~13:57Z | F16 **bootstrap** |
| mine-f17-1 | eager-eagle-f3 | 38.255.28.18:20099 | ~14:02Z | F17 **bootstrap** raw-genesis |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9/F12**/king-init refs.
Open: H105–H106/H108–H112/F10–F11/F13–F17. F5 needs traj.
**Earner×high-Λ2 LoRA queue exhausted** (all reign earners screened or refuted).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p439:** rented F17 raw-genesis (no LoRA) @$31.92/h TTL12h; bootstrap+d203first armed.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F10/F11/F13–F17** → >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
2. Hold CONFIRM slots until a screen clears +0.015.
3. If slot frees: rent next *structural* family (not another earner×LoRA cell).
