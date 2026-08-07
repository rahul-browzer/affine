# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H1 teacher-ref LoRA SFT RUNNING on `mine-sim-1`.**

Stage 0–3 complete. H2 kevin×pandora REFUTED. H1 harvest DONE (440
examples); LoRA train pid **82057** on GPUs 6,7 (engines 0–5 still hot).
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
| Lium balance | $34,430.56 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$71.31** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 verdict | **REFUTED** (`experiments/s4-h2-merge/result.md`) |
| H1 harvest | **DONE** — 440 examples, 0 missing |
| H1 train | **RUNNING** — 110 steps, ~63s/it, ETA ~03:50Z |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H1 LoRA train + idle engines | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- H1 train: pid **82057**, log `/root/logs/h1_train.nohup`, out `/root/h1/train/`
- Done marker: `/root/h1/train/train.done` (absent until finished)
- Harvest: `/root/h1/teacher_refs_sft.jsonl` (440 lines)
- peft 0.20.0 + accelerate 1.14.0 installed in `/root/venv`

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z (~3h left @ 01:54Z). Train ETA ~03:50Z
leaves ~1h for merge+re-serve+sim — tight. **Do not** cancel the schedule
(no Lium “extend TTL” API; only `schedules rm` which would orphan without
TTL). If train slips past ~04:20Z, prefer finishing merge on this pod and
deferring sim, or rent `mine-sft-1` / replace with a fresh TTL pod — never
leave a pod without a TTL. No submit until sim margin > 0.04 + H4.

## Next action (single, highest value)

**When `/root/h1/train/train.done` exists:** merge LoRA → `/root/h1/merged`
(`merge_lora.py`), restart chall:8002 on that dir, run `run_sim_duel.py`
vs kevin, apply plan.md decision rule. Poll train via
`tail /root/logs/h1_train.nohup`. Do **not** submit until margin > 0.04 + H4.
