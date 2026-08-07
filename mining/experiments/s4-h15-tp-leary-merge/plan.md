# s4-h15-tp-leary-merge — H15

**Hypothesis:** Linear merge of live king TalentPigs × chal-00315 near-miss
(`leary-criste/…-test`, +0.0059 z=0.72 gate-valid, base×≈1.017) beats
TalentPigs on n80. Independent of H6/H12–H14. Fills free slot while stronger
near-miss parents are already running or HF-blocked (Tok* gated, kkkkk 404).

**B parent:** `leary-criste/affine-5g4yy75zuz-test` @
`1e6d6d02ebe771b767c5d2bfaf3c0a1538605fc3` (exact chal-00315 rev;
`hf_hub_download(.gitattributes)` OK; 70 GB; no `*.py` / no `auto_map`).

## Prediction (pre-register BEFORE rent)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·leary`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25 (chal-00315 base×≈1.017); weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Why this parent

Next accessible healthy-baseline positive-margin after H12–H14 parents.
chal-00315: S=0.0264 vs king 0.0206, r=0.736, baseline_abs 0.127/0.125.
Weaker margin than kkk/plmk/kkkk — expect REFUTE more often than ADVANCE;
still worth a parallel slot vs idling.

## Method

1. Rent `mine-h15-1` 8×H200 `--ttl 8h`.
2. `upload_and_launch.sh` → bootstrap pinned vLLM; DL TalentPigs + leary +
   teacher; patch `vllm_client` → 480s×5.
3. `merge_linear.py` → `/root/merges/h15-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h15-1` only. No submit.
