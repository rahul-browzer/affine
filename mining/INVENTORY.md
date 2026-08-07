# INVENTORY — mine-* pods only

Reconcile against `lium ps` at the start of every pass.
Never touch pods whose names do not start with `mine-`.

## Live inventory

| name | huid | id | gpu | $/hr | ttl / remove_at | purpose | status | notes |
|---|---|---|---|---|---|---|---|---|
| mine-sim-1 | swift-shark-52 | 523f52ca-35f2-4ac4-ac74-97ac44a41d81 | 8×H200 | 23.60 | **Lium TTL cancelled**; host deadman **07:00Z**; harvest early-rm | Stage 4 H1 train + salvage→GPU-merge→n40→n80 | RUNNING | SSH `root@69.63.236.160 -p 40301`; train 82057 step65/110; ckpt-50 on HF; pipe 86845 soft 06:50Z; mid-salvage 83669; bk /root/h1/train 1h; host harvest **1459477** (early teardown + triage_sim); deadman 1405846; spent $94.80 |

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
| 2026-08-07T00:02:23Z | mine-sim-1 RUNNING | matches inventory; spent $26.35; sim alive sampling king5/chall10; validator pods untouched |
| 2026-08-07T00:07:19Z | mine-sim-1 RUNNING | matches inventory; spent $29.09; sim advancing king15/chall15; teacher bottleneck; validator pods untouched |
| 2026-08-07T00:11:01Z | mine-sim-1 RUNNING | matches inventory; spent $30.53; sim advancing king20/chall20; teacher bottleneck; validator pods untouched |
| 2026-08-07T00:13:41Z | mine-sim-1 RUNNING | matches inventory; spent $31.62; sim advancing king25/chall25; teacher bottleneck; validator pods untouched |
| 2026-08-07T00:16:53Z | mine-sim-1 RUNNING | matches inventory; spent $32.88; sim advancing king30/chall30 (confirmed via 90s recheck); validator pods untouched |
| 2026-08-07T00:20:00Z | mine-sim-1 RUNNING | matches inventory; spent $34.10; sim advancing king35/chall35 (confirmed via 120s recheck); validator pods untouched |
| 2026-08-07T00:23:39Z | mine-sim-1 RUNNING | matches inventory; spent $35.53; sim advancing king40/chall40 (confirmed via 150s recheck); validator pods untouched |
| 2026-08-07T00:29:56Z | mine-sim-1 RUNNING | matches inventory; spent $38.01; sim advancing king50/chall50 (confirmed via 240s recheck); validator pods untouched |
| 2026-08-07T00:34:36Z | mine-sim-1 RUNNING | matches inventory; spent $39.84; sim advancing king65/chall65 (confirmed via 180s recheck); validator pods untouched |
| 2026-08-07T00:44:01Z | mine-sim-1 RUNNING | matches inventory; spent $43.56; α=0.5 sim DONE margin −0.010; α=0.65 merge launched; validator pods untouched |
| 2026-08-07T00:50:33Z | mine-sim-1 RUNNING | matches inventory; spent $45.83; α=0.65 merge DONE + re-serve→sim pipeline 71925; validator pods untouched |
| 2026-08-07T00:56:15Z | mine-sim-1 RUNNING | matches inventory; spent $48.04; α=0.65 serve READY + sim pid 77251 sampling; validator pods untouched |
| 2026-08-07T01:00:35Z | mine-sim-1 RUNNING | matches inventory; spent $50.07; α=0.65 sim at king/chall 5/80 (120s recheck); validator pods untouched |
| 2026-08-07T01:43:16Z | mine-sim-1 RUNNING | matches inventory; spent $66.86; α=0.65 sim DONE margin +0.007; H2 refuted; engines kept; validator pods untouched |
| 2026-08-07T01:54:36Z | mine-sim-1 RUNNING | matches inventory; spent $71.31; H1 harvest 440 + LoRA train pid 82057 on GPUs 6,7; engines 200×3; validator pods untouched |
| 2026-08-07T01:56:34Z | mine-sim-1 RUNNING | matches inventory; spent $72.08; H1 train step 3/110; post-train pipeline pid 83194 armed; validator pods untouched |
| 2026-08-07T01:58:18Z | mine-sim-1 RUNNING | matches inventory; spent $72.77; H1 train step 5/110; pipeline restarted 83414 with HF adapter salvage; validator pods untouched |
| 2026-08-07T02:01:34Z | mine-sim-1 RUNNING | matches inventory; spent $74.05; H1 step8; HF repo pre-created; mid-ckpt salvage 83669 + host harvest 1375476; validator pods untouched |
| 2026-08-07T02:04:17Z | mine-sim-1 RUNNING | matches inventory; spent $75.13; H1 step10; pipeline 84156 GPU-merge patch; validator pods untouched |
| 2026-08-07T02:09:20Z | mine-sim-1 RUNNING | matches inventory; spent $77.11; H1 step16; pipeline 84834 chall-only+progress; freed h2-kp50+genesis; validator pods untouched |
| 2026-08-07T02:12:52Z | mine-sim-1 RUNNING | matches inventory; spent $78.50; H1 step20; pipeline 85424 n40→n80; lium bk /root/h1/train; validator pods untouched |
| 2026-08-07T02:18:50Z | mine-sim-1 RUNNING | matches inventory; spent $80.83; **cancelled Lium schedule 04:53Z** (index 1=swift-shark-52); host deadman 07:00Z; pipe 86845 soft 06:50Z; train step26; validator pods untouched |
| 2026-08-07T02:21:57Z | mine-sim-1 RUNNING | matches inventory; spent $82.07; H1 step30; HF write probe OK; host harvest→train_progress JSON; validator pods untouched |
| 2026-08-07T02:26:01Z | mine-sim-1 RUNNING | matches inventory; spent $83.67; H1 step34; host harvest **1421187** scrapes trainer_state loss; deadman 1405846; validator pods untouched |
| 2026-08-07T02:43:18Z | mine-sim-1 RUNNING | matches inventory; spent $90.47; H1 step53; ckpt-50 loss+HF salvage OK (fixed base_model README); validator pods untouched |
| 2026-08-07T02:49:48Z | mine-sim-1 RUNNING | matches inventory; spent $92.72; H1 step59 epoch1 loss0.251; harvest→emit_train_progress; deadman 1405846; validator pods untouched |
| 2026-08-07T02:51:41Z | mine-sim-1 RUNNING | matches inventory; spent $93.77; H1 step62; harvest **1454856** early-teardown armed; deadman 1405846; validator pods untouched |
| 2026-08-07T02:54:19Z | mine-sim-1 RUNNING | matches inventory; spent $94.80; H1 step65; triage_sim wired into harvest **1459477**; pipe soft 06:50Z verified; deadman 1405846; validator pods untouched |
