# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill TRAINING
(n80≤3 + abort-aware harvest + packed-visual merge fix deployed).**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Pass 89 fixed
`merge_lora` for TalentPigs packed visual (would have killed chall serve).
Train **245350** at step **46**/55. No submit.

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
| Lium balance | $33,831.21 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$222** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — train step 46/55 → merge (packed-visual fix) → n80 (≤3) |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `unconst/Affine-5czsc2fc98-h5b-lora` + `…-h5b-merged` (salvage stubs; do not submit) |
| Disk | host: text only; pod `/root` 5.7T free; `/root/merges` empty |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b train→n80 + HF salvage | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 — **200**; chall:8002 —
  **stopped** (GPUs 4,5=0 MiB; pipe will chall-only after merge)
- H5b train pid **245350** GPUs 6,7 (`--loss-on thought --lr 1e-5`) step **46**/55
  @ ~57–59s/it → ETA train.done **~08:28Z**; loss@step40 **0.468**
- H5b pipe pid **258082** waiting `train.done` then GPU settle → merge
  (uses fixed `merge_lora.py` md5 `e5f51cec…`) → identity → HF async →
  chall-only → **n80 ≤3**; EXIT abort-trap armed
- H5b mid-ckpt salvage pid **251832** → also salvages final `adapter/` on train.done
- Markers: `h5b/train/train.done` → `/root/logs/h5b_merge.done` →
  `h5b_chall_serve.done` → `h5b_sim_n80.done` → `h5b_pipeline.done`
  (or `h5b_pipeline.aborted`)
- Sim out: `/root/affine_data/h5b_sim_result.json`
- Progress: `/root/affine_data/h5b_sim_progress.json`
- Train log: `/root/logs/h5b_train.nohup`
- Pipe log: `/root/logs/h5b_pipeline.stdout`
- Mid salvage log: `/root/logs/h5b_mid_salvage.nohup`
- Evidence: `results/h5b_talentpigs_visual_restore_fix.json`,
  `h5b_time_budget_pass89.json`

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1935669** (`host_harvest_h5b.sh`) stop **11:45Z**
  → stage-aware scrape → `results/h5b_train_progress.json` (`stage` field)
  → SCP only after n80/pipeline **done** → `triage_sim.py` →
  `results/h5b_decision.json`; OR abort → decision `pipe_aborted`
- Live train scrape: `experiments/s4-h5b-talentpigs-distill/results/h5b_train_progress.json`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*/h5b HF salvage. Cap remaining ~$3,778.
Expect `engines.chall=0` until post-merge serve — intentional.
After merge, confirm `model-visual-restored.safetensors` exists under
`/root/h5b/merged` and `visual_keys=333` in merge log before trusting serve.

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; `pipe_aborted` → read
abort text + pivot; else refute H5b / iterate). If absent: read
`results/h5b_train_progress.json` **`stage`** field
(`waiting_train`→`post_train`→`merge_identity`→`serve`/`n80`→`n80_done`/`aborted`)
+ step/loss → confirm pipe **258082** advances past train.done; confirm
merge log shows packed-visual restore (`model-visual-restored.safetensors`,
`visual_keys=333`); confirm `identical_to_king=false`; confirm chall:8002
**200** on GPUs 4,5; if n80 fails once, check `h5b_sim_retries.log`. Mid
**251832**; harvest **1935669**; deadman **1783662**. ETA train ~08:28Z
then merge+serve+n80 → decision ~09:15–10:20Z. Re-check snapshot before
any submit. Do not rent another pod.
