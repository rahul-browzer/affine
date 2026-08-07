# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING (epoch 1 done); dual-phase sim armed.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
Post-train pipeline pid **86845** waits for `train.done` → HF adapter
salvage → GPU merge on 6,7 → chall-only re-serve → **n=40 then n=80**.
**checkpoint-50** on disk + HF. Epoch-1 loss **0.251** @ step 55/59
(visible via stdout scrape). Host harvest **1447863**; host deadman
**1405846** kills `mine-sim-1` at **07:00Z**. No submissions.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (contract subnet) |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,344.92 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$92.72** @ $23.60/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — step **59/110** @ ~54s/it, ETA ~**03:35Z** |
| H1 loss | ckpt50 last 0.329; epoch1 **0.251**; min 0.215 @35 |
| H1 mid-ckpt | **checkpoint-50 ON HF** (private salvage repo) |
| H1 pipeline | **ARMED** — pid **86845** (soft deadline **06:50Z**); path verified |
| H1 mid-ckpt salvage | **ARMED** — pid 83669 (ckpt-50 done; waits for 100) |
| H1 HF salvage repo | **VERIFIED** — private `unconst/Affine-5czsc2fc98-h1-lora` |
| H1 Lium backup | **ARMED** — `lium bk` path `/root/h1/train` every 1h keep 1d |
| Host harvest | **ARMED** — pid **1447863** (emit_train_progress.py; stdout losses) |
| Host deadman | **ARMED** — pid **1405846** → `lium rm mine-sim-1` at **07:00Z** |
| Lium schedule | **CANCELLED** (host deadman replaces) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 train + salvage+GPU-merge→n40→n80 | SSH `root@69.63.236.160 -p 40301`; **no Lium Removal at**; host deadman 07:00Z |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- H1 pipeline: pid **86845**, log `/root/logs/h1_pipeline.nohup`
  - waits → **HF salvage** `unconst/Affine-5czsc2fc98-h1-lora` (private, adapter-only)
  → **GPU merge** `CUDA_VISIBLE_DEVICES=6,7 --device-map auto` → `/root/h1/merged`
  → **chall-only** restart (`RESTART_KING=0`; teacher+king stay hot)
  → reclaim `/root/merges/h2-kp65` after serve
  → **sim n=40** → `/root/affine_data/h1_sim_result_n40.json` (~21 min)
  → **sim n=80** → `/root/affine_data/h1_sim_result.json` if ≥50 min to **06:50Z**
- H1 mid-ckpt salvage: pid **83669**
- Train progress/loss JSON: `/root/affine_data/h1_train_{progress,loss}.json`
- ckpt-50: on disk + HF; epoch1 loss in progress JSON (`last_loss` 0.251)

Host (no GPU):
- Artifact harvester pid **1447863**, log `.ralph/host_harvest.log`, pidfile `.ralph/host_harvest.pid`
- TTL deadman pid **1405846**, log `.ralph/host_ttl_deadman.log`
  → at 07:00Z verifies Name=`mine-sim-1` then `lium rm mine-sim-1 -y`
- Local triage: `experiments/s4-h1-sft/results/h1_train_{progress,loss}.json`
  + `h1_epoch1_milestone.json` + `emit_train_progress.py`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Budget to deadman: ~$50 extra vs old 04:53Z TTL if sim
lands late. **Next pass MUST** confirm host deadman still alive; if sim
finishes early, `lium rm mine-sim-1` after verifying name (do not wait for
07:00Z burn). No submit until sim margin > 0.04 + H4 (prefer n=80; n40
triage only).

## Next action (single, highest value)

**Poll `experiments/s4-h1-sft/results/h1_train_progress.json`** for
`train_done: true` (~**03:35Z**) then `/root/h1/adapter_salvage.json` and
pipeline log for merge→chall-only→**n40→n80**. Apply
`experiments/s4-h1-sft/plan.md` decision rule on sim margin (n40 directional;
confirm n80 before submit). Do **not** submit until margin > 0.04 + H4.
If H1 pipeline/sim done before 07:00Z: kill `mine-sim-1` immediately
(name-check first) to stop $/h burn.
