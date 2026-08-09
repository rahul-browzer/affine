# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9/F12** **REFUTE**.
**F10/F11/F13–F15 live** (5 pods). No submit. Best vs Tok: H81 +0.0088. King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,335** · cum ~$15,442 · **avail ~$172.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$147.8/h** (5 mine-*) ≪ $833/h · free slots **15** |
| F10 | **n80 e203** ~30/80 @01:53Z |
| F11 | **n80 d203** just armed (p437 killed a203 longwait) |
| F12 | **REFUTE** m=**−0.05941** z=−6.64 · torn @01:53Z |
| F13 | **n80** sim alive (prog lag) |
| F14 | **n80 d203** ~8/80 |
| F15 | **n80** sim alive (prog lag) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 e203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80 d203** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 **n80** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9/F12**/king-init refs.
Open: H105–H106/H108–H110/F10–F11/F13–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p437:** H107/F12 REFUTE m=−0.05941 (mean_λ2_c −0.0109≪king); tore mine-f12-1 (~$47.64).
F11 king435 DONE → longwait launched **a203** → killed+rearmed **d203first** (p437).
Next earner: **af-k1**→**F16** (rev `ff6eb4bc…`).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Rent F16** (`af-k1/Affine-5ECe…` @ `ff6eb4bc…`) on free slot — scaffold from F15.
2. **Poll F10/F11/F13–F15** → >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
3. Hold CONFIRM slots until a screen clears +0.015.
