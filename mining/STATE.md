# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26**/**F27**/**F28**/**F30**/**F31**/**F33**/**F35**/**F29**/**F22**/**F34**/**F32**/**F36** **REFUTE**.
**F37–F43 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,136** · cum ~$18,560 · **avail ~$169.1k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$186.7/h** (7 mine-*) ≪ $833/h · free slots **13** |
| train | **F37** RL ~180/200 · **F38** ~55 · **F39** ~30 · **F40** teacher recover→retrain |
| boot | **F41** teacher/RL · **F42** Tok DL · **F43** Tok DL (DPO) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 RL ~180→200 |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 RL ~55/200 |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 S* RL ~30 |
| mine-f40-1 | zesty-wolf-91 | 152.236.142.232:40300 | ~20:12Z | F40 teacher→retrain |
| mine-f41-1 | cosmic-fox-2d | 152.236.142.234:40300 | ~20:19Z | F41 teacher→RL |
| mine-f42-1 | noble-raven-de | 152.236.142.236:40300 | ~20:25Z | F42 BoN bootstrap |
| mine-f43-1 | zesty-matrix-8e | 38.255.28.22:20099 | ~20:34Z | F43 DPO Tok DL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26–F36**/king-init LoRA.
Open: H132–H136 RL + H137 BoN-CE + **H138/F43 offline DPO**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p504:** past-king full-FT class CLOSED.
**p507:** F40 zero-reward train (teacher dead) → kill+recover332+retrain waiter.
**p506:** `dd87f25e`/golden-wolf-48 API 8×H200 → COUNT=3 — blacklisted.
**p493:** Trainer mid-ckpt on `/root` = gocryptfs death — `save_strategy=no`.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F40**: confirm teacher `:8000=200` + retrain non-zero `mean_r`/`z0`; else 3rd recovery→rm+re-rent.
2. **F37**: train→200 → post_train → merge → engines → n80. soft=18:06Z.
3. **F38–F39**: RL →200 → merge → n80.
4. **F41**: await teacher → RL → merge → n80. soft=19:19Z.
5. **F42/F43**: await bootstrap→train→merge→n80.
6. Free slots → **new orthogonal family** (not RL-Λ2 base; not BoN cell; not past-king FT/raw).
