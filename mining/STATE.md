# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 in progress — H2 merge complete; king/chall re-serve loading.**

Stage 0–3 complete. Pass 10 fixed HF cache-path bug, finished α=0.5
kevin×pandora merge (non-identical), relaunched serve with local merge as
challenger. No submissions.

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
| Lium balance | $34,617.36 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$22.59** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| Stage 4 H2 merge | **DONE** — `/root/merges/h2-kp50` + `experiments/s4-h2-merge/merge_meta.json` |
| Stage 4 H2 serve | **LOADING** — restart pid in `/root/logs/h2_restart.pid` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H2 serve+sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- teacher:8000 kept; king:8001=kevin; chall:8002=`/root/merges/h2-kp50` (no `--revision`)
- Wait marker: restart log `/root/logs/h2_restart.nohup` ends with `READY` when
  `wait_ready.sh` finishes (king+chall `/health` 200)
- Merge meta: n_merged=1026, n_copied_A=19 (MTP), max_abs_delta≈5.5e-4,
  first_1MiB_identical=false, elapsed≈319s
- Scripts: `/root/mining_src/s4-h2-merge/`, serve fix in
  `/root/mining_src/s3-duel-sim/serve_three.sh` (skip `--revision` for local dirs)

Serve knobs (H200): `VLLM_USE_DEEP_GEMM=0`, `CUDA_HOME=$site/nvidia/cu13`,
`--additional-config '{"gdn_prefill_backend": "triton"}'`.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z — enough for load+80-turn sim.
Do **not** submit until sim margin > 0.04 vs live king (kevin).

## Next action (single, highest value)

**When `/root/logs/h2_restart.nohup` shows READY** (or king+chall health 200):
`PYTHONPATH=/root/mining_src/affine_pkg python /root/mining_src/s4-h2-merge/run_sim_duel.py`
(nohup → `/root/logs/h2_sim.nohup`). Collect margin vs kevin into
`experiments/s4-h2-merge/`. Decision rule in `plan.md` (need >0.02; submit
gate >0.04 + H4). If serve still loading: poll only; do not rent another pod.
If chall fails to load local merge, check `vllm_chall.log` before retrying.
