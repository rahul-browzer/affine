# s4-h5b-talentpigs-distill — TalentPigs-init thought-only SFT

## Parent result (H5 merge)

`experiments/s4-h5-talentpigs/`:
- α=0.65 kevin×TalentPigs → n80 chall **INVALID** base×=**4.43**
  (`reject_gates`).
- α=0.50 → merge non-identical but **unpromptable**
  (`probe_no_parsable_action_in_3_turns`); manual sample = `**` loops.
  Equal-weight MoE merge destroyed generation.

H5 merge parents **refuted**. Fallback from H5 plan: mild thought-only
distill from **TalentPigs init**.

## Hypothesis (H5b)

**Claim:** Thought-only LoRA on published `teacher_refs` from live king
`TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` nudges Λ2 toward the
teacher without wrecking the crowned empty→conditioned envelope → n80
sim margin **> 0.04** vs TalentPigs, H4 OK.

## Prediction (pre-register BEFORE train)

- n80 paired mean margin ≥ **+0.04**
- both sides gate-valid; H4: r∈[0.70,0.85], base×≤1.15
- chall mean implied clip-L1 ≥ **+0.015**
- weight_identical to king = false (LoRA delta)

If margin ∈ [0.02, 0.04] + H4 OK → iterate milder/more steps; do not
submit. If H4 fails or margin < 0.02 → refute H5b; next: try pandora or
kevin-init mild distill vs TalentPigs, or different α≠{0.5,0.65} merge
with gate-aware baseline check.

## Method

Reuse `mine-sim-1` GPUs 6,7; engines 0–5 stay (teacher + TalentPigs king;
chall may be broken h5-kt50 until post-train swap).

1. Data: `/root/h1/teacher_refs_sft.jsonl` (440 rows).
2. Base: TalentPigs snapshot `dbfbb3e2…` in pod HF cache.
3. Train: reuse `s4-h1v2-sft/train_lora.py --loss-on thought`,
   **lr=1e-5** (milder than H1v2's 2e-5 — protect crown envelope),
   1 epoch, LoRA r=16 α=32, max_len=8192 → `/root/h5b/train`.
4. `merge_lora.py` → `/root/h5b/merged` → chall:8002 → n80 vs TalentPigs.
5. Triage live-king guard; submit only if margin > 0.04 + H4.

## Decision rule

Same Stage-5 gate. Never submit H1/H1v2/H2/h5-kt* merges.
