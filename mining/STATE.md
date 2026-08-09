# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26**/**F27**/**F28**/**F30**/**F31**/**F33**/**F35** **REFUTE**.
**F22,F29,F32,F34,F36,F37 live** (6 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,416** · cum ~$18,280 · **avail ~$169.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$212.4/h** (6 mine-*) ≪ $833/h · free slots **14** |
| n80 | **F22/F29/F32/F34/F36** SIM_ALIVE (no decision yet) |
| train | **F37** RL step≥35 mean_r noisy; soft=18:06Z OK |
| p497 | **F35 REFUTE m=−0.0843** rm; past-king FT class still dying |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f22-1 | calm-hawk-98 | 204.9.206.243:40300 | ~14:27Z | F22 n80 SIM |
| mine-f29-1 | gentle-shark-9c | 152.236.142.234:40300 | ~16:26Z | F29 n80 e203 SIM |
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 n80 SIM |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 n80 SIM |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 n80 d203 SIM |
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 RL train→200 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26–F28**/**F30–F31**/**F33**/**F35**/king-init LoRA.
Open: H117/F22 + H124/F29 + H127/F32 + H129/F34 + H131/F36 + **H132/F37**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir** (p480/p491).
**p481/p493:** full-FT finalize/tokenizer: `cp -L` from base (HF symlinks ≠ files under `/tmp`).
**p486:** bare king EngineDead → seed-from-chall king478 (n_so≥16) not cold p332.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.
**p488:** mid-n80 king TimeoutError/EngineDead → king478 + reap orphans.
**p490:** Tok/Genesis/Bittob full-FT×high-Λ2 all ≤0; past-king FT class collapsing.
**p491:** F29 d203→king400@79 → rotated e203 a2; fix live+source f26-af-k1 watchers.
**p493:** Trainer mid-ckpt on `/root` = gocryptfs death — `save_strategy=no`; salvage ckpt model shards.
**p496:** F33 pandora-FT REFUTE m=−0.0216; F37 soft=TTL−1h=18:06Z rearmed.
**p497:** F35 everest-FT REFUTE m=−0.0843 λ2_c=−0.017; do **not** rent more past-king FT.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Any n80 decision** (F29/F22/F34/F32/F36): +0.015→CONFIRM else REFUTE+rm.
2. **F37**: train→200 → post_train → merge → engines → n80. soft=18:06Z.
3. Free slots → **new orthogonal family** (not past-king×Λ2 FT).
