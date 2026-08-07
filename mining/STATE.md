# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c harvest DONE. Ready to rent + train. No pod rented.**

Stage 0–3 complete. H2 / H1 / H1v2 / H5 merge / H5b **REFUTED**.
H5c autopsy DONE; expand-refs harvest DONE (`experiments/s4-h5c-expand-refs/`).
Primary DATA = **791** short-z teacher_refs (1.8× H1's 440). No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,708.61 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` final ~**$252** (removed pass 100) |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge / H5b | **all REFUTED** |
| H5c autopsy | **DONE** — crown dL1c +0.0157 / dΛ2 +0.0123; L1 share 0.56 |
| H5c harvest | **DONE** — expanded 1329 / shortz 791 / shortz+nolist 790 |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` / `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |
| Disk | host: text + regenerable jsonl under expand-refs/results; no mine-* pods |

## What's running

| name | huid | role | check |
|---|---|---|---|
| *(none)* | — | — | no `mine-*` pods |

Validator pods `affine-eval` / `affine-bench` — do not touch.

Note: `current_eval` chal-00301 = kevin954 re-challenge (`load_challenger`).
Re-check snapshot before rent/sim (king may change).

## Blocked

Nothing hard. **Do not submit** any H1/H1v2/H2/h5/h5b checkpoint.
Cap remaining ~$3,748. Do not repeat mild TalentPigs-init 440-ref LoRA.

## Next action (single, highest value)

**Rent one `mine-h5c-1` H200** (check `lium balance` ≥ $28k floor + spend
cap; `--ttl` required; max 5 mine-*). Upload
`experiments/s4-h5c-expand-refs/results/teacher_refs_shortz.jsonl` (or
re-harvest on pod) + H1v2 `train_lora.py`/`thought_mask.py` + H5b
`merge_lora.py` + `start_h5c.sh`. Launch kevin-init thought-only LoRA on
791 shortz refs → merge → n80 vs live TalentPigs.

H5c prediction: n80 margin ≥ +0.04; r∈[0.70,0.85]; chall mean clip-L1 ≥
**0.042**. Gate >0.04 before any submit.
