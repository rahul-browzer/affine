# R3 — GRPO / REINFORCE on Reason (teacher lp delta)

## Axis
**Priority** (operator 2026-08-11). Orthogonal to R2 board-copy screens.
Optimize the ranked quantity directly: reward = Reason =
`lpC(y_C|z_A) − lpC(y_C|∅)` from live teacher echo+logprobs.

## Claim
Tok-init LoRA trained with group-relative policy gradient on thought tokens
(reward = Reason) beats live king by paired margin > live `(k_sigma·SE)` with
~1.5× headroom on a fresh n80 slice.

## Pod
`mine-r3-grpo-1` · huid `golden-hawk-ff` · id `d55eec0f-6dc6-4e07-a3fb-602395dca847`
8×B300 @$64/h · TTL → 2026-08-12T16:29Z · SSH `root@204.9.206.245 -p 40051`

## Method (next passes)
1. Bootstrap: uv venv, vllm 0.22.1, B300 flash patch, pandas/pyarrow, mine.env.
2. Download teacher `zai-org/GLM-4.5-Air-FP8` + king Tok af10; restore visual/preprocessor.
3. Serve teacher on GPUs 0–1 (tp=2, max_model_len=65536, restore knobs).
4. Train LoRA on GPUs 6–7: adapt `s4-h132-f37-tok-rl-l2/train_rl_l2.py`
   (REINFORCE on Λ2 ≡ Reason) → GRPO group baseline G≥2, max_new≈256–1024,
   lr~5e-6, data = corpus prefixes + teacher y (not CE on harvested z).
5. Merge + graft visual → chall reload → n80 vs Tok on fresh slice.
6. Decision: submit only if margin ≥ **1.5 × (k_sigma·SE)** (live k_sigma=2.0).

## Decision rule (pre-register)
- margin ≤ 0 or hr < 0.5× → REFUTE; keep pod only if next R3 variant ready.
- 0.5× ≤ hr < 1.5× → WEAK_SKIP; iterate hyperparams / group size.
- hr ≥ 1.5× on fresh slice → Stage 5 (fresh hotkey, `submit.py --check`).

## Why not more R2 board copies
R2as/R2aq/R2ap family saturates serial n80 on `mine-crown-1`. R3 is the
structurally different axis the burn floor is meant to buy.
