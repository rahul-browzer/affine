# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F36 **REFUTE**.
**F37–F43 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,025** · cum ~$18,670 · **avail ~$169.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$186.7/h** (7 mine-*) ≪ $833/h · free slots **13** |
| F37 | **n80 running** @1/80 (bh=a203) after merge+chall; train last20 mean_r=−0.007 |
| F40 | **RL healthy** after p508 kevin-z fix; steps 1–3 mean_r 0.016/0.022/0.005 |
| boot | F38–F39 RL; F41 teacher/RL; F42/F43 Tok DL→train |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 **n80 1/80** |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 RL |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 S* RL |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 RL (fixed z) |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 teacher→RL |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 DPO |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F36**/king-init LoRA.
Open: H132–H136 RL + H137 BoN-CE + **H138/F43 offline DPO**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p508:** kevin `</think>\nTHOUGHT:` normalize fixed; F37 DEADMAN default was past (06:36Z).
**p506:** `dd87f25e`/golden-wolf-48 COUNT=3 — blacklisted.
**p493:** Trainer mid-ckpt on `/root` = gocryptfs death — `save_strategy=no`.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F37**: await n80 → decision; if m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F40**: confirm train→200 with nonzero mean_r; merge→n80. Apply same z-normalize to other kevin-family scripts if any.
3. **F38–F39**: RL →200 → merge → n80.
4. **F41–F43**: bootstrap→train→merge→n80.
5. Free slots → **orthogonal family** (not RL-Λ2 base; not BoN cell; not past-king FT/raw).
