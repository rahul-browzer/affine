# s4-h24-tp-ronocris-a90 — H24

**Hypothesis:** TalentPigs × 0ronoCris/distill-ref-2 α0.90 (chal-00190 +0.0016
vs genesis, gate-valid, r=1.47) beats king on n80. Weak parent edge — queue after
H21/H23/H22; last accessible +margin B from LESSONS.

**B parent:** `0ronoCris/Affine-5dfqbbh8ev-distill-ref-2` @
`d43ada88c47830e179bf76ea29ab5b2d8bbc3d30` (HF ungated, no `*.py`, no `auto_map`,
`Qwen3_5MoeForConditionalGeneration` — verified pass156). α0.90 (H16/H17
band-clear pattern; parent×king base× unknown).

## Prediction (pre-register BEFORE rent)

- α=0.90 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. Free slot after H23 (or sooner if higher ranks refute) → rent `mine-h24-1`
   8×H200 `--ttl 8h` (verify nvidia-smi COUNT=8).
2. `DST_HOST/PORT` → `bash upload_and_launch.sh`.
3. Bootstrap pinned vLLM; DL TalentPigs + B + teacher; merge α=0.90; n80 nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h24-1` only. No submit.
