# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5 merge REFUTED; H5b TalentPigs-init thought distill OPEN
(n80 sim RUNNING attempt 1/3, ~19/80).**

Stage 0–3 complete. H2 / H1 / H1v2 / **H5 merge** **REFUTED**. Live king
`TalentPigs/affine-5ekxlcg3fx-abc` reign 3 @ S=0.0315. Train **DONE**
55/55 loss@55 **0.425**. Merge+visual OK → chall:8002 **200** → n80
pid **276121** advancing king**19**/chall**19** @ 08:52:42Z
(window ~1.14 tpm → ETA **~09:46Z**; overall ~1.61 tpm). Advancing.
No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** (kevin reign 2 earning; pandora reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** (`api/v1/contract` → `subnet`) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,776.76 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **~$235** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge | **all REFUTED** |
| H5b | **open** — n80 running (king19/chall19 @ 08:52Z; ETA ~09:46Z) |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` adapter-final @ `ad537ed…`; `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |
| Disk | host: text only; pod `/root` ok; merged at `/root/h5b/merged` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | H5b n80 sim + harvest | SSH `root@69.63.236.160 -p 40301`; deadman **12:00Z** |

On pod:
- Engines: teacher:8000 + king TalentPigs:8001 + chall:8002 — **all 200**
- H5b pipe pid **266631** — waiting n80
- n80 sim pid **276121** (`run_sim_duel.py` attempt **1/3**); out
  `/root/affine_data/h5b_sim_result.json`; progress
  `/root/affine_data/h5b_sim_progress.json` (king **19**/chall **19** @ 08:52:42Z)
- Rate: window ~1.14 k/c-tpm (slowed vs pass92 ~2.1); overall ~1.61 → ETA
  **~09:46Z**; deadman slack OK (~134 min)
- Markers: `train.done` ✓ → `h5b_merge.done` ✓ → `h5b_chall_serve.done` ✓
  → `h5b_sim_n80.done` (pending) → `h5b_pipeline.done`
- HF merged salvage **DONE** `e1d39a1…` (private; not a submission)
- Pipe log: `/root/logs/h5b_pipeline.stdout`
- Sim log: `/root/logs/h5b_sim.nohup`
- Evidence: `results/h5b_sim_progress.json`, `h5b_time_budget_pass93.json`
- **LANDMINE:** never SCP/edit `post_train_pipeline.sh` while a live pipe
  sleeps in its wait loop (bash file offset → `ted: command not found`)

Host (no GPU):
- TTL deadman pid **1783662** @ **12:00Z**
- H5b harvest pid **1964910** (`host_harvest_h5b.sh`) stop **11:45Z**
  → stage-aware scrape → `results/h5b_train_progress.json` (`stage` field)
  → SCP only after n80/pipeline **done** → `triage_sim.py` →
  `results/h5b_decision.json`; OR abort → decision `pipe_aborted`
- Ignore archived `h5b_decision_pass90_false_abort.json` (rc=127 landmine)

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. **Do not submit** H1/H1v2/H2/h5-kt*/h5b HF salvage. Cap remaining ~$3,765.
Ignore archived false abort. ETA n80 done ~09:46Z (window ~1.14 tpm; slack to deadman OK).

## Next action (single, highest value)

**Check `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json`
(or `host_harvest_h5b.done` / `h5b_sim_result.json`).** If present: apply
decision (margin > 0.04 + H4 + live-king → Stage 5; `pipe_aborted` → read
abort text + pivot; else refute H5b / iterate). If absent: confirm n80
advancing via `h5b_sim_progress.json` / harvest `stage=n80`; if sim dies
once, check `h5b_sim_retries.log` (≤3). Pipe **266631**; sim **276121**;
harvest **1964910**; deadman **1783662**. Re-check snapshot before any
submit. Do not rent another pod. Do not edit the live pipe script on the pod.
