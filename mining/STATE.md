# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23** **REFUTE**.
**F22,F26–F36 live** (12 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,875** · cum ~$17,820 · **avail ~$169.9k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$392.8/h** (12 mine-*) ≪ $833/h · free slots **8** |
| n80 | **F28** ~66/80; **F30** ~60; **F27** ~53; **F26** ~50; **F31** ~50; **F29** ~47; **F33** n80 started; **F32** king dead@13; **F22** king dead@24; **F35** n80 attempt (king000) |
| recover | **F36** tf36→tf32 relaunch @0/60; **F34** train ~50/60 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 kingDEAD — need king478 |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 n80 e203 ~50/80 |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 n80 e203 ~53/80 |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 n80 e203 ~66/80 |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 n80 d203 ~47/80 |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 n80 d203 ~60/80 |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 n80 d203 ~50/80 |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 kingDEAD@13 — king478 |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 n80 d203 started |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 train ~50/60 |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 n80 attempt (king?) |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 full-FT train 0/60 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/king-init LoRA.
Open: H117/F22 + H121–**H131**/F26–**F36**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt EXP must = real exp dir** (p480).
**p481:** full-FT finalize can omit tokenizer → copy from base before chall serve.
**p484:** never edit live `post_train_pipeline.sh` (bash-offset abort).
**p486:** bare king EngineDead → seed-from-chall king478 (n_so≥16) not cold p332.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F22 + F32**: king478 seed-from-chall (util=0.72) → rearm n80; leave chall.
2. **F26–F31,F28,F30,F33**: poll n80 → decision (screen +0.015 → CONFIRM k=4).
3. **F34**: train→post_train; **F35**: ensure king healthy→n80; **F36**: train→post.
4. Free slot → next orthogonal family (or F5 if traj ready).
