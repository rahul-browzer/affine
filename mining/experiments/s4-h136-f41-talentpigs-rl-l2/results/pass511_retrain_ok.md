# pass 511 — F41 teacher recover → retrain mean_r≠0

**UTC:** 2026-08-09T09:07–09:20Z · pod `mine-f41-1` / cosmic-fox-2d

## What happened
- p510 left teacher relaunch (recover332 unique TCACHE) + retrain waiter armed after zero-reward train kill.
- Teacher load: cuda_utils ENOENT forced AOT recompile once; then CUDA-graph capture → `:8000=200` @09:14:17Z.
- Completions smoke OK (`"text"` present).
- `start_h136.sh` relaunched TalentPigs×teacher-Λ2 REINFORCE on GPUs 6,7 (pid 21616).

## Early rewards (gate)
| step | mean_r | notes |
|---|---|---|
| 1 | **+0.02028** | both rewards >0 |
| 2 | **+0.01517** | |
| 3 | **+0.00230** | |
| 5 | **+0.01043** | one of two rewards 0; mean≠0 |

No `teacher score fail` in the new train log. Teacher still 200 after step 5.

## Decision
Retrain **healthy** — not a 3rd-fail tear. Continue to train.done → merge → n80.
Detail pointer: `/root/logs/h136_relaunch_train_p510.nohup`, `/root/logs/h136_train.nohup` (fresh after 09:14).
