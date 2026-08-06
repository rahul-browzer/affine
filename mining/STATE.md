# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 3 GATE MET → enter Stage 4.**

Stage 0–3 complete. Pass 8 collected `s3_gate_result.json`: live force-echo
of chal-00224 under current knobs → kevin wins margin **+0.06890** / z=6.30
(Stage-1 offline was +0.07000). Both sides valid. No submissions.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,640.74 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$17.39** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — see `experiments/s3-duel-sim/result.md` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 3/4 sim pod (8×H200 $23.60/h) | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod (keep hot — do not tear down yet):
- teacher:8000 / genesis:8001 / kevin:8002 still healthy after gate
- gate job finished; result at `/root/affine_data/s3_gate_result.json`
- HF cache has teacher + kevin + genesis; corpus `turns.jsonl` (9000)

Serve knobs (H200): `VLLM_USE_DEEP_GEMM=0`, `CUDA_HOME=$site/nvidia/cu13`,
`--additional-config '{"gdn_prefill_backend": "triton"}'`.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z — either start Stage 4 work on this pod
before then, or extend TTL deliberately (`lium` TTL extend if available) /
re-rent. Do **not** submit until sim margin > 0.04 vs **live king** (kevin).

## Next action (single, highest value)

**Start Stage 4 H2 (merge) on `mine-sim-1`:** download
`pandora-box/Affine-5eqdtdzqle-ckpt300-m4` (+ optional `hf99jack` cali) into
pod HF cache; write a linear/SLERP merge script; produce a non-identical
checkpoint; re-serve with **kevin as king:8001** and merge as chall:8002;
score paired margin on an 80-turn public-D slice. Prefer H2 over H1 first
(cheapest α/$). Gate for any submit: sim margin > 0.04, all gates, envelope
H4 (r∈[0.70,0.85], base×≤1.15). Extend TTL if merge+score will past 04:53Z.
