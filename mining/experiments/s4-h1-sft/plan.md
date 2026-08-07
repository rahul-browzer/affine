# s4-h1-sft — Stage 4 H1: teacher-ref SFT from kevin init

## Hypothesis

**H1:** SFT / distill on published `teacher_refs` (z_C, y_C) from public
duel records, starting from `kevin954/Affine-5dfqbbh8ev-sft` @
`6a5815fad8f4e34c983b1933c1fae5762fe25220`, raises S enough to clear
sim margin > 0.04 vs live king.

## Prediction (pre-registered)

On an 80-turn public-D slice in the Stage-3 simulator:

- paired mean margin vs kevin ≥ **+0.04**
- both sides gate-valid
- H4 envelope: r∈[0.70,0.85], base×≤1.15

## Method (draft — next pass executes)

1. On `mine-sim-1` (engines already hot; TTL → 04:53Z): harvest teacher_refs
   from public duel gz / sim artifacts into a small chat SFT jsonl
   (thought+action targets from teacher C on scored turns).
2. Short LoRA or full SFT from kevin weights on pod (no host GPU). Prefer
   short run that finishes inside remaining TTL or extend TTL deliberately
   after `lium balance` check (floor $28k; mining spend cap $4k pre-crown).
3. Export merged safetensors (no `*.py`, no `auto_map`), serve as chall:8002
   under stock vllm, re-run `run_sim_duel.py` vs kevin:8001.
4. Decision rule below.

## Decision rule

- **Toward submit (Stage 5)** only if sim margin > 0.04 + H4 + stock vllm load.
- If 0.02–0.04: iterate (more refs / lr / steps); do not submit.
- If < 0.02 after a competent short SFT: revise recipe or try H5 warm-start;
  do not burn a slot.
- Never submit without `submit.py --check` paste + fresh hotkey.

## Prerequisites

- H2 kevin×pandora **refuted** (`../s4-h2-merge/result.md`).
- Stage 3 simulator gate MET.
- Live king still kevin @ S≈0.03956 (re-check snapshot before train + before submit).

## Out of scope

No host-side weights. No validator edits. No HF publish until margin clears.
