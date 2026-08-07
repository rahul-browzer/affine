# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING; post-train merge now GPU-fast.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
Post-train pipeline pid **84156** waits for `train.done` → HF adapter
salvage → **GPU merge on 6,7** → re-serve chall → sim. Mid-ckpt salvage
pid **83669** and host artifact harvester pid **1375476** armed. No
submissions.

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
| Lium balance | $34,414.67 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$75.13** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — step 10/110 @ ~61s/it, ETA ~03:45Z |
| H1 pipeline | **ARMED** — pid **84156** (GPU merge patch; was 83414) |
| H1 mid-ckpt salvage | **ARMED** — pid 83669 → HF `checkpoint-N/` |
| H1 HF salvage repo | **CREATED** — private `unconst/Affine-5czsc2fc98-h1-lora` |
| Host harvest | **ARMED** — pid 1375476 → `experiments/s4-h1-sft/results/` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 train + salvage+GPU-merge→sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- H1 pipeline: pid **84156**, log `/root/logs/h1_pipeline.nohup`
  - waits → **HF salvage** `unconst/Affine-5czsc2fc98-h1-lora` (private, adapter-only)
  → **GPU merge** `CUDA_VISIBLE_DEVICES=6,7 --device-map auto` → `/root/h1/merged`
  → restart chall → sim
  - salvage meta: `/root/h1/adapter_salvage.json`
  - sim out: `/root/affine_data/h1_sim_result.json`
  - done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done`
- H1 mid-ckpt salvage: pid **83669**, log `/root/logs/h1_mid_salvage.nohup`
  (uploads `checkpoint-50` etc under HF path `checkpoint-N/`)
- Harvest: `/root/h1/teacher_refs_sft.jsonl` (440 lines)

Host (no GPU):
- Artifact harvester pid **1375476**, log `.ralph/host_harvest.log`
  → SCPs sim/salvage/train JSON into `experiments/s4-h1-sft/results/` before TTL

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z. Train ETA ~03:45Z; GPU merge should
cut post-train vs prior CPU path; salvage+merge+serve ~5–12m; sim ~40m →
finish ~04:35Z if on schedule. Mid-ckpt + final adapter salvage + host SCP
cover TTL kill. **Do not** cancel the schedule (`lium schedules rm` removes
deadman with no re-add API). No submit until sim margin > 0.04 + H4.

## Next action (single, highest value)

**Poll for `/root/affine_data/h1_sim_result.json` (or local
`experiments/s4-h1-sft/results/h1_sim_result.json` from host harvest).**
Also confirm mid-ckpt salvage after step 50 (`/root/h1/mid_checkpoint-50_salvage.json`)
and final `/root/h1/adapter_salvage.json` after `train.done`.
If sim present: apply `experiments/s4-h1-sft/plan.md` decision rule
(margin > 0.04 + H4 → Stage 5 path; 0.02–0.04 iterate; <0.02 revise).
If pipeline stuck after `train.done`: check `/root/logs/h1_pipeline.nohup`
(expect GPU merge on 6,7). Do **not** submit until margin > 0.04 + H4.
