# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3 **REFUTE**.
**F1+F4+F6+F7+F8 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,210** · cum ~$13,100 · **avail ~$174.2k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$181/h** (5 mine-*) ≪ $833/h · free slots **15** |
| F1 | RL ~175/200; T/K up; C idle |
| F4 | CPU merge shard1 ~36% (wchar~18 GiB); recover376 armed |
| F6 | TRAIN ~35/60 loss≈0.52 |
| F7 | TRAIN ~8/29 + teacher/Tok DL |
| F8 | **NEW p377** Genesis-RL bootstrap (uv pip) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:05Z+1d | F1 RL ~175/200 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 CPU merge |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | H101 ~35/60 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | H102 ~8/29 |
| mine-f8-1 | brave-matrix-d8 | 152.236.142.236:40309 | ~09:04Z+1d | H103/F8 bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31/**F2**/**F3**/king-init refs.
Open: H98/F1, H100/F4, H101/F6, H102/F7, H103/F8.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**F4:** CPU merge on gocryptfs (wchar progressing); do not re-kill mid-write.
**F7/F8:** Genesis-init — king-init distill-on-refs already dead.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F4** await CPU merge → SKIP_MERGE post_train → Tok → prewarm → n80.
2. **F1** train→merge→n80 (~175/200).
3. **F6/F7** train→merge→n80.
4. **F8** bootstrap→Genesis DL→RL→merge→n80.
5. Free slot: F5 blocked (traj) — pick new family or await screens.
