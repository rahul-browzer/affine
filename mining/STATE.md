# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 3 in progress** (gate scoring running on pod).

Stage 0–2 complete. Pass 7: bootstrap finished → corpus synced → serve
fixed (DeepGEMM off, CUDA_HOME=pip cu13, `gdn_prefill_backend=triton`) →
three engines healthy → `run_gate.py` force-echo rescoring chal-00224 **in
flight** (smoke OK; ~20/80 at 23:31Z). No submissions.

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
| Lium balance | ~$34,680 (floor $28,000) — check `lium balance` |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` ~$8–12 @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 3 sim pod (8×H200 $23.60/h) | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- **bootstrap.done** + **corpus.done** (9000 turns, manifest `515df523…`)
- vLLM: teacher:8000 / king=genesis:8001 / chall=kevin:8002 — all healthy
- **Gate job:** `python …/run_gate.py` (pid in `/root/logs/gate.pid`); log
  `/root/logs/gate.log`; result → `/root/affine_data/s3_gate_result.json`
- Smoke (pass 7): chall `lp_per_byte≈-0.160` n_tok=15 — engines answer force-echo

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-sim-1.known_hosts \
  -p 40301 root@69.63.236.160 \
  'tail -n 30 /root/logs/gate.log; ls -la /root/affine_data/s3_gate_result.json'
```

Serve knobs that were load-bearing on H200 (keep in `serve_three.sh`):
- `VLLM_USE_DEEP_GEMM=0` (stock vllm wheel has no deep_gemm)
- `CUDA_HOME=$site/nvidia/cu13` (no `/usr/local/cuda` on Lium image)
- `--additional-config '{"gdn_prefill_backend": "triton"}'` (FlashInfer GDN
  JIT fails: cu13 nvcc/headers incompatible)

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Soft: wait for gate result JSON. Extend TTL if scoring past 04:53Z. Do not
rent another pod. Do not train/submit until Stage 3 gate MET.

## Next action (single, highest value)

**Read `/root/affine_data/s3_gate_result.json`.** If `STAGE3_GATE=MET`
(kevin wins, margin ≥0.04 or |Δ|≤0.02 vs published +0.070 under current
knobs), write `experiments/s3-duel-sim/result.md` and advance to Stage 4
(H1/H2). If NOT_MET or engines died mid-run, diagnose from `gate.log` /
`vllm_*.log` and re-run gate only — do not submit.
