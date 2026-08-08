# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3 **REFUTE**.
Winner-zA + LoRA-rank + Λ2-remix drained.
**F1+F4+F6+F7 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,300** · cum ~$13,040 · **avail ~$174.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$153/h** (4 mine-*) ≪ $833/h · free slots **16** |
| H97/F3 | **REFUTE** m=−0.01506; pod rm'd p374 |
| F1 | RL train ~170/200; T/K up; C idle |
| F4 | **CPU merge recover p376** (GPU save hung); Tok paused→resume after merge |
| F6 | TRAIN ~15/60 loss≈0.60 |
| F7 | Genesis DL ~10 GiB / 37 files |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:05Z+1d | F1 RL ~170/200 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 CPU merge recover |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | H101 train ~15/60 |
| mine-f7-1 | lunar-shark-87 | 152.236.142.232:40311 | ~08:52Z+1d | H102 Genesis DL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31+r12+r10/**F2**/**F3 r=256**/king-init teacher-refs (H5c/H6).
Open: H98/F1, H100/F4, H101/F6, H102/F7.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**King cold-JIT ENOENT → peer live king TCACHE (p366→p367 OK).**
**F4:** GPU merge save hang → CPU recover (p376); do not re-kill Tok mid-HF unless merge hung.
**F7:** Genesis-init (not Tok) — king-init distill-on-refs already dead.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F3 closed p374.

## Next action

1. **F4** await CPU merge → `SKIP_MERGE` post_train → Tok done → prewarm → n80.
2. **F1** train→merge→n80 (~170/200).
3. **F6** train→merge→n80 (`h101_decision.json`).
4. **F7** Genesis DL→train→merge→n80.
5. Next free-slot family: **F5** blocked (needs traj) — pick new family or wait screens.
