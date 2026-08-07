# s4-h25-tp-adambell-m7-a90 — H25

**Hypothesis:** TalentPigs × adambell ckpt1000-m7 α0.90 beats king on n80.
Parent just scored **chal-00331** margin **+0.01808** z=1.96 (gate-valid, not
crowned — bar is >0.02 ∧ z>3). Highest unused +margin B in the field.

**Origin:** `adambell/Affine-5eqdtdzqle-ckpt1000-m7` @
`f766293ee878efef5f068a4053d6974017f11f26` — **gated=manual** (403).
**Mirror (use this):** `Radiant28/5eqdtdzqle-ckpt1000-m7` @ same SHA —
ungated, no `*.py`, no `auto_map`, `Qwen3_5MoeForConditionalGeneration`,
config+index download OK (pass157). `greyAll/…` also has the SHA but gated=auto.

**Live gates (chal-00331):** chall valid, r=0.596, base_abs 0.158 / king 0.127
→ **base×1.242** (knife-edge under 1.25). α0.90 TP-dominant to pull baseline
down; if gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095.

## Prediction (pre-register BEFORE rent)

- α=0.90 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If 0.02≤m≤0.04 gate-valid → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. First free slot → rent `mine-h25-1` 8×H200 `--ttl 8h` (verify COUNT=8; reject <$20/h).
2. `DST_HOST/PORT` → `bash upload_and_launch.sh`.
3. Bootstrap pinned vLLM; DL TalentPigs + Radiant28 mirror + teacher; merge α=0.90; n80 nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h25-1` only. No submit.

## Queue priority

**Launch ahead of H23/H24** (+0.018 ≫ +0.0069 / +0.0016).
