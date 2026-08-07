# s4-h19-tp-kkkk-a90 — H19

**Hypothesis:** H14 TalentPigs×kkkk α0.75 INVALID base×2.044 (same band mode
as H7–H13). α=0.90 (10% kkkk) keeps base×≤1.25 while retaining chal-00268
signal (+0.0132). Same hedge pattern as H16/H17 after H12/H13 band fails.

**B parent:** `vincentwarrior/affine-5ccebdzvsj-kkkk` @
`3ca1ebe6a952b7ad935ca53f7dd8e85b498bfcb0` (exact chal-00268 rev).

## Prediction (pre-register BEFORE rent)

- α=0.90 (`out = 0.90·TalentPigs + 0.10·kkkk`)
- n80: base×≤1.25 and paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4]; weight ≠ king
- If gate-valid and 0.02≤m≤0.04 → TRY_ALPHA_095
- If INVALID band or m<0.02 → refute; no further α on this B

## Method

1. Rent `mine-h19-1` 8×H200 `--ttl 8h` into free slot after H14 rm.
2. `upload_and_launch.sh` → bootstrap pinned vLLM; DL TalentPigs + kkkk +
   teacher; patch `vllm_client` → 480s×5.
3. `merge_linear.py` → `/root/merges/h19-tp90/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h19-1` only. No submit.
