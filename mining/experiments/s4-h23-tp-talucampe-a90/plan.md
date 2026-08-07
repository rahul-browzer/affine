# s4-h23-tp-talucampe-a90 — H23

**Hypothesis:** TalentPigs × Talucampe037/ck5 α0.90 (chal-00193 +0.0069, gate-valid)
beats king on n80. New parent class; later Talucampe ck10/ck11 unservable — use
**ck5 only** @ da35105f (scored live).

**B parent:** `Talucampe037/Affine-5f6xxabdmp-ck5` @
`da35105f9e3d43e5d30ddc913d8a3d4f63865ffb` (HF ungated, no `*.py`, no `auto_map`,
`Qwen3_5MoeForConditionalGeneration` — verified pass155). Live duel base× unknown
(duel API 403) → α0.90 (H16/H17 band-clear pattern).

## Prediction (pre-register BEFORE rent)

- α=0.90 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. Free slot → rent `mine-h23-1` 8×H200 `--ttl 8h` (verify nvidia-smi COUNT=8).
2. `DST_HOST/PORT` → `bash upload_and_launch.sh`.
3. Bootstrap pinned vLLM; DL TalentPigs + B + teacher; merge α=0.90; n80 nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h23-1` only. No submit.

## Next-in-queue after H23

- H24 candidate: `0ronoCris/Affine-5dfqbbh8ev-distill-ref-2` @ d43ada88 (+0.0016 ungated).
- ally1 / hope100: **not in public history** (pass155) — drop from STATE queue.
