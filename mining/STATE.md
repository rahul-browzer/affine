# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 3 in progress** (gate not yet met).

Stage 0–2 complete. Pass 5 rented `mine-sim-1` + started bootstrap.
Pass 6 uploaded scoring harness + `serve_three.sh` / `wait_ready.sh` to the
pod while HF downloads continue. No serve/score yet. No submissions.

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
| Lium balance | $34,703.01 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent ≈ $2.66 @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 3 sim pod (8×H200 $23.60/h) | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

Bootstrap (single process `bash /root/bootstrap.sh`, pid 1984):
- **Done:** uv venv; torch/transformers/vllm pins; teacher `GLM-4.5-Air-FP8` (~106G).
- **In flight (2026-08-06T23:00Z):** kevin @ `6a5815…` (~46G and climbing; python child pid 2388). Then genesis.
- **Done marker:** `/root/logs/bootstrap.done`
- **Log:** `tail -f /root/logs/bootstrap.log`

Harness **already on pod** (pass 6):
- `PYTHONPATH=/root/mining_src/affine_pkg` → `affine.score` + `evalsrv.*`
- `/root/mining_src/affine_pkg/affine.toml`
- `/root/mining_src/s3-duel-sim/{serve_three,wait_ready,bootstrap}.sh`
- `/root/affine_data/chal-00224.json.gz`

Serve defaults (chal-00224 shape): teacher:8000/gpus0,1 · king=genesis:8001/2,3 ·
chall=kevin:8002/4,5 · TP=2 · max-model-len 32768 · util 0.80 · FLASH_ATTN +
moe-backend triton.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-sim-1.known_hosts \
  -p 40301 root@69.63.236.160 \
  'tail -n 20 /root/logs/bootstrap.log; ls /root/logs/bootstrap.done'
```

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Soft: wait for `/root/logs/bootstrap.done` before `serve_three.sh`. Do not rent
another pod. Extend TTL deliberately if serve+gate will past 04:53Z.

## Next action (single, highest value)

**When `/root/logs/bootstrap.done` exists:** on the pod run
`bash /root/mining_src/s3-duel-sim/serve_three.sh`, then
`bash /root/mining_src/s3-duel-sim/wait_ready.sh`, then run Stage 3 gate
scoring against chal-00224 shape (kevin challenger vs genesis king). If
bootstrap still running, only monitor — do not re-upload unless harness
changed. Do **not** train or submit.
