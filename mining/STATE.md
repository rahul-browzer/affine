# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3/**H98/F1**/**H101/F6**/**H103/F8** **REFUTE**.
**F4+F7+F9+F10 live** (4 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$183,108** · cum ~$14,258 · **avail ~$173.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$151.5/h** (4 mine-*) ≪ $833/h · free slots **16** |
| F4 | n80 **b203** ~18/80; watcher → **d203first** |
| F7 | n80 **e203** ~14/80 (d203first armed) |
| F9 | n80 **c203** ~58/80; watcher → **d203first** |
| F10 | bootstrap/uv-pip (p411 rent); d203first armed at launch |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 n80 b203 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 n80 e203 |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | F9 n80 c203 |
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 TalentPigs×Λ2 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F1**/**F2**/**F3**/**F6**/**F8**/king-init refs.
Open: H100/F4, H102/F7, H104/F9, **H105/F10**. F5 needs verified traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from **pathfile** then live king TCACHE.
**Pods must carry fixed `watch_n80_retry`** (match `retry_${hyp}_n80*`).
**king_recover REPO must be live Tok**, not Genesis.
**B300 cu13:** CCCL_DISABLE + **`libcudart.so`→`.so.13`** + wipe sampling JIT
+ diverse-warm before freeze — **validated p405**.
**H32:** drop a203+c203; use `retry_*_d203first`. Kill watchers via scp'd script
matching `$0`, never `bash -c` containing watcher path (p409 self-kill).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Await F9 margin** (~58/80 c203) — nearest finish; on H32→d203 auto.
2. On m>+0.015 → rent CONFIRM k=4 immediately.
3. On REFUTE (m≤0 or gate fail) → tear that pod; no F5 yet.
4. F4/F7/F10: read screen margins when done; same CONFIRM/REFUTE rules.
5. F10: confirm train launched after TalentPigs DL (bootstrap mid-pip @ p411).
6. F8 closed p409 m=−0.0483 — do not reopen RL-L1.
