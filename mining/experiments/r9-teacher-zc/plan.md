# R9 — Tok LoRA × expanded teacher z_C (format prior)

## Axis
`mine-r9-teacher-zc-1` · fleet queue R9.

Teach the live king to emit **teacher-shaped** thoughts (`z_C` from published
teacher_refs), not miner winner-z_A.

## Why not H102 / H123
- H102 Genesis-LoRA × shortz → REFUTE (Λ2 −0.052).
- H123 Tok full-FT × shortz → REFUTE (margin −0.0098).
- R9 = **Tok LoRA × expanded refs** (1329, z p50≈216 / p90≈600) @ longer ctx —
  different init/recipe/data cut under Reason v3.

## Claim
Tok af10 init, thought-only LoRA r=32/α64 lr=1e-5 EPOCHS=3 max_len=16384 on
`teacher_refs_expanded.jsonl` → paired Reason margin clears live **2·SE** with
≥1.5× headroom on fresh n80.

## Decision (pre-register)
- margin ≤ 0 → REFUTE; free slot.
- 0 < margin < 1.5×(2·SE) → WEAK_SKIP (no Stage-5).
- margin ≥ 1.5×(2·SE) → Stage-5 shortlist.
