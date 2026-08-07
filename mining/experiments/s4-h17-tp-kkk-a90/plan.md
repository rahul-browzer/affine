# s4-h17-tp-kkk-a90 — H17

**Hypothesis:** H13 runs TalentPigs×kkk-af α0.75 (strongest near-miss
chal-00262 +0.0244). H7–H12 showed α0.75 can still sabotage empty-baseline
even when B itself was healthy (H12 parent ×1.00 → merge ×2.02). Running
α=0.90 (10% kkk-af) in parallel hedges the band while H13 is live.

**B parent:** `bluecolor777/kkk-af` @
`7426296b0a2d74aaf0e2c282410677bfccd0dac6` (exact chal-00262 rev;
`hf_hub_download(.gitattributes)` OK; ungated). Same B as H13, different α —
independent of H14/H15/H16 outputs.

## Prediction (pre-register BEFORE rent)

- α=0.90 (`out = 0.90·TalentPigs + 0.10·kkk-af`)
- n80: base×≤1.25 and paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4]; weight ≠ king
- If gate-valid and 0.02≤m≤0.04 → TRY_ALPHA_095
- If INVALID band or m<0.02 → refute; no α0.95 on gate-fail
- If H13 ADVANCE first → tear this pod (α0.75 already wins)

## Method

1. Rent `mine-h17-1` 8×H200 `--ttl 8h` (fills free slot; 5/5).
2. `upload_and_launch.sh` → bootstrap pinned vLLM; DL TalentPigs + kkk-af +
   teacher; patch `vllm_client` → 480s×5.
3. `merge_linear.py` → `/root/merges/h17-tp90/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h17-1` only. No submit.
