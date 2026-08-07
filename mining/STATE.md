# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING; post-train pipeline ARMED.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
Post-train watchdog pid **83194** waits for `train.done` → merge →
re-serve chall → sim. No submissions.

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
| Lium balance | $34,422.81 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$72.08** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — step 3/110 @ ~60s/it, ETA ~03:45Z |
| H1 pipeline | **ARMED** — pid 83194 waiting on `train.done` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 train + armed merge→sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- H1 pipeline: pid **83194**, log `/root/logs/h1_pipeline.nohup`
  - waits → merge `/root/h1/merged` → restart chall → sim
  - sim out: `/root/affine_data/h1_sim_result.json`
  - done markers: `/root/logs/h1_pipeline.done`, `/root/logs/h1_sim.done`
- Harvest: `/root/h1/teacher_refs_sft.jsonl` (440 lines)

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z. Train ETA ~03:45Z; merge+serve ~10–15m;
sim ~40m → finish ~04:40Z if on schedule. Pipeline is armed so pass gaps
won't miss the handoff. **Do not** cancel the schedule (no Lium extend API).
If train slips past ~04:00Z, prefer finishing merge on this pod and deferring
sim, or rent `mine-sft-1` with a fresh TTL — never leave a pod without a TTL.
No submit until sim margin > 0.04 + H4.

## Next action (single, highest value)

**Poll for `/root/affine_data/h1_sim_result.json` (or `/root/logs/h1_sim.done`).**
If present: SCP result, apply `experiments/s4-h1-sft/plan.md` decision rule
(margin > 0.04 + H4 → Stage 5 path; 0.02–0.04 iterate; <0.02 revise).
If pipeline stuck after `train.done`: check `/root/logs/h1_pipeline.nohup`.
Do **not** submit until margin > 0.04 + H4.
