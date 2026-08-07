# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c n80 + H6 train PARALLEL on mine-h5c-1.**

0–3 done. H2/H1/H1v2/H5/H5b **REFUTED**. H5c open (mid50 FAIL). H6 open. No submit.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 reign#3 |
| teacher / eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | **8767079** · min_margin 0.02 |
| Lium / spend | $33,537.66 · ~$302 total · cap rem ~$3,700 |
| miner | τ10.000 free · 0 submissions |
| H5c mid50 n40 | margin **−0.01924** · r=0.897 · clipL1 0.015≪0.042 |
| H5c HF merged | **public DONE** `unconst/Affine-5czsc2fc98-h5c-merged` @ 0cda099e |
| H5c n80 | **RUNNING** pid 43690 · ~6/80 chall @11:25Z |
| H6 train | **RUNNING** pid 46680 · GPUs 6,7 · loading@11:25Z |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | H5c n80 + H6 train | SSH `152.236.142.234:40298` |

teacher:8000 + king:8001 + chall:8002 · n80 **43690** · H6 **46680** ·
TTL **19:37:46Z** · deadman @19:00Z · **do not tear until H6 resolves**

Validator pods — do not touch.

## Blocked

No submit until n80 margin > 0.04 (H5c mid50 −0.019; expect refute).

## Next action

**Poll both jobs.** H5c n80 first (ETA ~12:30–13:30Z), then H6 train.done.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'cat /root/affine_data/h5c_sim_progress.json; echo;
   test -f /root/affine_data/h5c_decision.json && cat $_;
   test -f /root/affine_data/h5c_sim_result.json && python3 -c \
     "import json; d=json.load(open(\"/root/affine_data/h5c_sim_result.json\")); \
      print({k:d.get(k) for k in [\"margin\",\"z\",\"S_c\",\"S_k\",\"r_c\",\"valid_c\"]})" ;
   ps -p 43690,46680 -o pid,etime,cmd; echo;
   test -f /root/h6/train/train.done && cat $_;
   tail -n 5 /root/logs/h6_train.nohup'
```

If H5c margin≤0.04 → refute H5c; **keep pod** for H6. After H6 train.done →
merge → chall swap → n80. No submit without margin>0.04.
