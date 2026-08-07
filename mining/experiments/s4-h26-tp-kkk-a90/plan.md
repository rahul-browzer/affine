# s4-h26-tp-kkk-a90 — H26

**Hypothesis:** TalentPigs × kkk α0.90 beats king on n80.
Parent **chal-00262** margin **+0.02442** z=2.58 (gate-valid, not crowned —
needs z>3 ∧ m>0.02). Highest +margin accessible B remaining after H25's m7.

**Origin:** `dfwasfmdpwkjglnpwngwg/affine-5ccebdzvsj-kkk` @
`7426296b0a2d74aaf0e2c282410677bfccd0dac6` — **404** (deleted).
**Mirror (use this):** `bluecolor777/kkk-af` @ **exact duel SHA**
`7426296b0a2d74aaf0e2c282410677bfccd0dac6` — ungated (tip `b38917f9fa78`
is newer; pin the duel rev). Verified pass161 `model_info(revision=…)`.

**Live gates (chal-00262):** chall valid, r=0.745, base_abs 0.129 / king 0.141
→ **base×0.918** (comfortable under 1.25). α0.90 TP-dominant.

## Prediction (pre-register BEFORE rent)

- α=0.90 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- If band-INVALID → refute (no α0.85). If 0.02≤m≤0.04 gate-valid → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. First free slot after any of h21–h25 tears → rent `mine-h26-1` 8×H200
   `--ttl 8h` (verify COUNT=8; reject <$20/h; prefer ≥$28/h).
2. `DST_HOST/PORT` → `bash upload_and_launch.sh`.
3. Bootstrap pinned vLLM; DL TalentPigs + kkk-af@7426296b + teacher; merge
   α=0.90; n80 nested decision. Chall serve at 0.72 if OOM (LESSON H20/H21).

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h26-1` only. No submit.

## Queue priority

Lottery draw for next free slot if no clip-L1-shaping recipe is ready.
**Not** a mean-shift bet: c_clipL1=+0.0288 mid-pack / pre-TP
(`s2-clip-l1-rank`). Do **not** follow with plmk (H16 already m=+0.0097).
