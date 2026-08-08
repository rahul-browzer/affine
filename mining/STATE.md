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
| Lium / spend | **~$183,688** · cum ~$13,700 · **avail ~$173.7k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$179.5/h** (5 mine-*) ≪ $833/h · free slots **15** |
| F4 | chall:8002=**200**; diverse warm @22:25Z → freeze → longwait n80 |
| F6 | n80 a203 **54/80** |
| F7 | single b203 n80 (c203 killed p396); watcher pattern fixed on pods |
| F8 | merge.**done** 68G; king :8001 **000** (proc alive, unreponsive) — recover |
| F9 | recover264 isolated+seeded (19.so); chall loading pid=26987 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 warm→freeze→n80 |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | F6 n80 a203 54/80 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 b203 n80 single |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | H103 merge done; king dead |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | H104 chall↑ isolated |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F1**/**F2**/**F3**/king-init refs.
Open: H100/F4, H101/F6, H102/F7, H103/F8, H104/F9.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from **pathfile** then live king TCACHE.
**Pods must carry fixed `watch_n80_retry`** (match `retry_${hyp}_n80*` — p396).
**F8:** king-only recover (util0.72 isolated); then chall util0.72→n80.
**F9:** bare peer-seed→preempt killed healthy chall; isolated relaunch owns path.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F8** king-only recover → chall from `/root/h103/merged` → n80.
2. **F4** confirm freeze → longwait sampling; **F9** chall:8002=200→warm→n80.
3. **F6/F7** await margins (F7=b203 only).
