# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H5c train RUNNING on `mine-h5c-1`.**

Stage 0–3 complete. H2 / H1 / H1v2 / H5 merge / H5b **REFUTED**.
H5c autopsy + expand-refs harvest DONE. Primary DATA = **791** shortz refs.
No submit.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4` |
| king S | 0.031501971059510636 |
| reign # | **3** |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | **8767079** |
| weight_version_key | 1 |
| min_margin | 0.02 (duel) |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $33,700.59 (floor $28,000) |
| miner coldkey free | τ10.000 (unchanged) |
| mining spend to date | prior ~$252 + `mine-h5c-1` **$4.57** @ $28/h |
| our submissions | none |
| Stage 3 gate | **MET** |
| H2 / H1 / H1v2 / H5 merge / H5b | **all REFUTED** |
| H5c | **open** — train pid **2820** on GPUs 6,7; 99 steps; thought-ok 791/791 |
| H1v2 HF merged | public `unconst/Affine-5czsc2fc98-h1v2-merged` @ `a314357…` (do not submit) |
| H5b HF | private `…-h5b-lora` / `…-h5b-merged` @ `e1d39a1…` (salvage only; do not submit) |

## What's running

| name | huid | role | check |
|---|---|---|---|
| `mine-h5c-1` | `golden-hawk-dc` | H5c thought LoRA 791 shortz (kevin-init) + bg TalentPigs/teacher dl | SSH `152.236.142.234:40298`; train pid **2820**; TTL remove **2026-08-07T19:37:46Z** |

Validator pods `affine-eval` / `affine-bench` — do not touch.

Note: `current_eval` chal-00301 was kevin954 re-challenge (`load_challenger`).
Re-check snapshot before merge/sim/submit (king may change).

## Blocked

Nothing hard. **Do not submit** any H1/H1v2/H2/h5/h5b checkpoint.
Cap remaining ~$3,748 − mine-h5c-1 spend. Do not repeat mild TalentPigs-init
440-ref LoRA.

Pass 103 fixed bootstrap: `mine.env` was sourced without export → Python
`KeyError: HF_TOKEN` after pip. Scripts now `set -a; source; set +a`.

## Next action (single, highest value)

**Poll H5c train until `train.done` / step progress**, then merge → serve → n80.

```bash
ssh -i ~/.ssh/id_ed25519 -o UserKnownHostsFile=/tmp/mine-h5c-1.known_hosts \
  -o StrictHostKeyChecking=accept-new -p 40298 root@152.236.142.234 \
  'tail -20 /root/logs/h5c_train.nohup; ls /root/logs/{h5c_train.done,train.done} /root/h5c/train/train.done 2>/dev/null; \
   ls /root/h5c/train/checkpoints 2>/dev/null; \
   test -f /root/logs/h5c_train.pid && ps -p $(cat /root/logs/h5c_train.pid) -o pid,etime,cmd; \
   nvidia-smi --query-gpu=index,memory.used,utilization.gpu --format=csv,noheader; \
   ls /root/logs/h5c_extra_dl.done 2>/dev/null; tail -5 /root/logs/h5c_extra_dl.nohup 2>/dev/null'
```

When train completes: merge with `/root/mining_src/s4-h1-sft/merge_lora.py`,
serve teacher+TalentPigs+chall, n80 vs live king. Gate: margin **> 0.04**,
r∈[0.70,0.85], clip-L1≥0.042. Extend TTL before **19:37Z** if sim still running.
