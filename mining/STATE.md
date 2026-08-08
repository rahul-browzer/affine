# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA draining; **F1–F4 live**.
No submit. Best vs Tok: H81 +0.0088 (REFUTE). King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,968** · cum ~$12,040 · **avail ~$175.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$285/h** (8 mine-*) ≪ $833/h · free slots **12** |
| H91/H94/H95 | n80 ~77/73/16 |
| H96 | post-merge? |
| F3/F1/F2 | merge / train / train |
| H100/F4 | **BOOTSTRAP** pid=1267 (Genesis-init) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h91-1 | brave-shark-d2 | 38.255.28.18:20099 | ~04:31Z+1d | n80 ~77/80 |
| mine-h94-1 | cosmic-fox-43 | 152.236.142.237:40311 | ~05:27Z+1d | n80 ~73/80 |
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | n80 ~16/80 |
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | post-merge? |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | F3 merge |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train |
| mine-f2-1 | zesty-orbit-85 | 150.136.71.147:20295 | ~07:13Z+1d | F2 train |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 bootstrap |

kh `/tmp/mine-h{91,94,95,96}-1` + `mine-f{1,2,3,4}-1`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r13–31+**r15**.
Open cells: H91/H94–H96. **Open families: H97–H100 (F1–F4).**
Next family: **F5** (needs verified trajectories).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F1–F4 rented.

## Next action

1. **H91** (~77/80) → decision; REFUTE→`lium rm mine-h91-1` only.
2. **H94** (~73/80) same; **H95** arm mid304 if missing.
3. **H96** chall→n80; **F1–F4** await train/merge/bootstrap.
4. Free slot after rm → **new family only** (F5 if data ready).
