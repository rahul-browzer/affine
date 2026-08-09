# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26**/**F27**/**F28**/**F30**/**F31**/**F33**/**F35**/**F29**/**F22**/**F34**/**F32** **REFUTE**.
**F36,F37,F38,F39 live** (4 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,275** · cum ~$18,422 · **avail ~$169.3k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$104.6/h** (4 mine-*) ≪ $833/h · free slots **16** |
| n80 | **F36** ~61/80 |
| train | **F37** RL step≥110/200 · **F38** Genesis DL (syntax fixed p502) · **F39** bootstrap |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 n80 d203 ~61/80 |
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 RL train→200 |
| mine-f38-1 | golden-eagle-8b | 152.236.142.235:40300 | ~19:51Z | F38 Genesis DL→train |
| mine-f39-1 | cosmic-matrix-95 | 3.135.191.208:20127 | ~20:06Z | F39 bootstrap→S* RL |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26–F35**/**F29**/**F22**/**F34**/**F32**/king-init LoRA.
Open: H131/F36 + H132/F37 + H133/F38 + **H134/F39**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p497–p502:** past-king FT class collapsing — **no new rents in that class** (F32 last TalentPigs REFUTE).
**p502:** F38 `write(path+"\n")` heredoc broken by sed — fixed; F39 soft=19:06Z armed.
**p493:** Trainer mid-ckpt on `/root` = gocryptfs death — `save_strategy=no`.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F36 n80 decision**: +0.015→CONFIRM else REFUTE+rm.
2. **F37**: train→200 → post_train → merge → engines → n80. soft=18:06Z.
3. **F38**: await Genesis+teacher DL → RL train → merge → n80. soft=18:51Z.
4. **F39**: await bootstrap→Tok DL→teacher→S* RL train→merge→n80. soft=19:06Z.
5. Free slots → **new orthogonal family** (not past-king FT; not raw past-earner).
