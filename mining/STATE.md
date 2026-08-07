# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill TRAINING
(n80≤3 + abort-aware harvest + HF wait off critical path).**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Pass 86 removed the
post-merge mid-HF ≤10m wait from the n80 critical path; chall-only via
`restart_for_h2`. Train **245350** untouched at step **35**/55. No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin reign 2 earning; pandora reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** (`api/v1/contract`) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,846.85 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$217** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — train step 35/55 → merge → n80 (≤3); HF salvage non-blocking |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `unconst/Affine-5czsc2fc98-h5b-lora` + `…-h5b-merged` (salvage stubs; do not submit) |
| Disk | host: text only; pod `/root` 5.7T free |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b train→n80 + HF salvage | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall:8002 — **200**
  (chall still serves deleted-from-disk `h5-kt50` in RAM until post-train swap)
- H5b train pid **245350** GPUs 6,7 (`--loss-on thought --lr 1e-5`) step **35**/55
  @ ~56s/it → ETA train.done **~08:27Z**; loss@step35 **0.468**
- H5b pipe pid **258082** waiting `train.done` then GPU settle → merge
  → identity → HF async → chall-only (`restart_for_h2`) → **n80 ≤3**;
  EXIT abort-trap armed; **no mid-HF wait on critical path**
- H5b mid-ckpt salvage pid **251832** → also salvages final `adapter/` on train.done
- Markers: `h5b/train/train.done` → `/root/logs/h5b_merge.done` →
  `h5b_chall_serve.done` → `h5b_sim_n80.done` → `h5b_pipeline.done`
  (or `h5b_pipeline.aborted`)
- Sim out: `/root/affine_data/h5b_sim_result.json`
- Progress: `/root/affine_data/h5b_sim_progress.json`
- Train log: `/root/logs/h5b_train.nohup`
- Pipe log: `/root/logs/h5b_pipeline.stdout`
- Mid salvage log: `/root/logs/h5b_mid_salvage.nohup`
- Evidence: `results/h5b_hf_wait_off_critical_path_fix.json`,
  `h5b_time_budget_pass86.json`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1917667** (`host_harvest_h5b.sh`) stop **11:45Z**
  → SCP only after n80/pipeline **done** → `triage_sim.py` →
  `results/h5b_decision.json`; OR abort → decision `pipe_aborted`
- Live train scrape: `experiments/s4-h5b-talentpigs-distill/results/h5b_train_progress.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*/h5b HF salvage. Cap remaining ~$3,783.

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; `pipe_aborted` → read
abort text + pivot; else refute H5b / iterate). If absent: poll
`results/h5b_train_progress.json` for steps/loss → `train.done`; confirm
pipe **258082** log lines `train proc gone` / `GPU settle done` → merge →
`h5b_identity.json` (`identical_to_king=false`); confirm chall-only
`restart_for_h2` (no mid-HF wait); if n80 fails once, confirm retry in
`h5b_sim_retries.log` / pipe log. Mid **251832**; harvest **1917667**;
deadman **1783662**. ETA train ~08:27Z then merge+serve+n80 → decision
~09:20–10:30Z. Re-check snapshot before any submit. Do not rent another pod.
