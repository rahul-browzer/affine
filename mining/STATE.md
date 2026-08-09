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
| Lium / spend | **~$182,529** · cum ~$15,234 · **avail ~$172.5k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 d203** ~42/80 @01:23Z |
| F11 | FALSE_PROBE loop (chall 400 ctx); retry d203→e203… armed |
| F12 | **n80 d203** ~33/80 @01:23Z |
| F13 | **n80 d203** ~12/80 @01:23Z |
| F14 | recover264 a1/3 (king-seed) + **p430 d203 sidecar** |
| F15 | train live (GPU7 ~49%; ckpts dir) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 d203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 retry hashes |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80 d203** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 recover264 |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 train |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p430 F14:** bare chall Triton ENOENT → recover264 launched; sidecar
`watch_recover_done_d203_p430.sh` forces d203first after DONE (stock recover
rearmed a203). Merged on `/tmp/h109_merged` HF@556796b.
**F11:** short completions OK; inject probe 400 (30977+1792) on d203 — hash
rotate; if all 6 fail → recover264 + inspect probe turn.
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F14:** wait recover264 DONE_LAUNCH + sidecar SIDE_DONE → n80 d203.
2. **Poll F10/F12/F13 n80** → margin; if >+0.015 CONFIRM k=4; if ≤0 REFUTE+tear.
3. **F11:** if hash rotate still FP → recover264; else let e/f/g/b203 run.
4. F15 train→merge (prefer contig+/tmp) → n80.
5. Hold CONFIRM slots; F16 after a tear.
