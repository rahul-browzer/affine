# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 3 in progress** (gate not yet met).

Stage 0–2 complete. Pass 5 rented `mine-sim-1` and started pod bootstrap
(vLLM pin + HF downloads). No serve/score yet. No submissions.

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
| mining spend to date | accruing on `mine-sim-1` @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 3 sim pod (8×H200 $23.60/h) | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

Bootstrap (single process): `bash /root/bootstrap.sh` under nohup.
- **Done:** uv venv; `torch==2.11.0` / `transformers==5.14.1` / `vllm==0.22.1` verified.
- **In flight (2026-08-06T22:57Z):** HF download of teacher `zai-org/GLM-4.5-Air-FP8` (~51% of 55 files; `/root/hf` ≈ 60G). Then kevin + genesis.
- **Done marker:** `/root/logs/bootstrap.done`
- **Log:** `tail -f /root/logs/bootstrap.log`

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-sim-1.known_hosts \
  -p 40301 root@69.63.236.160 'tail -n 40 /root/logs/bootstrap.log; ls /root/logs/bootstrap.done'
```

Plan: `experiments/s3-duel-sim/plan.md`. Bootstrap script: `experiments/s3-duel-sim/bootstrap.sh`.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: wait for downloads before serve (~teacher alone is large).

## Next action (single, highest value)

**When `/root/logs/bootstrap.done` exists:** upload scoring harness + affine source
tar to the pod, launch three `vllm serve` slots (teacher 0,1 / king 2,3 /
challenger=genesis 4,5; TP=2, max-model-len 32768, util 0.80), run Stage 3
gate sim against chal-00224 shape. If bootstrap still running, only monitor —
do not rent another pod. Extend TTL deliberately if downloads/serve will past
04:53Z. Do **not** train or submit.
