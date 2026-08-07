# INVENTORY — mine-* pods only

Reconcile against `lium ps` at the start of every pass.
Never touch pods whose names do not start with `mine-`.

## Live inventory

| name | huid | id | gpu | $/hr | ttl / remove_at | purpose | status | notes |
|---|---|---|---|---|---|---|---|---|
| *(none)* | — | — | — | — | — | — | — | no mine-* pods |

## Dead / removed

| name | huid | final spent | removed UTC | reason |
|---|---|---|---|---|
| mine-sim-1 | swift-shark-52 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy is CPU-only; killed deadman 1783662 then `lium rm mine-sim-1` |

## Reconcile log

| UTC | lium ps mine-* | inventory action |
|---|---|---|
| 2026-08-07T09:35:30Z | none | matches inventory; only validator `affine-eval` / `affine-bench`; no orphan mine-*; H5c harvest host-only |
| 2026-08-07T09:33:06Z | mine-sim-1 → none | verified name `mine-sim-1`/`swift-shark-52`; killed deadman 1783662; `lium rm mine-sim-1 -y`; validator pods untouched; H5c autopsy done |
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
| 2026-08-07T02:58:34Z | mine-sim-1 RUNNING | matches inventory; spent $96.48; H1 step69; fail-closed promote patched; pipe restarted **102073**; n80 budget OK (~108m slack); deadman 1405846; validator pods untouched |
| 2026-08-07T03:02:02Z | mine-sim-1 RUNNING | matches inventory; spent $97.83; H1 step73; merge_lora first_1MiB≠kevin refuse armed + harvest **1471795**; deadman 1405846; validator pods untouched |
| 2026-08-07T03:05:27Z | mine-sim-1 RUNNING | matches inventory; spent $99.00; H1 step76; armed bg merged HF push + pipe **105148** + harvest **1478941**; deadman 1405846; validator pods untouched |
| 2026-08-07T03:08:17Z | mine-sim-1 RUNNING | matches inventory; spent $100.29; H1 step79; fixed host early-teardown (train_fallback/mid/merged); harvest **1486917**; deadman 1405846; validator pods untouched |
| 2026-08-07T03:11:56Z | mine-sim-1 RUNNING | matches inventory; spent $101.74; H1 step84; triage live-king guard + sim king_rev; H6 scoring 70/80; deadman 1405846; validator pods untouched |
| 2026-08-07T03:15:18Z | mine-sim-1 RUNNING | matches inventory; spent $102.97; H1 step87; **chal-00274 H6 REJECTED** (margin+0.0229 z=2.37&lt;3); kevin still king; deadman 1405846; validator pods untouched |
| 2026-08-07T03:28:31Z | mine-sim-1 RUNNING | matches inventory; spent $108.12; H1 step101; **ckpt-100 HF salvage OK** (loss 0.207); emit numeric-ckpt fix; chal-00275 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T03:56:51Z | mine-sim-1 RUNNING | matches inventory; spent $119.34; H1 train+merge DONE; first_1MiB false-positive fixed; resume 127103 push+serve→sim; chal-00276 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T04:11:12Z | mine-sim-1 RUNNING | matches inventory; spent $125.06; CausalLM text-config+visual-shard serve bugs fixed; chall 200; n40 sim 137799; chal-00279 loading; deadman 1405846; validator pods untouched |
| 2026-08-07T04:29:15Z | mine-sim-1 RUNNING | matches inventory; spent $131.54; H1 n40 DONE margin −0.00241 revise_recipe; n80 143331; chal-00279 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T04:33:35Z | mine-sim-1 RUNNING | matches inventory; spent $133.70; n80 ~11/80; H1v2 plan drafted; chal-00280 dispatching; deadman 1405846; validator pods untouched |
| 2026-08-07T04:37:27Z | mine-sim-1 RUNNING | matches inventory; spent $135.36; n80 ~16/80; H1v2 train **147209** launched GPUs 6,7; chal-00280 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T04:41:30Z | mine-sim-1 RUNNING | matches inventory; spent $136.96; n80 dead→restarted **149213** (timeout 360×5); H1v2 step3/55 + pipe **149216**; chal-00280 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T04:45:37Z | mine-sim-1 RUNNING | matches inventory; spent $138.57; harvest restarted **1627557** w/ H1v2 gate+scrape; H1v2 step6/55; n80 ~6/5; chal-00280 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T04:48:47Z | mine-sim-1 RUNNING | matches inventory; spent $139.88; H1v2 HF repos+pipe HF salvage+mid-salvage armed; pipe **154579**; harvest **1634085**; H1v2 step10/55; n80 ~15/15; chal-00280 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T04:51:36Z | mine-sim-1 RUNNING | matches inventory; spent $140.98; **fixed H1v2 adapter path bug** + pipe **158053**; HF_TOKEN→mine.env; harvest **1640417**; H1v2 step14/55; n80 ~21/20; chal-00280 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T04:54:57Z | mine-sim-1 RUNNING | matches inventory; spent $142.11; **fixed host harvest H1v2 HF-push teardown race** + triage_sim; harvest **1644437**; H1v2 step17/55; n80 ~27/26; chal-00280 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T04:59:32Z | mine-sim-1 RUNNING | matches inventory; spent $144.05; **reordered H1v2 pipe merge∥n80** + freed h2-kp65 68G; pipe **164147**; H1v2 step23/55; n80 ~37/37; chal-00280 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T05:10:53Z | mine-sim-1 RUNNING | matches inventory; spent $148.11; **H1v2 prefer-n80 pipe+harvest**; pipe **171602**; harvest **1670883**; H1v2 step35/55; n80 ~59/59; chal-00281 dispatching; deadman 1405846; validator pods untouched |
| 2026-08-07T05:19:08Z | mine-sim-1 RUNNING | matches inventory; spent $151.76; **H1 n80 DONE margin −0.01994 recipe REFUTED**; H1v2 step43/55; pipe 171602 waiting train.done; chal-00283 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T05:37:11Z | mine-sim-1 RUNNING | matches inventory; spent $158.87; **H1v2 train.done→merge.done→HF→chall load**; pipe 171602; harvest 1670883; chal-00283 load_challenger; deadman 1405846; validator pods untouched |
| 2026-08-07T05:44:10Z | mine-sim-1 RUNNING | matches inventory; spent $161.57; **H1v2 chall READY→prefer-n80 launched** pid 198714 (1/80); push 191137; harvest 1670883; chal-00283 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T05:05:10Z | mine-sim-1 RUNNING | matches inventory; spent $146.11; **teardown got_h1v2 + H1-scoped n80 wait + h1v2 merge_meta**; pipe **167913**; harvest **1662067**; H1v2 step28/55; n80 ~49/48; chal-00280 scoring; deadman 1405846; validator pods untouched |
| 2026-08-07T05:47:50Z | mine-sim-1 RUNNING | matches inventory; spent $162.94; H1v2 n80~10/80; HF merged push quota-fixed → **202393** public; deadman 1405846; validator pods untouched |
| 2026-08-07T05:50:34Z | mine-sim-1 RUNNING | matches inventory; spent $164.13; H1v2 merged HF salvage **DONE** `a314357…`; n80~16/80; deadman 1405846; validator pods untouched |
| 2026-08-07T05:54:31Z | mine-sim-1 RUNNING | matches inventory; spent $165.68; H1v2 n80~25/80 ETA~06:15; chal-00283 REJECTED margin+0.0017; deadman 1405846; validator pods untouched |
| 2026-08-07T06:02:40Z | mine-sim-1 RUNNING | matches inventory; spent $168.86; H1v2 n80~37/80 ETA~06:25@1.8tpm; harvest artifact SCP fix **1748334**; deadman 1405846; validator pods untouched |
| 2026-08-07T06:09:00Z | mine-sim-1 RUNNING | matches inventory; spent $171.38; H1v2 n80~55/80; **extended harvest→07:45 / deadman→08:00** (pids 1757430/1757428); chal-00284 scoring; validator pods untouched |
| 2026-08-07T06:20:30Z | mine-sim-1 RUNNING | matches inventory; spent $175.84; **H1v2 n80 DONE margin −0.00030 REFUTED**; TalentPigs crowned reign3; harvest killed (keep pod); deadman 1757428; validator pods untouched |
| 2026-08-07T06:25:41Z | mine-sim-1 RUNNING | matches inventory; spent $177.94; **H5 pivot pipe 227022** download TalentPigs (~19G); deadman→12:00Z pid 1783662; validator pods untouched |
| 2026-08-07T06:33:00Z | mine-sim-1 RUNNING | matches inventory; spent $180.82; **king pivot DONE** TalentPigs:8001; H5 merge+sim pipe **231222** α0.65; deadman 1783662; validator pods untouched |
| 2026-08-07T06:43:38Z | mine-sim-1 RUNNING | matches inventory; spent $185.00; **merge DONE** + resume pipe **231961** (fixed 16-shard identity crash); chall:8002 loading h5-kt65; deadman 1783662; validator pods untouched |
| 2026-08-07T06:47:05Z | mine-sim-1 RUNNING | matches inventory; spent $185.40; **chall:8002 READY** + n80 sim **235312**; deadman 1783662; validator pods untouched |
| 2026-08-07T06:51:58Z | mine-sim-1 RUNNING | matches inventory; spent $188.27; n80 ~king12/chall16 advancing; **H5 harvest 1818104** armed; deadman 1783662; validator pods untouched |
| 2026-08-07T06:55:51Z | mine-sim-1 RUNNING | matches inventory; spent $189.79; n80 ~king19/chall24 (120s rate 1.875 k-tpm → ETA~07:28Z); harvest 1818104; deadman 1783662; validator pods untouched |
| 2026-08-07T06:59:55Z | mine-sim-1 RUNNING | matches inventory; spent $191.40; n80 ~king34/chall36 (120s rate 3.5/1.5 tpm chall-bottleneck → ETA~07:29Z); harvest 1818104; deadman 1783662; validator pods untouched |
| 2026-08-07T07:03:59Z | mine-sim-1 RUNNING | matches inventory; spent $192.92; n80 ~king48/chall51 (155s rate 3.48/3.48 tpm → ETA~07:13Z); harvest 1818104; deadman 1783662; validator pods untouched |
| 2026-08-07T07:17:35Z | mine-sim-1 RUNNING | matches inventory; spent $198.35; α0.65 n80 REJECT gates base×4.43; α0.50 pipe 240001 + harvest 1847826; deadman 1783662; validator pods untouched |
| 2026-08-07T07:34:27Z | mine-sim-1 RUNNING | matches inventory; spent ~$203; H5 α0.50 unpromptable REFUTED; H5b train 245350 + pipe 245426 + harvest 1871830; deadman 1783662; validator pods untouched |
| 2026-08-07T07:38:32Z | mine-sim-1 RUNNING | matches inventory; spent $205.56; H5b HF salvage armed (pipe 246775 mid 246776); train 245350 step4/55; deadman 1783662; validator pods untouched |
| 2026-08-07T07:43:12Z | mine-sim-1 RUNNING | matches inventory; spent $208.43; H5b mid final-adapter salvage fix (mid 247579) + harvest 1884718; freed h5-kt65; train step8/55; deadman 1783662; validator pods untouched |
| 2026-08-07T07:48:10Z | mine-sim-1 RUNNING | matches inventory; spent $210.38; H5b identity false-positive fix (pipe 249279) + freed h1/h1v2 merged ~136G; train step14/55; deadman 1783662; validator pods untouched |
| 2026-08-07T07:52:29Z | mine-sim-1 RUNNING | matches inventory; spent $212.07; H5b GPU-release-before-merge + HF serialize (pipe 251842 mid 251832); train step19/55; deadman 1783662; validator pods untouched |
| 2026-08-07T07:57:48Z | mine-sim-1 RUNNING | matches inventory; spent $214.22; H5b n80≤3 retry pipe **253801** (train 245350 mid 251832); step24/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:00:55Z | mine-sim-1 RUNNING | matches inventory; spent ~$215; H5b harvest abort+done-marker **1917667** (train 245350 pipe 253801 mid 251832); step28/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:04:21Z | mine-sim-1 RUNNING | matches inventory; spent $216.20; H5b pipe EXIT abort-trap **256662** (train 245350 mid 251832); step31/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:08:03Z | mine-sim-1 RUNNING | matches inventory; spent $217.21; H5b HF-wait-off-critical-path pipe **258082** (train 245350 mid 251832); step35/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:11:12Z | mine-sim-1 RUNNING | matches inventory; spent $219.44; H5b stage-aware harvest scrape **1935669** (train 245350 pipe 258082 mid 251832); step38/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:14:54Z | mine-sim-1 RUNNING | matches inventory; spent $219.88; H5b pre-freed chall VRAM GPUs 4,5 (train 245350 pipe 258082 mid 251832); step42/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:18:46Z | mine-sim-1 RUNNING | matches inventory; spent $222.42; H5b packed-visual merge_lora fix deployed (train 245350 pipe 258082 mid 251832); step46/55; deadman 1783662; validator pods untouched |
| 2026-08-07T08:36:04Z | mine-sim-1 RUNNING | matches inventory; spent $229.22; H5b train DONE; recovered rc=127 file-offset abort; pipe **266631** merge+visual OK chall loading; harvest **1964910**; deadman 1783662; validator pods untouched |
| 2026-08-07T08:45:33Z | mine-sim-1 RUNNING | matches inventory; spent $229.76; H5b chall READY + n80 sim **276121** advancing (king6/chall2); harvest **1964910**; deadman 1783662; validator pods untouched |
| 2026-08-07T08:49:22Z | mine-sim-1 RUNNING | matches inventory; spent $234.42; H5b n80 ~king15/chall15 ETA~09:20Z@~2.1tpm; harvest **1964910**; deadman 1783662; validator pods untouched |
| 2026-08-07T08:52:56Z | mine-sim-1 RUNNING | matches inventory; spent $234.81; H5b n80 ~king19/chall19 ETA~09:46Z@~1.14tpm (slowed); harvest **1964910**; deadman 1783662; validator pods untouched |
| 2026-08-07T08:56:35Z | mine-sim-1 RUNNING | matches inventory; spent $237.29; H5b n80 ~king29/chall29 ETA~09:14Z@~2.90tpm (recovered); harvest **1964910**; deadman **1783662**; validator pods untouched |
| 2026-08-07T09:00:18Z | mine-sim-1 RUNNING | matches inventory; spent $238.65; H5b n80 ~king33/chall33 ETA~09:35Z@~1.30tpm (dip); harvest **1964910**; deadman **1783662**; validator pods untouched |
| 2026-08-07T09:03:19Z | mine-sim-1 RUNNING | matches inventory; spent $239.86; H5b n80 ~king39/chall40 ETA~09:28Z@~1.61tpm (wall~2.67); harvest **1964910**; deadman **1783662**; validator pods untouched |
| 2026-08-07T09:07:30Z | mine-sim-1 RUNNING | matches inventory; spent $241.59; H5b n80 ~king47/chall47 ETA~09:24Z@~1.94tpm (wall~1.24); harvest **1964910**; deadman **1783662**; validator pods untouched |
| 2026-08-07T09:13:25Z | mine-sim-1 RUNNING | matches inventory; spent $243.04; H5b n80 ~king58/chall58 ETA~09:25Z@~1.79tpm (wall~1.43); harvest **1964910**; deadman **1783662**; validator pods untouched |
| 2026-08-07T09:26:27Z | mine-sim-1 RUNNING | matches inventory; spent $248.91; **H5b n80 DONE margin +0.00322 REFUTED**; harvest exited; engines 200×3 idle; deadman **1783662**; validator pods untouched |
