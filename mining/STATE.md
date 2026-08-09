# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F28**/**F30** **REFUTE**.
**F22,F26,F27,F29,F31–F36 live** (10 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,737** · cum ~$17,959 · **avail ~$169.7k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$336.8/h** (10 mine-*) ≪ $833/h · free slots **10** |
| n80 | **F26** ~77/80; **F31** ~76; **F27** ~75; **F29** ~66; **F34** d203 early; **F22/F32** e203; **F33** early; **F35** king478 loading |
| recover | **F35** king478 seeded n_so=23 util=0.72 (loading); **F36** train/post_train |
| REFUTE p489 | **F28** m=−0.00982; **F30** m=−0.01918 — pods rm'd |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 n80 e203 |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 n80 ~77/80 |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 n80 ~75/80 |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 n80 ~66/80 |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 n80 ~76/80 |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 n80 e203 |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 n80 early |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 n80 d203 (watcher fixed p489) |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 king478→n80 |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 train/post_train |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F28**/**F30**/king-init LoRA.
Open: H117/F22 + H121–H122/H124/H126–**H131**/F26–F27/F29/F31–**F36**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt EXP must = real exp dir** (p480).
**p481:** full-FT finalize can omit tokenizer → copy from base before chall serve.
**p484:** never edit live `post_train_pipeline.sh` (bash-offset abort).
**p486:** bare king EngineDead → seed-from-chall king478 (n_so≥16) not cold p332.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.
**p488:** mid-n80 king TimeoutError/EngineDead → king478 + reap orphans; fix wrong watcher EXP path.
**p489:** F28/F30 teacher_refs+kevin full-FT REFUTE below 0; F35 king478+watcher fix.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F35**: wait `h130_king_recover_pass478.done` → n80 d203; re-fire king478 if Triton ENOENT.
2. **F26/F27/F29/F31** (near finish): poll → decision; screen +0.015 → CONFIRM k=4 else REFUTE+rm.
3. Free slots (10): fill with new orthogonal families (not more Tok/earner×Λ2 FT clones) or F5 if traj ready.
