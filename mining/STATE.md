# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA cells H91/93–96 draining; **F3 H97 live**.
No submit. Best vs Tok: H81 r22 m=+0.008811 (REFUTE).
**Live king:** Tok331102 S=0.04456 (reign 4).

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,072** · cum ~$11,800 · **avail ~$175.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$180/h** (6 mine-*) ≪ $833/h · free slots **14** (cap 20) |
| H91 | n80 b203 ~45/80 + mid304 |
| H93 | n80 a203 ~57/80 + mid304 |
| H94 | n80 a203 ~42/80 + mid304 |
| H95 | CPU merge writing shards (recover352) |
| H96 | train r9 running; engines down (expected) |
| H97/F3 | **BOOTSTRAP** pid=917 (r256/α512) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | n80 b203+mid304 |
| mine-h93-1 | eager-raven-1e | 38.255.28.22:20099 | ~05:21Z+1d | n80+mid304 |
| mine-h94-1 | cosmic-fox-43 | 152.236.142.237:40311 | ~05:27Z+1d | n80+mid304 |
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | merge→post_train |
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | train r9 |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | F3 r256 bootstrap |

known_hosts `/tmp/mine-h{91,93,94,95,96}-1.known_hosts` + `/tmp/mine-f3-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr micro/ep≥2/winner-zA mean−0.004/Tok r13–31 gaps.
Open cells draining: H91/H93–H96. **Open family: H97/F3.** Next: F1,F2,F4.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE; arm mid304 w/ n80.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA cells on resolve; do **not** launch more r-neighbours.
Priority fill: **F1 Direct-RL-on-S**, F2 target-Λ2, F4 non-king base.
Before >~8 pods: bake watchdogs into bootstrap + `fleet_status.sh`.

## Next action

1. **H93** (~57/80) first to finish → read decision; REFUTE→`lium rm mine-h93-1` only.
2. **H91/H94** same; **H95** await merge.done→resume_post_merge→n80+mid304.
3. **H96** await train→merge→n80; **H97/F3** await bootstrap→train.
4. Free slot → rent **F1** (not another r-cell). Write `fleet_status.sh` before 8+.
