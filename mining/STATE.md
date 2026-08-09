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
| Lium / spend | **~$178,886** · cum ~$18,805 · **avail ~$168.9k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$186.7/h** (7 mine-*) ≪ $833/h · free slots **13** |
| F37 | **n80 @40–44/80** (bh=a203) healthy t/k/c=200 |
| F41 | **retrain OK** mean_r 0.020/0.015/0.002/0.010 @steps1–5; teacher:200 |
| F43 | DPO done (200 steps); **merge LoRA live** |
| F42 | BoN train live (max_steps=150) |
| F38 | RL ~175/200 |
| F39 | RL ~95/200 |
| F40 | RL ~70/200 (king:000 — watch) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 **n80 ~43/80** |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 RL ~175/200 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 RL ~95/200 |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 RL ~70; king down |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 **RL retrain live** |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN train |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 **merge→n80** |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F36**/king-init LoRA.
Open: H132–H136 RL + H137 BoN-CE + **H138/F43 offline DPO**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p511:** F41 teacher:200 + retrain mean_r≠0 (steps1–5); not tear.
**p510:** F41 bare-TCACHE ENOENT → recover332+retrain (now confirmed).
**p506:** `dd87f25e`/golden-wolf-48 COUNT=3 — blacklisted.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F37**: await n80 → decision; if m>+0.015 → CONFIRM k=4; else REFUTE/tear.
2. **F43**: await merge.done → chall serve → n80.
3. **F41**: train→merge→n80 (retrain healthy; do not tear).
4. **F38–F40 / F42**: train→merge→n80; fix F40 king if still 000 before n80.
5. Free slots → **orthogonal family** (not RL-Λ2 base; not BoN cell; not past-king FT/raw).
