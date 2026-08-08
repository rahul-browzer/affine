# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F2/F3 **REFUTE**.
Winner-zA + LoRA-rank + Λ2-remix drained.
**F1+F4+F6 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,328** · cum ~$12,990 · **avail ~$174.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$125/h** (3 mine-*) ≪ $833/h · free slots **17** |
| H97/F3 | **REFUTE** m=−0.01506 z=−1.84; λ2 still frozen; pod rm'd |
| F1 | RL train **ckpt@150**/200; T/K 200; C idle |
| F4 | merge alive (~28 GiB writing); Tok DL ~24 GiB |
| F6 | TRAIN started 0/60 (fit-filter 477/1058) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train~150/200 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | merge+Tok DL |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | H101 train 0/60 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r9–31+r12+r10/**F2**/**F3 r=256**.
Open: H98/F1, H100/F4, H101/F6. Next family **F7** (teacher z_C).
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**King cold-JIT ENOENT → peer live king TCACHE (p366→p367 OK).**
**F4:** do not kill live HF Tok DL for peer-rsync (p370).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F3 closed p374.

## Next action

1. **Rent F7** (H102 teacher-z_C SFT on Genesis or Tok) — fill free slot.
2. **F4** merge.done + `tok331102.done` → prewarm → n80.
3. **F6** train→merge→n80 (`h101_decision.json`).
4. **F1** train→merge→n80 (~150/200).
5. F5 still blocked (needs verified traj).
