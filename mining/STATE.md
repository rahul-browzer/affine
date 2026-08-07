# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill TRAINING
(GPU-release race before merge fixed).**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Pass 82 patched
post-train pipe to wait for `train_lora.py` exit + 15s settle before merge
on GPUs 6,7 (train.done is written while 35B still resident — OOM race),
serialize adapter HF push vs mid `adapter-final`, and pass
`--base-hub TalentPigs/...`. Train **245350** untouched at step **19**/55.
No submit.

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
| Lium balance | $33,870.19 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$212** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — train step 19/55 → merge → n80; GPU-release + HF race fixes deployed |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `unconst/Affine-5czsc2fc98-h5b-lora` + `…-h5b-merged` (salvage; do not submit) |
| Disk | host: text only; pod `/root` 5.7T free |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b train→n80 + HF salvage | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall:8002 — **200**
  (chall still serves deleted-from-disk `h5-kt50` in RAM until post-train swap)
- H5b train pid **245350** GPUs 6,7 (`--loss-on thought --lr 1e-5`) step **19**/55
  @ ~50–52s/it → ETA train.done **~08:24Z**; loss@step15 **0.508**
- H5b pipe pid **251842** waiting `train.done` then **GPU settle** → merge
  (identity multi-window + CUDA unset + HF serialize)
- H5b mid-ckpt salvage pid **251832** → also salvages final `adapter/` on train.done
- Markers: `h5b/train/train.done` → `h5b_merge.done` → `h5b_chall_serve.done`
  → `h5b_sim_n80.done` → `h5b_pipeline.done`
- Sim out: `/root/affine_data/h5b_sim_result.json`
- Progress: `/root/affine_data/h5b_sim_progress.json`
- Train log: `/root/logs/h5b_train.nohup`
- Pipe log: `/root/logs/h5b_pipeline.stdout`
- Mid salvage log: `/root/logs/h5b_mid_salvage.nohup`
- Evidence: `results/h5b_gpu_release_race_fix.json`, `h5b_time_budget_pass82.json`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1884718** (`host_harvest_h5b.sh`) stop **11:45Z**
  → SCP → `triage_sim.py` → `results/h5b_decision.json` (+ HF push grace)
- Live train scrape: `results/h5b_train_progress.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*/h5b HF salvage. Cap remaining ~$3,788.

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; else refute H5b / iterate).
If absent: poll `results/h5b_train_progress.json` for steps/loss → `train.done`;
confirm pipe **251842** waits for train exit before merge (log line
`train proc gone` / `GPU settle done`); mid **251832**; harvest **1884718**;
deadman **1783662**. After merge: `h5b_identity.json` shows
`identical_to_king=false` even if `first_1MiB_identical=true`; HF push
pids / mid `adapter-final`. ETA train ~08:24Z then merge+serve+n80 →
decision ~09:30–10:30Z. Re-check snapshot before any submit. Do not rent
another pod.
