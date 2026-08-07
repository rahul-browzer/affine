# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H2 kevin×pandora REFUTED; pivot to H1 teacher-ref SFT.**

Stage 0–3 complete. H2 α=0.5 margin **−0.00996**; α=0.65 margin
**+0.00725** — both < 0.02 → H2 refuted for these parents. No submissions.
`experiments/s4-h1-sft/plan.md` drafted. Engines on `mine-sim-1` kept hot.

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
| Lium balance | $34,446.14 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$66.86** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| H2 α=0.5 sim | **DONE** — margin −0.00996 |
| H2 α=0.65 sim | **DONE** — margin +0.00725 @ 01:37Z |
| H2 verdict | **REFUTED** for kevin×pandora (`experiments/s4-h2-merge/result.md`) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 — engines idle-hot after H2; ready for H1 | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 + King:8001 + Chall:8002 — all /health 200 (chall still h2-kp65)
- Kevin + pandora weights cached; h2-kp50 / h2-kp65 merges on disk
- α=0.65 result: `/root/affine_data/h2_kp65_sim_result.json` (local copy in
  `experiments/s4-h2-merge/results/`)
- No training job yet

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z (~3.1h left @ 01:43Z). Do **not**
submit until sim margin > 0.04 vs live king. Do not rent another pod until
H1 needs a dedicated train box or this TTL is too short (extend first).

## Next action (single, highest value)

**Start H1 on `mine-sim-1`:** harvest teacher_refs → short SFT from kevin →
serve chall → `run_sim_duel.py`. Follow `experiments/s4-h1-sft/plan.md`.
Check TTL/balance before long train; extend TTL deliberately if needed
(never omit `--ttl`). No submit until margin > 0.04 + H4.
