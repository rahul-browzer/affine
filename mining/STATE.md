# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 in progress — H2 merge pipeline running on `mine-sim-1`.**

Stage 0–3 complete. Pass 9 started H2: kevin × pandora-m4 linear merge
(α=0.5). Download→merge under nohup. No submissions.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,632.93 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$19.17** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| Stage 4 H2 | **RUNNING** — `experiments/s4-h2-merge/` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H2 merge + sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- teacher:8000 / genesis:8001 / kevin:8002 still healthy (Stage-3 layout)
- H2 pipeline PID in `/root/logs/h2_pipeline.pid` (nohup →
  `/root/logs/h2_pipeline.nohup` / `h2_pipeline.log`)
- Wait for `/root/logs/h2_merge.done` then merge at `/root/merges/h2-kp50/`
- Scripts: `/root/mining_src/s4-h2-merge/`

Serve knobs (H200): `VLLM_USE_DEEP_GEMM=0`, `CUDA_HOME=$site/nvidia/cu13`,
`--additional-config '{"gdn_prefill_backend": "triton"}'`.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z — enough for download+merge+score if
pipeline stays healthy. Extend TTL only if merge/score will overrun.
Do **not** submit until sim margin > 0.04 vs live king (kevin).

## Next action (single, highest value)

**When `/root/logs/h2_merge.done` exists:** verify
`/root/merges/h2-kp50/merge_meta.json` (non-identical), run
`bash /root/mining_src/s4-h2-merge/restart_for_h2.sh` (king=kevin,
chall=merge; keep teacher), then
`PYTHONPATH=/root/mining_src/affine_pkg python /root/mining_src/s4-h2-merge/run_sim_duel.py`
and collect margin vs kevin. Decision rule in
`experiments/s4-h2-merge/plan.md` (need >0.02; submit gate >0.04 + H4).
If download still running: poll log only; do not rent another pod.
