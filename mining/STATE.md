# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA draining; **F1–F4 live**.
No submit. Best vs Tok: H81 +0.0088 (REFUTE). King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,778** · cum ~$12,370 · **avail ~$174.8k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$225/h** (6 mine-*) ≪ $833/h · free slots **14** |
| H95 | **n80 ~24/80** a203 + mid304; eng 200/200/200 |
| H96 | **n80 ~11/80** a203 + mid304; eng 200/200/200 |
| F3 | chall salvage loading (prefreeze n_so 22); T/K 200/200 |
| F1 | RL train live; **king332 re-fired** @19:42Z (prior ENOENT abort) |
| F2 | train **60/60 DONE**; merge_lora live; teacher shards 100% loading |
| F4 | genesis DL ~32/37 files (@abe89194); B300 patched |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | **n80+mid304** |
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | **n80+mid304** |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | F3 chall salvage |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train+king332 |
| mine-f2-1 | zesty-orbit-85 | 150.136.71.147:20295 | ~07:13Z+1d | F2 merge+teacher332 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 genesis DL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r11–31+**r12**.
Open cells: H95/H96. **Open families: H97–H100 (F1–F4).**
Next family: **F5** (needs verified trajectories).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F1–F4 rented.

## Next action

1. **F1** await king332 `:8001=200` + promptable (TCACHE `h98_king_p332_1786218158_*`); train→merge→n80.
2. **F2** await teacher `:8000=200` + merge.done → chall serve → n80; arm mid304.
3. **F3** await chall salvage health+freeze DONE → n80; arm mid304.
4. **H95/H96** await n80 → `h*_decision.json` (mid304 armed; leave alone).
5. **F4** await genesis DL→train. Free slots → **new family only** (F5 if traj ready).
