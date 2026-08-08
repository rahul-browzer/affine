# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3/**H98/F1** **REFUTE**.
**F4+F6+F7+F8+F9 live** (5 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$183,753** · cum ~$13,635 · **avail ~$173.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$179.5/h** (5 mine-*) ≪ $833/h · free slots **15** |
| F1 | **REFUTE** m=+0.00229 z=0.42 · Λ2 frozen · **rm mine-f1-1** |
| F4 | king util0.72 loading GPUs2–3 ~37 GiB; longwait ~40/360; chall cold |
| F6 | n80 a203 ~33/80 |
| F7 | b203 n80 only (p394 killed c203 twin); engines 200 |
| F8 | RL train live GPUs6–7; teacher 200; king util0.80 cold |
| F9 | CPU merge DONE → SKIP_MERGE post_train; king hung → **king332 p394** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 king→chall→longwait n80 |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | F6 n80 a203 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 b203 n80 |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | H103 RL train |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | H104 king332→chall→n80 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F1**/**F2**/**F3**/king-init refs.
Open: H100/F4, H101/F6, H102/F7, H103/F8, H104/F9.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**F4:** await king:8001→chall:8002→longwait n80.
**F7:** single b203; watcher→`retry_h102_n80_b203first.sh`.
**F9:** king332 util0.72 → chall `/root/h104/merged` → n80 (merged OK_NON_IDENTICAL).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F9** confirm king:8001=200 after king332 → chall from `/root/h104/merged` → n80.
2. **F4** confirm king+chall → longwait sampling.
3. **F6/F7** await margins; **F8** RL→merge→n80 (king util0.80→0.72 before n80).
