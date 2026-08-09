# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F9** **REFUTE**.
**F10–F15 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$182,497** · cum ~$15,266 · **avail ~$172.5k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 d203** ~47/80 @01:26Z |
| F11 | **n80 e203** live (p431 nested-FP fix; d203 inject-400 loop broken) |
| F12 | **n80 d203** ~39/80 @01:26Z |
| F13 | **n80 d203** ~16/80; watcher re-pointed → d203first |
| F14 | recover264 a1 Triton ENOENT `OV4T43AL…` mid-settle; a2 pending |
| F15 | train ~ckpt50/60 (GPU7) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 d203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **n80 e203** p431 |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80 d203** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 recover264 a1→a2 |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 train |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p431 F11:** `_is_false_probe_sim` must read nested `verdict.rejection_reason`
(else N80_DONE on FP → d203 forever). Fixed + e203first armed; patched
scripts SCP'd to F10–F15. F13 watcher was on bare a203 — now d203first.
**F14:** a1 health=200 then settle→warmup hit ghost ENOENT; recover outer×3.
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Poll F11 e203** — if FP continue rotate f/g/b203 (nested detect); if margin → CONFIRM.
2. **Poll F10/F12/F13 n80** → margin; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
3. **F14:** wait recover a2/a3 → DONE_LAUNCH + sidecar SIDE_DONE → n80 d203.
4. F15 train→merge (contig+/tmp) → n80.
5. Hold CONFIRM slots; F16 after a tear.
