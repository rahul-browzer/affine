# s4-h6-talentpigs-shortz-mild — H6

**Hypothesis:** TalentPigs-init thought-only LoRA on **shortz-nolist** teacher_refs
at **lr=5e-6** raises clip-L1 ≥ 0.042 → n80 margin > 0.04 (r only needs [0.3,4.0]).

## Why this (not H5b / H5c)

| prior | init | data | lr | failure |
|---|---|---|---|---|
| H5b | TalentPigs | 440 stale | 1e-5 | r=0.670 (below H4), L1 flat vs king |
| H5c mid50 | kevin | shortz 791 | 2e-5 | r=0.897, clipL1 0.015, margin −0.019 |
| **H6** | TalentPigs | shortz-nolist 790 | **5e-6** | (open) |

Crown autopsy (chal-00284): win is Δclip-L1 at r≈0.72 + short non-listy z.
H5b overshot envelope (too much lr / wrong data). H5c kevin-init pushes r up.
H6 = stay on crowned init, use crown-style data, half H5b lr.

## Prediction (pre-register BEFORE train)

- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates valid (r∈[0.3,4.0], baseline≤1.25×); invented H4 band dropped
- chall mean clip-L1 ≥ **0.042**
- weight ≠ king

## Method

Reuse `mine-h5c-1` GPUs **6,7** while H5c final n80 occupies engines 0–5.

1. Data: `teacher_refs_shortz_nolist.jsonl` (790, z≤250, listy dropped).
2. Base: `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` (pod HF cache).
3. `train_lora.py --loss-on thought` lr=5e-6, r16/α32, 1 epoch → `/root/h6/train`.
4. `post_train_pipeline.sh` waits train.done → merge → wait H5c n80 frees chall → n80.
5. Submit only if margin > 0.04 + gates valid.

## Decision rule

- margin > 0.04 + gates valid → Stage 5 prep.
- margin ∈ [0.02, 0.04] + gates valid → iterate (more steps / 7.5e-6); no submit.
- margin < 0.02 or invalid → refute H6; next ≠ TalentPigs thought LoRA ≤1e-5
  and ≠ kevin thought LoRA.
