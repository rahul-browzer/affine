# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H2 α=0.5 REFUTED for submit; α=0.65 merge RUNNING.**

Stage 0–3 complete. α=0.5 kevin×pandora sim finished: margin **−0.00996**
(both valid, H4 OK). Second recipe α=0.65 merging on pod. No submissions.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 (pandora-m4 still earning as reign 1) |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 (contract + affine.toml) |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,539.54 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$43.18** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| H2 α=0.5 sim | **DONE** — margin −0.00996; see `experiments/s4-h2-merge/result.md` |
| H2 α=0.65 merge | **RUNNING** — pid **71425** / py **71431**; out `/root/merges/h2-kp65` |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H2 α=0.65 merge | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Engines still up (teacher:8000 king:8001 chall:8002=h2-kp50) but idle after sim
- α=0.65 merge: log `/root/logs/h2_kp65_merge.log` · pid `/root/logs/h2_kp65_merge.pid`
  - done marker `/root/logs/h2_kp65_merge.done`
  - out `/root/merges/h2-kp65` (+ `merge_meta.json` when finished)
- Prior α=0.5 result on pod: `/root/affine_data/h2_sim_result.json` (copied to
  `experiments/s4-h2-merge/results/`)
- Merge ETA ~5–6 min (α=0.5 took ~319s); then re-serve + 80-turn sim (~40 min)

Poll merge:
`ssh -p 40301 root@69.63.236.160 'tail -20 /root/logs/h2_kp65_merge.log; ls /root/logs/h2_kp65_merge.done /root/merges/h2-kp65/merge_meta.json'`

After merge DONE:
```
MERGE=/root/merges/h2-kp65 bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
# then sim with --chall-repo /root/merges/h2-kp65 → /root/affine_data/h2_kp65_sim_result.json
```

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z (~4.1h left @ 00:43Z). Do **not**
submit until sim margin > 0.04 vs live king. Do not rent another pod.

## Next action (single, highest value)

**When `/root/logs/h2_kp65_merge.done` exists:** re-serve chall=`/root/merges/h2-kp65`
(king=kevin, keep teacher), launch 80-turn `run_sim_duel` with
`--chall-repo /root/merges/h2-kp65` and out `/root/affine_data/h2_kp65_sim_result.json`.
Decision rule: margin >0.02 support; >0.04+H4 toward submit; <0.02 → **refute H2**
for kevin×pandora and pivot to H1 teacher-ref SFT. If merge still running: poll only.
