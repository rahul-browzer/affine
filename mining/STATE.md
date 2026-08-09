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
| Lium / spend | **~$179,965** · cum ~$17,729 · **avail ~$170.0k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$392.8/h** (12 mine-*) ≪ $833/h · free slots **8** |
| n80 | **F22** 5/80; **F26** ~23/80; **F27** ~31/80; **F28** ~39/80; **F29** ~15/80; **F30** ~30/80; **F31** ~17/80 |
| recover | **F32** serve_three loading (n80 wait); **F36** pip→af-k1 DL→train |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 n80 d203 **5/80** |
| mine-f26-1 | gentle-fox-2c | 152.236.142.235:40300 | ~16:12Z | F26 n80 e203 |
| mine-f27-1 | eager-orbit-15 | 152.236.142.237:40299 | ~16:16Z | F27 n80 e203 |
| mine-f28-1 | eager-eagle-b1 | 152.236.142.232:40300 | ~16:20Z | F28 n80 e203 |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 n80 d203 |
| mine-f30-1 | lunar-wolf-aa | 152.236.142.236:40300 | ~16:31Z | F30 n80 d203 |
| mine-f31-1 | golden-hawk-bb | 38.255.28.21:20099 | ~16:39Z | F31 n80 d203 |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 engines→n80 |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 full-FT train |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 full-FT train |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 full-FT train |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 af-k1 full-FT bootstrap |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/king-init LoRA.
Open: H117/F22 + H121–**H131**/F26–**F36**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt EXP must = real exp dir** (p480).
**p481:** full-FT finalize can omit tokenizer → copy from base before chall serve.
**p484:** never edit live `post_train_pipeline.sh` (bash-offset abort).

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F26–F31 + F22**: poll n80 → decision (screen bar +0.015 → CONFIRM k=4).
2. **F32**: wait engines health+promptable+freeze → n80.
3. **F33–F35**: train→post_train; **F36**: wait bootstrap→train.
4. Free slot → next orthogonal family (or F5 if traj ready).
