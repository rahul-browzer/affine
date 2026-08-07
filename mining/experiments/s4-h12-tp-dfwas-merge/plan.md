# s4-h12-tp-dfwas-merge — H12

**Hypothesis:** Linear merge of live king TalentPigs × best *live* near-miss
`dfwasfmdpwkjglnpwngwg/affine-5ccebdzvsj-alskdjf` rev `a7336221…`
(chal-00286 +0.0139 z=1.77 gate-valid, base×≈0.998) beats TalentPigs on n80.
Independent of H6/H9/H10/H11. (Stronger dfwas-kkk +0.0244 / marsplan +0.0143
are HF 404 — same failure mode as adambell.)

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·alskdjf`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25; weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Why this parent

Best accessible positive-margin gate-valid challenger after deleted parents
(kkk/marsplan/adambell-original). Healthy baseline (base×≈1.0 on its duel).
H7/H8 null-S earners failed the band; live near-misses are the B class left.

## Method

1. Rent `mine-h12-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM; download TalentPigs + als kdjf + teacher; patch
   `vllm_client` → 480s×5 (LESSON: ReadTimeout at 180s×3).
3. `merge_linear.py` → `/root/merges/h12-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h12-1` only. No submit.
