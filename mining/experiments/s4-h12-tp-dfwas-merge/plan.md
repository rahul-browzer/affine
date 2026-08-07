# s4-h12-tp-dfwas-merge — H12 (pivoted → plmk)

**Hypothesis:** Linear merge of live king TalentPigs × best *downloadable*
near-miss beats TalentPigs on n80. Independent of H6/H9/H10/H11.

**B parent (pass 134 pivot):** `bluecolor777/plmk` @ `b2cc7b9f…`
(= chal-00310 `marsplan0624/affine-5gedzafcvg-plmk` +0.0143 z=1.93
gate-valid base×≈1.000; HF duplicate, ungated). Original als kdjf
(chal-00286 +0.0139) is `gated=manual` → 403; kkk/marsplan origin 404.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·plmk`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25; weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Why this parent

Strongest *accessible* positive-margin gate-valid B after als kdjf 403 and
deleted parents. Healthy baseline (base×≈1.0). H7/H8 null-S earners failed
the band; live near-misses are the B class left.

## Method

1. Rent `mine-h12-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM; DL TalentPigs + plmk mirror + teacher; patch
   `vllm_client` → 480s×5.
3. `merge_linear.py` → `/root/merges/h12-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.
6. Resume script: `resume_h12_plmk.sh` (after als kdjf 403).

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h12-1` only. No submit.
