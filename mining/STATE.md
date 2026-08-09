# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3/**F1**/**F6**/**F8** **REFUTE**.
**F4+F7+F9+F10+F11+F12 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$183,014** · cum ~$14,343 · **avail ~$173.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$207.5/h** (6 mine-*) ≪ $833/h · free slots **14** |
| F4 | n80 **b203** ~55–58/80; watcher → **d203first** |
| F7 | n80 **e203** ~35/80 (d203first) |
| F9 | n80 **d203** ~15/80 (engines 200) |
| F10 | train ~25/60 GPUs6,7; post waits train.done |
| F11 | train live pandora; king DL af10 mid |
| F12 | bootstrap→golden-crown DL→train (p416 rent) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 n80 b203 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | F7 n80 e203 |
| mine-f9-1 | lunar-fox-0a | 38.255.28.18:20099 | ~09:12Z+1d | F9 n80 d203 |
| mine-f10-1 | eager-wolf-42 | 152.236.142.234:40300 | ~11:54Z+1d | F10 train LoRA |
| mine-f11-1 | swift-eagle-51 | 152.236.142.237:40300 | ~12:02Z+1d | F11 train+kingDL |
| mine-f12-1 | lunar-wolf-a5 | 152.236.142.236:40300 | ~12:10Z+1d | F12 bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F3/F6/F8**/king-init refs.
Open: H100/F4, H102/F7, H104/F9, H105/F10, H106/F11, **H107/F12**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from **pathfile** then king TCACHE.
**Fixed `watch_n80_retry`** (`retry_${hyp}_n80*`). **king_recover = live Tok af10**.
**B300 cu13:** CCCL + `libcudart.so`→`.so.13` + diverse-warm (p405).
**H32:** drop a203+c203; `retry_*_d203first`. Kill watchers via `$0` match only.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Await nearest screen** — F4 (~55/80) then F7 (~35/80); F9 ~15/80.
2. m>+0.015 → CONFIRM k=4; m≤0/gate fail → tear; no F5 yet.
3. F10/F11/F12: train→merge→n80 (F12 golden-crown DL first).
4. Free slot: next unused earner base (diane613 / Bittob / …) only after a
   screen resolves or burn headroom + distinct family still open.
