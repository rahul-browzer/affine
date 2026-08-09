# STATE — mining run snapshot
Rewritten every pass. Do not append.
## Stage

**Stage 4 — family pivot.** H96/H99/F1–F4/F6–**F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26**/**F27**/**F28**/**F30**/**F31**/**F33**/**F35**/**F29**/**F22** **REFUTE**.
**F32,F34,F36,F37 live** (4 pods). No submit. Best vs Tok: H81 +0.0088.
King Tok S=0.04456.

## Live facts

| item | value |
|---|---|
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a…` **S=0.04456** |
| Lium / spend | **~$179,382** · cum ~$18,314 · **avail ~$169.4k** |
| miner | τ10.000 free · 0 submissions |
| burn | **~$120.9/h** (4 mine-*) ≪ $833/h · free slots **16** |
| n80 | **F34** ~76/80 · **F32** ~43/80 · **F36** ~18/80 |
| train | **F37** RL step≥50/200 mean_r noisy; soft=18:06Z OK |
| p499 | **F22 REFUTE m=−0.06273** rm calm-hawk-98; raw past-king class CLOSED |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-f32-1 | noble-wolf-e8 | 38.255.28.22:20099 | ~16:49Z | F32 n80 SIM ~43/80 |
| mine-f34-1 | brave-eagle-b1 | 38.255.28.18:20099 | ~17:10Z | F34 n80 SIM ~76/80 |
| mine-f36-1 | zesty-orbit-ff | 86.38.238.54:40300 | ~18:25Z | F36 n80 d203 ~18/80 |
| mine-f37-1 | calm-eagle-91 | 152.236.142.241:40049 | ~19:06Z | F37 RL train→200 |

kh: `~/.ssh/id_ed25519` + `/tmp/mine-*-1.known_hosts`. Non-mine — **do not touch**.

## Blocked

No submit until n80 margin > 0.04 **vs Tok331102**.
Dead: α/plmk/TP/m7/union/lr/ep≥2/winner-zA/**F1–F18**/F19–**F21**/F24/**F17**/**F25**/**F23**/**F26–F31**/**F33**/**F35**/**F29**/**F22**/king-init LoRA.
Open: H127/F32 + H129/F34 + H131/F36 + **H132/F37**. F5 needs traj.
FALSE_PROBE≠REFUTE; never rm non-mine; COUNT>=8 gate (API lies).
`--chall-repo` = `/v1/models` id. **preempt/relaunch EXP = real exp dir**.
**p497/p498/p499:** past-king FT + raw past-king classes collapsing — **no new rents in those classes**.
**p496:** F37 soft=TTL−1h=18:06Z rearmed.
**p493:** Trainer mid-ckpt on `/root` = gocryptfs death — `save_strategy=no`.
**p487:** family clone `tf36=True` kills train — always `tf32=True` only.
**p486/p488:** bare/mid-n80 king EngineDead → king478 + reap orphans.

## Operator directive 2026-08-08T18:55Z

Unit = **family**. SCREEN→CONFIRM(k=4)→SWEEP. Cap **20**, burn **$833/h**.

## Next action

1. **Any n80 decision** (F34/F32/F36): +0.015→CONFIRM else REFUTE+rm.
2. **F37**: train→200 → post_train → merge → engines → n80. soft=18:06Z.
3. Free slots → **new orthogonal family** (not past-king FT; not raw past-earner).
