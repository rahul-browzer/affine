# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING; dual-phase sim armed.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
Post-train pipeline pid **85424** waits for `train.done` → HF adapter
salvage → GPU merge on 6,7 → chall-only re-serve → **n=40 probe then
n=80** (skips n=80 if <50 min to soft TTL 04:50Z). Mid-ckpt salvage
83669 + Lium bk `/root/h1/train` every 1h + host harvest 1393267 armed.
No submissions.

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
| Lium balance | $34,399.46 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$78.50** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — step 20/110 @ ~51s/it, ETA ~03:30Z |
| H1 pipeline | **ARMED** — pid **85424** (n40→n80 dual-phase) |
| H1 mid-ckpt salvage | **ARMED** — pid 83669 → HF `checkpoint-N/` |
| H1 HF salvage repo | **CREATED** — private `unconst/Affine-5czsc2fc98-h1-lora` |
| H1 Lium backup | **ARMED** — `lium bk` path `/root/h1/train` every 1h keep 1d |
| Host harvest | **ARMED** — pid 1393267 → `experiments/s4-h1-sft/results/` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 train + salvage+GPU-merge→n40→n80 | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- H1 pipeline: pid **85424**, log `/root/logs/h1_pipeline.nohup`
  - waits → **HF salvage** `unconst/Affine-5czsc2fc98-h1-lora` (private, adapter-only)
  → **GPU merge** `CUDA_VISIBLE_DEVICES=6,7 --device-map auto` → `/root/h1/merged`
  → **chall-only** restart (`RESTART_KING=0`; teacher+king stay hot)
  → reclaim `/root/merges/h2-kp65` after serve
  → **sim n=40** → `/root/affine_data/h1_sim_result_n40.json` (~21 min)
  → **sim n=80** → `/root/affine_data/h1_sim_result.json` if ≥50 min to 04:50Z
  - salvage meta: `/root/h1/adapter_salvage.json`
  - done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done` / `h1_sim_n40.done`
- H1 mid-ckpt salvage: pid **83669**, log `/root/logs/h1_mid_salvage.nohup`
- Harvest: `/root/h1/teacher_refs_sft.jsonl` (440 lines)

Host (no GPU):
- Artifact harvester pid **1393267**, log `.ralph/host_harvest.log`
  → SCPs sim/n40/progress/salvage/train JSON into `experiments/s4-h1-sft/results/`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z. Train ETA ~03:30Z; dual-phase
gives n40 signal even if n80 slips past TTL. **Do not** cancel the
schedule (`lium schedules rm` removes deadman with no re-add API). No
submit until sim margin > 0.04 + H4 (prefer n=80; n40 only for triage).

## Next action (single, highest value)

**Poll for sim artifacts** (prefer full
`/root/affine_data/h1_sim_result.json` or local
`experiments/s4-h1-sft/results/h1_sim_result.json`; else n40).
Also watch mid-ckpt salvage after step 50, `/root/h1/adapter_salvage.json`
after `train.done`, and pipeline log for n40→n80 / n40-only cutoff.
If sim present: apply `experiments/s4-h1-sft/plan.md` decision rule
(margin > 0.04 + H4 → Stage 5 path; 0.02–0.04 iterate; <0.02 revise).
Treat n40 as directional only — confirm with n80 before submit.
Do **not** submit until margin > 0.04 + H4.
