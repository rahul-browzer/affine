# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26**/**F27**/**F28**/**F30**/**F31** **REFUTE**.
**F22,F29,F32–F36 live** (7 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,659** · cum ~$18,037 · **avail ~$169.7k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$253.6/h** (7 mine-*) ≪ $833/h · free slots **13** |
| n80 | **F29** e203 a2 (d203 died@79 king400); **F22** ~28; **F32** ~31; **F33** ~29; **F34** ~7; **F35** ~14 |
| train | **F36** full-FT ~38/60 (~22m) |
| p491 | rearmed F29/F33 watch_n80_retry (was f26-af-k1); sed'd relaunch_chall on pods+local |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 n80 e203 ~28/80 |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 n80 e203 a2 early |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 n80 ~31/80 |
| mine-f33-1 | golden-matrix-f1 | 3.135.191.208:20127 | ~17:07Z | F33 n80 ~29/80 |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 n80 ~7/80 |
| mine-f35-1 | zesty-matrix-04 | 150.136.71.147:20294 | ~17:19Z | F35 n80 ~14/80 |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 train ~38/60 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26–F28**/**F30–F31**/king-init LoRA.
Open: H117/F22 + H124/F29 + H127–**H131**/F32–**F36**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir** (p480/p491).
**p481:** full-FT finalize can omit tokenizer → copy from base before chall serve.
**p484:** never edit live `post_train_pipeline.sh` (bash-offset abort).
**p486:** bare king EngineDead → seed-from-chall king478 (n_so≥16) not cold p332.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.
**p488:** mid-n80 king TimeoutError/EngineDead → king478 + reap orphans.
**p490:** Tok/Genesis/Bittob full-FT×high-Λ2 all ≤0; past-king FT class collapsing.
**p491:** F29 d203→king400@79 → rotated e203 a2; fix live+source f26-af-k1 watchers.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **F29**: poll e203 a2 → decision; +0.015 → CONFIRM else REFUTE+rm.
2. **F36**: wait train.done → post_train → n80; if stuck after step60 check finalize/tok.
3. **Free slots (13):** rent **orthogonal** families only — not more Tok/past-king×Λ2 FT clones (class dying p490). F5 if traj ready.
