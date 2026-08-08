# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA H91/93–96 draining; **F1/F2/F3 live**.
No submit. Best vs Tok: H81 +0.0088 (REFUTE). King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$185,007** · cum ~$12,000 · **avail ~$175.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$254/h** (8 mine-*) ≪ $833/h · free slots **12** (cap 20) |
| H91 | n80 b203 ~66/80 + mid304 |
| H93 | n80 a203 ~75/80 + mid304 |
| H94 | n80 a203 ~62/80 + mid304 |
| H95 | n80 a203 ~1/80 (just launched) |
| H96 | merge r9 |
| H97/F3 | train r256 |
| H98/F1 | bootstrap (tok DL ~91%) |
| H99/F2 | **BOOTSTRAP** pid=942 (high-Λ2 data) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | n80+mid304 |
| mine-h93-1 | eager-raven-1e | 38.255.28.22:20099 | ~05:21Z+1d | n80 ~75/80 |
| mine-h94-1 | cosmic-fox-43 | 152.236.142.237:40311 | ~05:27Z+1d | n80+mid304 |
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | n80 a203 |
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | merge |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | F3 train |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 bootstrap |
| mine-f2-1 | zesty-orbit-85 | 150.136.71.147:20295 | ~07:13Z+1d | F2 bootstrap |

kh `/tmp/mine-h{91,93,94,95,96}-1` + `mine-f{1,2,3}-1`. `fleet_status.sh` ready.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr micro/ep≥2/winner-zA mean−0.004/Tok r13–31 gaps.
Open cells draining: H91/H93–H96. **Open families: H97/F3, H98/F1, H99/F2.**
Next family: **F4** non-king base.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA cells on resolve; do **not** launch more r-neighbours.
Priority fill: F1/F2 done; **F4** next free slot.

## Next action

1. **H93** (~75/80) → read decision; REFUTE→`lium rm mine-h93-1` only; fill **F4**.
2. **H91/H94/H95** same on resolve; arm mid304 on H95 if missing.
3. **H96** merge→chall→n80; **F1/F2/F3** await bootstrap/train.
4. Free slot → rent **F4** (non-king base), not another r-cell.
