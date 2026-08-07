# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 in progress — H2 α=0.5 sim duel RUNNING vs kevin (sampling ~25/80).**

Stage 0–3 complete. Merge `/root/merges/h2-kp50` served as challenger;
80-turn local `run_sim_duel` in flight. No submissions.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | check `api/v1/contract` before any submit |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,586.26 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$31.62** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| Stage 4 H2 merge | **DONE** — `/root/merges/h2-kp50` + `experiments/s4-h2-merge/merge_meta.json` |
| Stage 4 H2 serve | **READY** — teacher:8000 king:8001 chall:8002 (all `/health` 200) |
| Stage 4 H2 sim | **RUNNING** — pid **68843**; log @ 00:13Z: `king 25/80`, `challenger 25/80` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H2 serve+sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- teacher:8000 / king:8001=kevin / chall:8002=`/root/merges/h2-kp50`
- Sim: `PYTHONPATH=/root/mining_src/affine_pkg python …/run_sim_duel.py --save-artifact`
  - log `/root/logs/h2_sim.nohup` · pid `/root/logs/h2_sim.pid` (=68843)
  - result target `/root/affine_data/h2_sim_result.json` (+ `_artifact.json`)
- Progress (pass 15): sampling advancing; teacher GPUs 0–1 ~100% (bottleneck:
  ~4 running / ~19 waiting); king/chall engines loaded, idle between batches
- Throughput: ~5 turns / ~2–3 min per side → sampling ETA ~00:35–00:45Z;
  force-echo after that; finish well inside TTL 04:53Z
- Poll: `ssh -p 40301 root@69.63.236.160 'tail -20 /root/logs/h2_sim.nohup; ls /root/affine_data/h2_sim_result.json'`

Serve knobs (H200): `VLLM_USE_DEEP_GEMM=0`, `CUDA_HOME=$site/nvidia/cu13`,
`--additional-config '{"gdn_prefill_backend": "triton"}'`.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z (~4.6h left @ 00:13Z). Do **not**
submit until sim margin > 0.04 vs live king (kevin). Do not rent another pod.

## Next action (single, highest value)

**When `/root/affine_data/h2_sim_result.json` exists** (or log shows JSON
summary with `margin`): scp/copy verdict into `experiments/s4-h2-merge/`,
write `result.md` per `plan.md` decision rule (>0.02 support; >0.04 + H4
toward submit; <0.02 → try α=0.65). If sim still running: poll only; do not
rent another pod. If sim died: inspect `h2_sim.nohup` + engine health before
relaunch.
