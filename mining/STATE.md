# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H99/F2 **REFUTE**. Winner-zA draining.
**F1+F3+F4+F6+H96 live**. No submit. Best vs Tok: H81 +0.0088.
King Tok331102 S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$184,363** · cum ~$12,890 · **avail ~$174.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$181/h** (5 mine-*) ≪ $833/h · free slots **15** |
| H96 | **n80 ~79–80/80** b203; eng 200; decision pending |
| F3 | **n80 ~69/80** a203 + mid304; eng 200 |
| F1 | RL train **~step150/200**; T/K 200; C idle |
| F4 | merge (~26 GiB); Tok DL ~21 GiB (2 incomplete) |
| F6 | **NEW** bootstrap→Tok DL→train ultrashort≤80 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h96-1 | golden-matrix-af | 152.236.142.232:40299 | ~06:52Z+1d | **n80~79/80** |
| mine-f3-1 | noble-raven-ff | 152.236.142.236:40311 | ~07:01Z+1d | **n80~69/80+mid304** |
| mine-f1-1 | brave-hawk-5a | 86.38.238.54:40099 | ~07:06Z+1d | F1 train~150/200 |
| mine-f4-1 | calm-wolf-30 | 204.9.206.243:40099 | ~07:18Z+1d | merge+Tok DL |
| mine-f6-1 | noble-shark-14 | 152.236.142.237:40300 | ~08:42Z+1d | **H101/F6 bootstrap** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`.
Non-mine `wan-lora-*` / `affine-*` / `glm52-*` — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP×ks/m7×ks/union/lr/ep≥2/winner-zA/−0.004/Tok r11–31+r12+r10/**F2**.
Open: H96 cell; families H97–H98, H100–H101. F2 closed.
Next: **F5** (needs traj) or **F7** — not r-neighbour.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT=8 & $/h≥28; never `pkill -f`.
recover264=chall; king-only relaunch; seed chall from live king TCACHE.
**King cold-JIT ENOENT → peer live king TCACHE (p366→p367 OK).**
**F4:** do not kill live HF Tok DL for peer-rsync (p370).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.
Retire winner-zA on resolve; no more r-neighbours. F1–F4+F6 rented; F2 done.

## Next action

1. **H96** → `h96_decision.json` (~79/80); retire on resolve.
2. **F3** → `h97_decision.json` (~69/80).
3. **F6** bootstrap→train→merge→n80 (`h101_decision.json`).
4. **F4** merge.done + `tok331102.done` → prewarm → n80.
5. **F1** train→merge→n80 (~150/200).
6. Fill free slot with **F5**/F7 — not r-neighbour.
