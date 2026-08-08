# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA draining; **F1–F4 live**.
No submit. Best vs Tok: H81 +0.0088 (REFUTE). King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,637** · cum ~$12,525 · **avail ~$174.6k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$225/h** (6 mine-*) ≪ $833/h · free slots **14** |
| H95 | **n80 ~50/80** a203 + mid304; eng 200/200/200 |
| H96 | **n80 ~15/80** b203 + mid304; eng 200/200/200 |
| F3 | **king366 loading** (seeded H95 n_so=23; GPU2/3 ~36GiB @20:00Z) |
| F2 | chall **health200** @19:58 → diverse warmups (recover264); T/K 200 |
| F1 | RL train live; T/K 200; C idle |
| F4 | genesis train live GPUs6,7 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h95-1 | calm-raven-0f | 38.255.28.19:20100 | ~06:05Z+1d | **n80~50/80+mid304** |
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | **n80~15/80+mid304** |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | **king366→n80** |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train+T/K200 |
| mine-f2-1 | zesty-orbit-85 | 150.136.71.147:20295 | ~07:13Z+1d | F2 chall warm→n80 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | F4 train live |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r11–31+**r12**.
Open cells: H95/H96. **Open families: H97–H100 (F1–F4).**
Next family: **F5** (needs verified trajectories).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE.
**King cold-JIT ENOENT → seed from peer live king TCACHE (p366).**

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F1–F4 rented.

## Next action

1. **F3** await `h97_king_recover_pass366.done` + `:8001` promptable → n80; **rearm mid304** when sim alive.
2. **F2** await recover264 DONE + chall promptable → n80; arm mid304.
3. **F1** train→merge→n80 (king already 200).
4. **H95/H96** await n80 → `h*_decision.json` (mid304 armed both).
5. **F4** await train→merge→n80. Free slots → **new family only** (F5 if traj ready).
