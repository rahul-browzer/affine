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

## Method (executing)

1. **Harvest** (`harvest_refs.py`): 16 public duel gz → dedupe by turn_id,
   keep max-`lp_own` teacher sample; join prefixes from pod `turns.jsonl`.
   Completion format = Affine inject body after open `<think>`:
   `</think>\nTHOUGHT: {z}\n\n{y}`. Result: **440** examples, 0 missing
   (`results/teacher_refs_sft.meta.json`).
2. **LoRA SFT** (`train_lora.py`) on `mine-sim-1` GPUs **6,7** (engines
   stay on 0–5). Base = kevin snapshot `6a5815…`. r=16 α=32, lr=1e-4,
   2 epochs, batch=1 accum=8, max_len=8192 → **110** optimizer steps.
   Launched 2026-08-07T01:51Z pid 82057; log `/root/logs/h1_train.nohup`.
   First step ~63s → ETA ~03:50Z (TTL remove 04:53Z).
3. **After `train.done`:** `merge_lora.py` → `/root/h1/merged` safetensors
   (strip `auto_map` / `*.py`); restart chall:8002 on that dir; run
   `run_sim_duel.py` vs kevin:8001.
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
