# INVENTORY — mine-* pods only

Reconcile against `lium ps` at the start of every pass.
Never touch pods whose names do not start with `mine-`.

## Live inventory

| name | huid | id | gpu | $/hr | ttl / remove_at | purpose | status | notes |
|---|---|---|---|---|---|---|---|---|
| mine-sim-1 | swift-shark-52 | 523f52ca-35f2-4ac4-ac74-97ac44a41d81 | 8×H200 | 23.60 | 2026-08-07T04:53:17Z | Stage 4 H2 serve + sim | RUNNING | SSH `root@69.63.236.160 -p 40301`; serve READY; h2_sim pid=68843; spent $25.38 @ 23:57Z |

## Reconcile log

| UTC | lium ps mine-* | inventory action |
|---|---|---|
| 2026-08-06T22:47:00Z | none | none — only `affine-eval` (8×B300 $64/h) and `affine-bench` (8×H200 $5.80/h) live; both validator-owned, left alone |
| 2026-08-06T22:49:00Z | none | none — same two validator pods; no orphans |
| 2026-08-06T22:51:06Z | none | none — same two validator pods; no orphans; Stage 2 closed this pass |
| 2026-08-06T22:53:18Z | none → mine-sim-1 | rented `lium up 1` after `lium ls --gpu H200 --count 8 --sort price_per_hour` (cheapest = $23.60/h); `--name mine-sim-1 --ttl 6h --no-ssh -y`; validator pods untouched |
| 2026-08-06T22:57:35Z | mine-sim-1 RUNNING | confirmed; spent ≈ $0.5–1; bootstrap in progress |
| 2026-08-06T23:00:03Z | mine-sim-1 RUNNING | matches inventory; spent $2.66; no orphans; validator pods untouched |
| 2026-08-06T23:32:11Z | mine-sim-1 RUNNING | matches inventory; spent $15.29; serve+gate running; validator pods untouched |
| 2026-08-06T23:37:31Z | mine-sim-1 RUNNING | matches inventory; spent $17.39; Stage3 MET; validator pods untouched |
| 2026-08-06T23:42:03Z | mine-sim-1 RUNNING | matches inventory; spent $19.17; H2 download→merge started; validator pods untouched |
| 2026-08-06T23:51:51Z | mine-sim-1 RUNNING | matches inventory; spent $22.59; H2 merge DONE + re-serve; validator pods untouched |
| 2026-08-06T23:57:49Z | mine-sim-1 RUNNING | matches inventory; spent $25.38; H2 serve READY + sim launched; validator pods untouched |
