# s4-h16-tp-plmk-a90 — H16

**Hypothesis:** H12 α0.75 TP×plmk hit base×2.02 despite parent duel
base×≈1.000. Reducing B mass to α=0.90 (10% plmk) keeps empty-baseline
≤1.25× king while still weight-distinct from TalentPigs, and may clear
margin > 0.04.

**B parent:** `bluecolor777/plmk` @
`b2cc7b9fb35232c6611254cd6f465a91f590469c` (= chal-00310 +0.0143;
same mirror H12 used).

## Prediction (pre-register BEFORE rent)

- α=0.90 first (`out = 0.90·TalentPigs + 0.10·plmk`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25; weight ≠ king (max_abs_delta over all keys)
- If 0.02≤margin≤0.04: try α=0.95
- If INVALID band or margin<0.02 → refute

## Why this (not Shatoria)

Only other accessible healthy-baseline leftover was Shatoria +0.0017 — too
weak. H12 taught parent-duel base× ≠ merge base× at 25% B; α0.90 is the
direct falsifier of "any nonzero plmk fraction sabotages band".

## Method

1. Rent `mine-h16-1` 8×H200 `--ttl 8h`.
2. `upload_and_launch.sh` → bootstrap pinned vLLM; DL TalentPigs + plmk +
   teacher; patch `vllm_client` → 480s×5.
3. `merge_linear.py` α0.90 → `/root/merges/h16-tp90/`.
4. Serve teacher:8000 / king:8001 / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h16-1` only. No submit.
