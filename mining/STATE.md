# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c final n80 RUNNING.**

Stage 0–3 done. H2/H1/H1v2/H5/H5b **REFUTED**. H5c open (mid50 FAIL; final n80 pending). No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 reign#3 |
| teacher / eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,545.78 · ~$300 total · cap rem ~$3,700 |
| miner | τ10.000 free · 0 submissions |
| H5c train | **done** 99/99 · best loss **0.4186@50** · final noisy |
| mid50 n40 | margin **−0.01924** z=−1.48 · r=0.897 · clipL1 0.015≪0.042 |
| final merge | **DONE** 11:12Z · weight≠base/king · 68G `/root/h5c/merged` |
| chall :8002 | **READY** 11:19:28Z |
| n80 | **RUNNING** pid 43690 → `/root/affine_data/h5c_sim_result.json` |
| H5c HF | adapter private OK · merged **public** push pid 43981 in-flight |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | final n80 sim | SSH `152.236.142.234:40298` |

pipe **10642** · teacher:8000 + king:8001 + chall:8002 READY · n80 pid **43690** ·
HF public push **43981** · TTL **19:37:46Z** · deadman @19:00Z

Validator pods — do not touch.

## Blocked

No submit until n80 margin > 0.04 (mid50 already −0.019; expect refute).

## Next action

**Poll n80 decision.** Harvest `h5c_sim_result.json` / `h5c_decision.json`.
If margin≤0.04 → refute H5c, tear down `mine-h5c-1`, pick next hypo ≠ kevin-thought LoRA lr2e-5.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'cat /root/affine_data/h5c_sim_progress.json 2>/dev/null; echo;
   ls /root/logs/h5c_{sim_n80,pipeline}.{done,aborted} 2>/dev/null;
   test -f /root/affine_data/h5c_decision.json && cat $_;
   test -f /root/affine_data/h5c_sim_result.json && python3 -c \
     "import json; d=json.load(open(\"/root/affine_data/h5c_sim_result.json\")); \
      print({k:d.get(k) for k in [\"margin\",\"z\",\"S_c\",\"S_k\",\"r_c\",\"valid_c\",\"valid_k\"]})" ;
   ps -p 43690,43981 -o pid,etime,cmd 2>/dev/null || true'
```

ETA n80 done ~12:30–13:30Z. Confirm HF push DONE (`h5c_merged_salvage.json`).
Do not submit without margin>0.04.
