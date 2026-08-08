# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3/**H98/F1**/**H101/F6** **REFUTE**.
**F4+F7+F8+F9 live** (4 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$183,407** · cum ~$14,005 · **avail ~$173.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$151.5/h** (4 mine-*) ≪ $833/h · free slots **16** |
| F4 | **cuda404** cudart.so symlink + chall↑ (pid90746; :8002=000→await warm) |
| F7 | n80 c203 ~king1/chall2 (b203 died king400@~15) |
| F8 | n80 a203 ~king8/chall10 |
| F9 | n80 b203 **king23/chall23** of 80 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 cuda404 chall↑ |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 n80 c203 |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | F8 n80 a203 |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | H104 n80 b203 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F1**/**F2**/**F3**/**F6**/king-init refs.
Open: H100/F4, H102/F7, H103/F8, H104/F9.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from **pathfile** then live king TCACHE.
**Pods must carry fixed `watch_n80_retry`** (match `retry_${hyp}_n80*`).
**king_recover REPO must be live Tok**, not Genesis.
**B300 cu13:** CCCL_DISABLE + **`libcudart.so`→`.so.13` symlink** + wipe sampling JIT
+ diverse-warm before freeze (`relaunch_chall_cuda_p404.sh`).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F4** await cuda404 CHALL PROMPTABLE → diverse-warm → freeze → longwait n80;
   if `-lcudart` recurs, verify symlink in both `lib`/`lib64`.
2. **F7/F8/F9** await n80 margins (screens); F7 on c203 after b203 king400.
