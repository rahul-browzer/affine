# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** Winner-zA draining (H95 REFUTE). **F1–F4 + H96 live**.
No submit. Best vs Tok: H81 +0.0088 (REFUTE). King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,395** · cum ~$12,800 · **avail ~$174.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$193/h** (5 mine-*) ≪ $833/h · free slots **15** |
| H96 | **n80 ~66/80** b203 + mid304; eng 200/200/200 |
| F2 | **n80 ~75/80** b203 + mid304; eng 200/200/200 (**soonest**) |
| F3 | **n80 ~50/80** a203 + mid304; eng 200/200/200 |
| F1 | RL train **~step135/200** (+ckpt50/100); T/K 200; C idle |
| F4 | train DONE 60/60; **merge writing shard**; Tok king DL ~15/70 GiB |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | **n80~66/80+mid304** |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | **n80~50/80+mid304** |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train~135/200+T/K200 |
| mine-f2-1 | zesty-orbit-85 | 150.136.71.147:20295 | ~07:13Z+1d | **F2 n80~75/80+mid304** |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | merge+Tok DL resume |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r11–31+**r12**+**r10**.
Open cell: H96 only. **Open families: H97–H100 (F1–F4).**
Next family: **F5** (needs verified trajectories).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king isolated TCACHE.
**King cold-JIT ENOENT → seed from peer live king TCACHE (p366→p367 OK).**
**F4:** do not kill live HF Tok DL for peer-rsync (p370 lesson).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F1–F4 rented.

## Next action

1. **F2** await n80 → `h99_decision.json` (~75/80; **soonest family screen**).
2. **H96** await n80 → `h96_decision.json` (~66/80); retire cell on resolve.
3. **F3** await n80 → `h97_decision.json` (~50/80).
4. **F4** await merge.done + `tok331102.done` → prewarm T/K → chall → n80.
5. **F1** train→merge→n80 (~135/200). Free slots → **new family only** (F5 if traj).
