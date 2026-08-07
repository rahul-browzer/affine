# s4-h18-tp-shatoria-merge — H18

**Hypothesis:** TalentPigs × Shatoria test3 α0.75 clears margin > 0.04.
Next accessible positive-margin B after leary (chal-00283 +0.0017 ungated,
gate-valid base×≈0.88).

**B parent:** `Shatoria/Affine-5ghntktyzq-test3` @
`a751418aa4d7fbadf871d7b567bae4dd4828884d` (HF ungated, verified pass150).

## Prediction (pre-register BEFORE rent)

- α=0.75 → n80 margin ≥ +0.04 vs TalentPigs; r∈[0.3,4]; base×≤1.25
- Weak B (+0.0017): expect near-zero or band; still the only free accessible B
- If band-INVALID → refute (no α0.85). If gate-valid 0.02≤m≤0.04 → TRY_ALPHA_095
- If m>0.04 → ADVANCE / Stage 5 prep

## Method

1. Free slot after H13 REFUTE → rent `mine-h18-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM; DL TalentPigs + Shatoria + teacher; merge α0.75.
3. Serve three; `run_sim_duel.py` n80; nested decision.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h18-1` only. No submit.
