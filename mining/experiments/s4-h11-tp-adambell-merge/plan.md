# s4-h11-tp-adambell-merge — H11

**Hypothesis:** Linear merge of live king TalentPigs × public near-miss
chal-00274 near-miss (`adambell/Affine-5dvha3y7cd-ckpt450-H6` rev
`af20efc1…`, +0.0229 z=2.37 gate-valid) beats TalentPigs on n80. Original
HF repo 404'd; weights pulled from mirror `0pentensor/5dvha3y7cd-ckpt450-H6`
@ same rev. Independent of H7–H10.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·adambell-ckpt450`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25; weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Why this parent

chal-00274 cleared min_margin (0.023>0.02) but missed 3σ (z=2.37). Baseline
was healthy (base×≈0.98 vs that king). H7/H8 null-S earners failed the band;
a gate-valid near-miss is a better B.

## Method

1. Rent `mine-h11-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM; download TalentPigs + adambell + teacher.
3. `merge_linear.py` → `/root/merges/h11-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h11-1` only. No submit.
