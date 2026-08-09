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
| Lium / spend | **~$182,433** · cum ~$15,329 · **avail ~$172.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$175.8/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F10 | **n80 e203** ~3/80 @01:35Z (fresh after prior) |
| F11 | **n80 e203** chall~16/80 **king :8001=000** — recover |
| F12 | **n80 d203** ~53/80 @01:35Z (nearest done) |
| F13 | **n80 d203** ~28/80 @01:34Z |
| F14 | **n80 e203** ~1/80 @01:34Z |
| F15 | **chall loading** post visual433; merge OK 16+333vis |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 **n80 e203** |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 **king dead** mid-n80 |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 **n80 d203** |
| mine-f13-1 | zesty-hawk-1f | 38.255.28.21:20099 | ~12:17Z+1d | F13 **n80 d203** |
| mine-f14-1 | eager-comet-be | 152.236.142.232:40309 | ~12:34Z+1d | F14 **n80 e203** |
| mine-f15-1 | calm-wolf-f7 | 38.255.28.22:20099 | ~12:37Z+1d | F15 chall→freeze→n80 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F4/F6–F9**/king-init refs.
Open: H105–H110/F10–F15. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28.
**p433 F15:** merge432 lang OK then visual `save_file` EFAULT →
`finish_visual_pass433` (333 keys / 893 MiB) + SKIP_MERGE post_train;
chall pid=18584 loading @01:35Z. Do **not** re-merge.
**F11:** king :8001 down mid-e203 — king_recover_pass332 first (leave chall).
Next unused earner: **af-k1** → **F16**.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F11 king_recover** (:8001=000 mid-n80) then rearm e203.
2. **Poll F12 n80** (~53/80) → margin; >+0.015 CONFIRM k=4; ≤0 REFUTE+tear.
3. **Poll F10/F13/F14** → same decision rule.
4. **F15:** wait :8002=200 + freeze → n80 d203 (watchers already armed).
5. Hold CONFIRM slots; F16 after a tear.
