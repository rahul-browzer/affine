# s4-h21-tp-sft2 — H21

**Hypothesis:** TalentPigs × syntaxsorcerer1/sft2 α0.75 (chal-00325 +0.0109 base×1.009 ungated) beats king on n80.

**B parent:** `syntaxsorcerer1/Affine-5gbhwtw4zo-sft2` @ `affa6d81675d81c512bcc4a77d95ff4191214601` (HF ungated, verified pass154).

## Prediction (pre-register BEFORE rent)

- α=0.75 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. Free slot → rent `mine-h21-1` 8×H200 `--ttl 8h` (verify nvidia-smi COUNT=8).
2. Bootstrap pinned vLLM; DL TalentPigs + B + teacher; merge α=0.75.
3. Serve three; `run_sim_duel.py` n80; nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h21-1` only. No submit.
