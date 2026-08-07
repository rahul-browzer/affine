# s4-h13-tp-kkk-merge — H13

**Hypothesis:** Linear merge of live king TalentPigs × chal-00262 near-miss
(`kkk`, +0.0244 z=2.58 gate-valid, strongest non-crown positive margin) beats
TalentPigs on n80. Independent of H6/H9/H10/H11/H12.

**B parent:** `bluecolor777/kkk-af` @ `7426296b0a2d74aaf0e2c282410677bfccd0dac6`
(= exact chal-00262 rev of deleted `dfwas…/…-kkk`; ungated HF duplicate;
`hf_hub_download(.gitattributes)` OK). Origin 404. `bluecolor777/kkk` @e3563a
is a *different* SHA — do not use it as B.

## Prediction (pre-register BEFORE rent)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·kkk-af`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25 (chal-00262 base×≈0.92); weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Why this parent

Best accessible near-miss left: +0.0244 > H11's +0.023 / H12's +0.014.
Healthy baseline. H7/H8 null-S earners failed band; live near-misses are the
B class. Backup B if kkk-af vanishes: `vincentwarrior/affine-5ccebdzvsj-kkkk`
@`3ca1ebe6…` (=chal-00268 +0.0132).

## Method

1. On first free `mine-*` slot: rent `mine-h13-1` 8×H200 `--ttl 8h`.
2. `upload_and_launch.sh` → bootstrap pinned vLLM; DL TalentPigs + kkk-af +
   teacher; patch `vllm_client` → 480s×5.
3. `merge_linear.py` → `/root/merges/h13-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h13-1` only. No submit.

## Gate to launch

Slots full (5/5). Launch immediately when any of H6/H9/H10/H11/H12 resolves
REFUTE and that pod is removed — prefer H13 over weaker backups.
