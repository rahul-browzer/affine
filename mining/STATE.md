# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill TRAINING
(HF salvage + final-adapter mid-salvage armed).**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Pass 80 fixed
mid-ckpt watcher to salvage final `adapter/` on `train.done` (was exit-before-
push race); host harvest now emits `h5b_train_progress.json` + waits HF push
PIDs after triage. Freed unused `h5-kt65` (68G). Train **245350** untouched
at step **8**/55. No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin reign 2 earning; pandora reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | re-check `api/v1/contract` before any submit |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,885.70 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$208** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — train step 8/55 → merge → n80; final-adapter salvage armed |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `unconst/Affine-5czsc2fc98-h5b-lora` + `…-h5b-merged` (salvage; do not submit) |
| Disk | host: text only; pod `h5b/` + engines; `/root/merges` empty |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b train→n80 + HF salvage | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall:8002 — **200**
  (chall still serves deleted-from-disk `h5-kt50` in RAM until post-train swap)
- H5b train pid **245350** GPUs 6,7 (`--loss-on thought --lr 1e-5`) step **8**/55
  @ ~58–63s/it → ETA train.done **~08:28Z**; loss@step5 **0.596**
- H5b pipe pid **246775** waiting `train.done` (HF push after merge)
- H5b mid-ckpt salvage pid **247579** → also salvages final `adapter/` on train.done
- Markers: `h5b/train/train.done` → `h5b_merge.done` → `h5b_chall_serve.done`
  → `h5b_sim_n80.done` → `h5b_pipeline.done`
- Sim out: `/root/affine_data/h5b_sim_result.json`
- Progress: `/root/affine_data/h5b_sim_progress.json`
- Train log: `/root/logs/h5b_train.nohup`
- Pipe log: `/root/logs/h5b_pipeline.stdout`
- Mid salvage log: `/root/logs/h5b_mid_salvage.nohup`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1884718** (`host_harvest_h5b.sh`) stop **11:45Z**
  → SCP → `triage_sim.py` → `results/h5b_decision.json` (+ HF push grace)
- Evidence: `experiments/s4-h5b-talentpigs-distill/results/h5b_final_adapter_salvage_fix.json`
- Live train scrape: `results/h5b_train_progress.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*/h5b HF salvage. Cap remaining ~$3,792.

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; else refute H5b / iterate).
If absent: poll `results/h5b_train_progress.json` for steps/loss → `train.done`;
confirm pipe **246775** + mid **247579** + harvest **1884718** + deadman
**1783662**; after merge, confirm HF push pids `h5b_push_{adapter,merged}.pid`
and mid salvage of `adapter-final`. ETA train ~08:28Z then merge+serve+n80 →
decision ~09:30–10:30Z. Re-check snapshot before any submit. Do not rent
another pod.
