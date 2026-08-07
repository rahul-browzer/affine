# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H2 α=0.5 REFUTED for submit; α=0.65 merge DONE; re-serve+sim RUNNING.**

Stage 0–3 complete. α=0.5 kevin×pandora sim: margin **−0.00996** (both
valid, H4 OK). α=0.65 merge finished (non-identical); pipeline re-serving
chall=`/root/merges/h2-kp65` then auto-launches 80-turn sim. No submissions.

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
| Lium balance | $34,531.75 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | `mine-sim-1` spent **$45.83** @ $23.60/h (TTL cap ≈ $141.60) |
| our submissions | none |
| Stage 3 gate | **MET** — `experiments/s3-duel-sim/result.md` |
| H2 α=0.5 sim | **DONE** — margin −0.00996; see `experiments/s4-h2-merge/result.md` |
| H2 α=0.65 merge | **DONE** @ 00:48:53Z — 1026 keys, first_1MiB ≠ kevin; meta in `results/h2_kp65_merge_meta.json` |
| H2 α=0.65 pipeline | **RUNNING** — pid **71925**; re-serve then sim |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-sim-1` | `swift-shark-52` | Stage 4 H2 α=0.65 re-serve→sim | SSH `root@69.63.236.160 -p 40301`; TTL remove at **2026-08-07T04:53:17Z** |

On pod:
- Teacher:8000 kept hot (pid 51354)
- King:8001 + chall:8002 relaunched @ 00:49:47Z (loading; wait_ready in progress)
- Pipeline: `/root/logs/h2_kp65_pipeline.sh` pid **71925**
  - log `/root/logs/h2_kp65_pipeline.nohup`
  - after READY → `run_sim_duel.py --chall-repo /root/merges/h2-kp65`
  - sim log `/root/logs/h2_kp65_sim.nohup`
  - result `/root/affine_data/h2_kp65_sim_result.json`
  - done marker `/root/logs/h2_kp65_sim.done`
- Merge out `/root/merges/h2-kp65` (+ `merge_meta.json`)
- Prior α=0.5 result: `/root/affine_data/h2_sim_result.json` (local copy in `experiments/s4-h2-merge/results/`)

Poll:
```
ssh -p 40301 root@69.63.236.160 '
  tail -20 /root/logs/h2_kp65_pipeline.nohup;
  ls /root/logs/h2_kp65_sim.done /root/affine_data/h2_kp65_sim_result.json 2>&1;
  curl -s -o /dev/null -w "t:%{http_code} k:%{http_code} c:%{http_code}\n" \
    http://127.0.0.1:8000/health http://127.0.0.1:8001/health http://127.0.0.1:8002/health;
  tail -5 /root/logs/h2_kp65_sim.nohup 2>/dev/null
'
```

Serve ETA ~5–6 min from 00:49Z → READY ~00:55Z; sim ~40 min → result ~01:35Z.
TTL 04:53Z — plenty of room.

Validator pods `affine-eval` / `affine-bench` — do not touch.

## Blocked

Nothing hard. Soft: TTL ends 04:53Z (~4.0h left @ 00:50Z). Do **not**
submit until sim margin > 0.04 vs live king. Do not rent another pod.

## Next action (single, highest value)

**When `/root/affine_data/h2_kp65_sim_result.json` exists:** SCP to
`experiments/s4-h2-merge/results/`, apply plan.md decision rule:
- margin >0.04 + H4 → toward submit (Stage 5 checklist)
- 0.02–0.04 → note support but no submit; consider H1
- <0.02 → **refute H2** for kevin×pandora; pivot to H1 teacher-ref SFT

If serve still loading or sim sampling: poll only (do not relaunch).
