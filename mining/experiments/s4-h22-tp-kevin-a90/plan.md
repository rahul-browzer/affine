# s4-h22-tp-kevin-a90 — H22

**Hypothesis:** TalentPigs × kevin α0.90 clears band after H10 α0.75 base×1.983 INVALID; margin>0.04.

**B parent:** `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` (HF ungated, verified pass154).

## Prediction (pre-register BEFORE rent)

- α=0.90 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. Free slot → rent `mine-h22-1` 8×H200 `--ttl 8h` (verify nvidia-smi COUNT=8).
2. Bootstrap pinned vLLM; DL TalentPigs + B + teacher; merge α=0.90.
3. Serve three; `run_sim_duel.py` n80; nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h22-1` only. No submit.
