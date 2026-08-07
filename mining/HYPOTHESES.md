# HYPOTHESES — falsifiable claims

Ranked by expected α per dollar after Stage 2 public-duel mining
(`experiments/s2-public-duel-mine/`, 2026-08-06). Keep refuted entries.

## Ranked (Stage 2 gate)

| rank | id | expected α/$ | predicted effect on S / margin | status |
|---|---|---|---|---|
| 1 | H5c | highest now | kevin-init thought LoRA on **expanded** teacher_refs → clip-L1≥0.042, r∈[0.70,0.85], margin **> 0.04** vs TalentPigs | **open** — train **2820** step8/99; pipe **5222** + prewarm **5206**; host harvest **2090851** + deadman **2090852**@19:00Z; DATA=791 shortz |
| — | H5b | was highest | TalentPigs-init thought-only LoRA (lr=1e-5) → margin **> 0.04** | **refuted** — n80 margin **+0.00322** z=0.55; H4 r=0.670 |
| — | H5 merge | was highest | kevin×TalentPigs α∈{0.65,0.50} → margin **> 0.04** | **refuted** — α0.65 base×4.43; α0.50 unpromptable |
| 2 | H1v2 | was highest | thought-only SFT → r∈[0.70,0.85] + margin **> 0.04** | **refuted** — n80 margin **−0.00030**; r=0.904 H4 fail; clip-L1 +0.015 OK |
| 3 | H1 | was highest | full (z,y) SFT margin **> 0.04** | **refuted** (this recipe) — n40 −0.0024; n80 **−0.01994** z=−2.42; H4 fail both |
| 4 | H2 | very high (almost free compute) | merge margin vs kevin **> 0.02** first try; target **> 0.04** | **refuted** (α0.5 −0.010; α0.65 +0.007) |
| 5 | H4 | high (constraint, not a train) | keep r∈[0.70,0.85], base×≤1.15 or gates kill S | open (design rule; H1/H1v2/H5b breached) |
| 6 | H3 | instrumental lever | once Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S (cap +0.1) | **supported** |

---

## H1 — teacher-ref SFT beats the king (prior art)

- **Claim:** SFT / distill on published `teacher_refs` (z_C, y_C) from duel
  records, starting from `kevin954/Affine-5dfqbbh8ev-sft` (or pandora-m4 /
  hf99jack-cali), raises S enough to clear sim margin > 0.04 vs current king.
- **Evidence (Stage 2):** all three current-knob winners are distill/SFT-shaped
  (r 0.716 / 0.763 / 0.755; clip-L1 +0.031 / +0.026 / +0.026; base× ≈ 1.06–1.08).
  Crown margins vs genesis +0.070 / +0.061 / +0.041.
- **Experiment:** Stage 4 local duel sim after Stage 3 gate; train on pod
  `mine-sim-1` (GPUs 6,7) using teacher_refs harvested from public gz
  (`experiments/s4-h1-sft/`).
- **Prediction (pre-register before train):** challenger mean paired margin ≥
  **+0.04** vs live king on an 80-turn public-D slice, all gates passing,
  r∈[0.70,0.85], base×≤1.15.
- **n40 result (2026-08-07T04:27:07Z):** margin **−0.00241** (z=−0.18,
  SE=0.0132); chall S=−0.0355 vs king S=−0.0326; both valid; **H4 FAIL**
  (r=**1.135**∉[0.70,0.85], base×=0.817). Chall mean_Λ2 slightly better
  than king (−0.0345 vs −0.0380) but implied clip-L1 collapsed
  (−0.0009 vs king +0.0054).
- **n80 result (2026-08-07T05:18:46Z):** margin **−0.01994** (z=−2.42,
  SE=0.00822); chall S=−0.00687 vs king S=0.01281; both valid; **H4 FAIL**
  (r=**0.992**∉[0.70,0.85], base×=0.848). Chall worse on Λ2 (−0.0129 vs
  −0.0065) and clip-L1 (+0.006 vs king +0.019). n80 **worse** than n40 by
  ~0.0175 — confirms miss, not noise. Triage `revise_recipe`; submit=false.
  Artifacts: `experiments/s4-h1-sft/result.md`, `results/h1_sim_result.json`,
  `results/h1_decision.json`, `results/h1_n80_confirmed.json`. HF merged @
  `3364892…` salvage only. kevin still king (chal-00283 load_challenger).
- **Verdict:** **refuted** for this full-completion LoRA recipe (prediction
  ≥+0.04 missed on n40 and n80). Successor: **H1v2** thought-only distill.

## H1v2 — thought-only teacher distill restores envelope

- **Claim:** Masking SFT loss to teacher **z_C** tokens only (stop before the
  bash fence), with milder lr=2e-5 / 1 epoch from kevin init, keeps Λ2 gains
  while restoring r∈[0.70,0.85] and positive clip-L1 → sim margin > 0.04.
- **Evidence:** H1 n40 improved Λ2 vs kevin but drove r to 1.135 and clip-L1
  negative — consistent with over-fitting `y_C` under `z_C` and breaking the
  king's empty→conditioned calibration (H3/H4).
- **Experiment:** `experiments/s4-h1v2-sft/` on `mine-sim-1` after H1 n80
  finishes (reuse engines). Same 440 teacher_refs; `--loss-on thought`.
- **Prediction (pre-register BEFORE train):** n80 sim margin ≥ **+0.04**;
  H4 OK; chall implied mean clip-L1 ≥ **+0.015**.
- **Launch (2026-08-07T04:36:23Z):** train pid **147209** on `mine-sim-1`
  GPUs 6,7 (parallel with H1 n80 on engines 0–5). Fence verify **440/440**.
  Args: `--loss-on thought --lr 2e-5 --epochs 1` from kevin `6a5815…`.
  Log `/root/logs/h1v2_train.nohup`; out `/root/h1v2/train`. Code under
  `experiments/s4-h1v2-sft/`.
- **Post-train (2026-08-07T04:39:52Z):** `post_train_pipeline.sh` pid
  **149216** armed — waits `train.done` → merge_lora (H1 CausalLM+visual
  fixes) → chall-only serve → n40 → `h1v2_sim_result_n40.json`. Waits for
  H1 n80 before chall restart (or kills sim if <45m to soft 06:50Z).
- **Progress (04:41Z):** train step **3**/55 @ ~59s/it → ETA ~05:32Z.
- **Progress (04:45Z):** train step **6**/55; first loss **0.493**; ETA ~05:35Z.
  Host harvest patched (pass 53) so H1 n80 completion cannot early-teardown
  while H1v2 runs; progress scraped to `experiments/s4-h1v2-sft/results/`.
- **HF salvage (04:48Z pass 54):** private repos pre-created
  `unconst/Affine-5czsc2fc98-h1v2-lora` + `…-h1v2-merged`. Pipe restarted
  **154579** with post-merge background adapter+merged push; mid-ckpt
  watcher **154590** armed (save_steps=50). Loss step10 **0.438**.
  Evidence: `results/h1v2_hf_repos.json`, `h1v2_hf_salvage_armed.json`,
  `h1v2_time_budget.json`.
- **Adapter path fix (04:51Z pass 55):** pipe defaulted ADAPTER to
  `$TRAIN_DIR` and mid-ckpts to `$TRAIN_DIR/checkpoint-*`, but
  `train_lora.py` writes `$TRAIN_DIR/adapter` and
  `$TRAIN_DIR/checkpoints/checkpoint-*`. Would have aborted on
  train.done with no merge/HF/n40. Fixed; pipe restarted **158053**;
  HF_TOKEN appended to pod `mine.env`. Evidence:
  `results/h1v2_adapter_path_fix.json`. Train **147209** untouched
  (step14/55).
- **Harvest push-teardown fix (04:54Z pass 56):** host
  `host_harvest_results.sh` early-teardown only waited on
  `h1_push_merged.pid`. After H1v2 `pipeline.done` + H1 n80 harvest it
  could `lium rm` while `h1v2_push_merged` (~68G) still uploaded —
  defeating pass-54 HF salvage. Fixed: `_h1v2_still_running` + push
  grace cover H1v2 push PIDs; H1v2 n40 → `triage_sim.py` →
  `h1v2_decision.json` (live-king guard). Harvest restarted
  **1644437**. Evidence:
  `results/h1v2_harvest_push_teardown_fix.json`. Train step17/55.
- **Teardown/n80-wait/meta (05:05Z pass 58):** host early-teardown now
  accepts `got_h1v2` without H1 n80 (avoids deadman burn if pipe kills n80);
  pipe wait/pkill scoped to `h1_sim_result`; `merge_lora` stages
  `h1v2_merge_meta.json` under `/h1v2/`. Pipe **167913**; harvest **1662067**.
  Loss step25 **0.381**. Evidence: `results/h1v2_teardown_n80_wait_fix.json`.
- **Pipe merge∥n80 (04:59Z pass 57):** pipe waited for H1 n80 before
  merge+HF push even though merge only uses GPUs 6,7 and a separate
  out dir. Reordered: merge → HF push → wait n80 → serve → n40.
  Pipe restarted **164147**. Freed refuted `h2-kp65` 68G. Evidence:
  `results/h1v2_pipe_merge_before_n80_wait.json`. Train step23/55.
- **Prefer n80 (05:10Z pass 59):** pipe only ran n40 then done — plan.md
  submit gate/prediction is n80, and soft 06:50Z cannot fit n40+n80 after
  serve. Fixed: prefer n80 when soft/deadman ≥3200s (skip n40); else n40
  with promote→n80 if margin≥0.01+H4. Harvest SCP/triage
  `h1v2_sim_result.json`; got_h1v2 no longer on n40 alone. Pipe **171602**;
  harvest **1670883**. Loss step35 **0.410**. Evidence:
  `results/h1v2_prefer_n80_fix.json`.
- **Progress (05:19Z pass 60):** H1 n80 DONE (refuted); engines 0–5 idle
  until H1v2 chall restart. Train **147209** step **43**/55 loss **0.400**;
  pipe **171602** still waiting on train.done; ETA train ~05:30Z. Mid-ckpt
  still empty (save_steps=50). Prediction unchanged.
- **Train+merge (05:37Z pass 61):** `train.done` **05:28:51Z** (55/55;
  thought_ok=440; elapsed 3139s; sample0 supervised 29/6080). Mid-ckpt-50
  + ckpt-55 salvaged to `…-h1v2-lora`. Merge **05:35:39Z**
  `weight_identical: false` (shard tails ≠; first_1MiB match = expected LoRA
  FP). Final adapter HF push OK (`6c964d35…`); merged push **191137** in
  flight. Pipe skipped H1-n80 wait (already done) → chall-only re-serve
  loading `:8002`. Evidence:
  `results/h1v2_train_merge_transition.json`, `train_result.json`,
  `h1v2_merge_meta.json`. Prediction unchanged — awaits n80.
- **n80 launch (05:44Z pass 62):** chall :8002 READY **05:41:16Z**
  (serve ~332s). Pipe budget remain_soft=4124s → **prefer n80, skip n40**.
  Sim pid **198714** → `h1v2_sim_result.json`; first progress king1/chall1
  @ 05:44:00Z. Merged HF push **191137** still uploading. Evidence:
  `results/h1v2_n80_launched.json`, `h1v2_sim_progress.json`.
- **HF quota fix (05:47Z pass 63):** merged push **191137** died —
  private storage limit (h1-merged ~72 GiB private). Publicized
  `…-h1-merged` + `…-h1v2-merged`; relaunched public push pid **202393**
  (venv python). Adapter salvage already OK. n80 ~10/80. Evidence:
  `results/h1v2_hf_quota_fix.json`.
- **Merged salvage DONE (05:50Z pass 64):** push **202393** finished
  05:49:40Z → `unconst/Affine-5czsc2fc98-h1v2-merged` @
  `a31435754de2974e63779f53e953ee1433eaf295` (public, 67 GiB, 3 shards).
  Verified on HF (14 files incl. both model shards + visual-extra). Also
  publicized `…-h1-lora` + `…-h1v2-lora` (private-quota hygiene). n80
  ~16/80 @ 05:50, ETA ~06:30 < soft 06:50. Evidence:
  `results/h1v2_merged_salvage.json`,
  `h1v2_merged_salvage_confirmed.json`,
  `h1v2_merged_salvage_verified.json`.
- **ETA poll (05:54Z pass 65):** 90s rate 20→25/24 @ ~2.65 t/min → ETA
  **~06:15Z** (35m slack to soft). **chal-00283 REJECTED** margin +0.0017
  z=0.18 — kevin still king. Evidence: `h1v2_n80_eta_poll.json`,
  `chal_00283_verdict.json`.
- **Artifact harvest + ETA (06:02Z pass 66):** rate slowed to ~1.8 t/min
  (31→35/36 in 150s) → ETA **~06:25Z** (25m soft / 35m deadman slack).
  Host harvest did **not** SCP `h1v2_sim_result_artifact.json` — pair-level
  decomp would die at 07:00Z. Patched + restarted harvest **1748334**.
  n80 ~37/80 @ 06:01; kevin still king; chal-00284 load_challenger.
  Evidence: `h1v2_harvest_artifact_fix.json`, `h1v2_n80_eta_poll.json`.
- **n80 result (06:20Z pass 68):** margin **−0.00030** (z=−0.038,
  SE=0.00787); chall S=0.00531 vs kevin S=0.00561; both valid; **H4 FAIL**
  (r=**0.904**∉[0.70,0.85], base×=0.997). Decomp: chall mean_Λ2 slightly
  better (−0.00978 vs −0.01141) and clip-L1 **+0.01509** (met ≥+0.015
  pred) but kevin clip-L1 +0.01702 still wins the mix. Triage
  `revise_recipe`; submit=false. **Live king changed mid-sim:**
  chal-00284 crowned `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…`
  reign 3 S=0.0315 at 06:15Z — live-king guard match=false. Artifacts:
  `results/h1v2_sim_result.json`, `h1v2_decision.json`,
  `h1v2_n80_confirmed.json`, `result.md`. HF `a314357…` salvage only.
- **Verdict:** **refuted** for this thought-only LoRA recipe (prediction
  ≥+0.04 missed; H4 r still high). Better than H1 (parity vs −0.02) but
  not a crown. Successor: pivot to TalentPigs king + H5/merge/mild distill.


## H2 — weight-merge of recent kings / near-kings beats both

- **Claim:** A linear / SLERP merge of `kevin954/…-sft` with
  `pandora-box/…ckpt300-m4` and/or `hf99jack/…-cali` yields S > kevin at
  near-zero train cost (not weight-identical).
- **Evidence:** three independent distill-shaped winners; merges of strong
  peers are cheap and often beat parents in this meta.
- **Experiment:** merge on `mine-merge-1`; score in Stage 3 simulator.
- **Prediction:** merge paired margin over kevin > **0.02** on first try;
  often > **0.04**. If < 0.02 after two merge recipes, refute for these parents.
- **Result so far (α=0.5, 2026-08-07):** margin **−0.00996** (z=−1.30);
  chall S=0.0189 vs king S=0.0289; both valid; r=0.822 base×=0.837 (H4 OK);
  mean_λ2 chal −0.00166 vs king +0.00359. Equal mix diluted Λ2.
  Raw: `experiments/s4-h2-merge/result.md` + `results/h2_kp50_sim_result.json`.
- **α=0.65 merge (2026-08-07T00:48:53Z):** DONE — 1026 keys merged, 19 from A,
  first_1MiB sha ≠ kevin (`results/h2_kp65_merge_meta.json`); elapsed 333s.
- **α=0.65 sim (2026-08-07T01:37Z):** margin **+0.00725** (z=+0.92);
  chall S=0.0260 vs king S=0.0187; both valid; r=0.806 base×=0.879 (H4 OK);
  mean_λ2 chal +0.00105. Wins=false (need >0.02 and >3·SE≈0.024).
  Raw: `experiments/s4-h2-merge/results/h2_kp65_sim_result.json`.
- **Verdict:** **refuted** for kevin×pandora linear merges (both α < 0.02).
  Sign flip α0.5→α0.65 shows more-kevin helps but stays noise-floor.

## H3 — L1lift is the cheap lever once Λ2 is near king

- **Claim:** After thoughts are teacher-like enough for Λ2≈king, most remaining
  crown margin comes from clipped L1lift (cap ±0.1/turn).
- **Experiment:** Stage 2 decomposition — DONE.
- **Prediction (pre-registered):** among valid duels, |ρ(d_mix, d_clip_l1)| >
  |ρ(d_mix, d_Λ2)| and mean|d_clip_l1| ≥ mean|d_Λ2|.
- **Result:** n=14 valid; ρ(d_mix, d_clip_l1)=**+0.921** vs ρ(d_mix, d_Λ2)=+0.644;
  mean|d_clip_l1|=0.0177 > mean|d_Λ2|=0.0091. Kevin mean clip-L1 only +0.031
  (frac at +0.1 cap = 0.19) → up to ~+0.069 S headroom from L1 alone if gates hold.
- **Verdict:** **supported.**

## H4 — stay inside the distill envelope (gate hygiene)

- **Claim:** Optimizing raw L1 by inflating empty baseline (raising
  mean|lpA(y_C|∅)|) is net-negative under current knobs: base× > 1.25 ⇒ INVALID
  (margin forced 0). Winning envelope is r∈[~0.70,0.85], base×≤~1.15, positive
  clip-L1 via *better* lpA(y_C|z_A), not worse empty.
- **Evidence:** chal-00178 base×=1.86 and chal-00181 base×=3.06 → band fail;
  winners all ≤1.08×.
- **Experiment:** any Stage 4 candidate failing this envelope is rejected before
  submit (no burned slot).
- **Prediction:** every future crown we take will satisfy this envelope; any
  candidate with base×>1.20 will lose or INVALID in sim.
- **Verdict:** open (design rule; reinforced by Stage 2).

## H5 — near-miss / new-king pivot (was michael-chan; now TalentPigs)

- **Claim (updated 2026-08-07T06:20Z):** After H1/H1v2/H2 all miss vs
  kevin, the live king is now `TalentPigs/affine-5ekxlcg3fx-abc` @
  `dbfbb3e2…` (reign 3, S=0.0315 < kevin's 0.0396). A weight-merge of
  kevin (or H1v2-merged) × TalentPigs, or a mild thought-only distill
  from TalentPigs init, clears sim margin > 0.04 vs the **live** king.
- **Prior claim (michael-chan):** near-miss chal-00254 margin −0.0027 —
  demoted; that lineage is stale under the new crown.
- **Experiment:** `experiments/s4-h5-talentpigs/` on `mine-sim-1`
  (deadman 12:00Z). First recipe: kevin×TalentPigs linear merge α=0.65.
- **Launch (2026-08-07T06:25:12Z pass 69):** pivot pipeline pid **227022**
  — download TalentPigs → re-serve king:8001. Evidence:
  `results/h5_pivot_launched.json`.
- **Pivot DONE (2026-08-07T06:32:28Z pass 70):** king:8001 =
  TalentPigs @ `dbfbb3e2…` health 200 (wait ~347s). Markers
  `h5_king_pivot.done` + `h5_pivot_pipeline.done`.
- **Merge+sim launched (2026-08-07T06:32:16Z pass 70):** pipe pid
  **231222** — `merge_linear` kevin α=**0.65** × TalentPigs →
  `/root/merges/h5-kt65/` (1026 common keys) → chall re-serve → n80.
  Evidence: `results/h5_merge_sim_launched.json`.
- **Merge DONE + resume (2026-08-07T06:41:14Z pass 71):** merge wrote
  3 shards in 321s (`max_abs_delta_sample` 6.4e-4; vs-A first_1MiB
  false). Pipe **231222** crashed on king-identity check: assumed
  kevin's `model-00001-of-00002` under TalentPigs (actually 16-shard).
  Fixed layout-aware check; `resume_after_merge.sh` pid **231961** →
  chall:8002 loading merge. Identity: layout_match=false,
  identical_to_king=false. Evidence: `results/h5_kt65_identity.json`,
  `h5_kt65_merge_meta.json`, `h5_resume_launched.json`.
- **Chall READY + n80 launched (2026-08-07T06:46:53Z pass 72):**
  chall:8002 health **200** after ~332s wait; `h5_chall_serve.done`;
  sim pid **235312** `run_sim_duel.py` n=80 →
  `/root/affine_data/h5_kt65_sim_result.json`. Engines 8000/8001/8002
  all 200. Evidence: `results/h5_chall_ready_n80_launched.json`.
- **n80 advancing + harvest (2026-08-07T06:51:58Z pass 73):** 120s
  recheck king 1→11 / chall 3→15; at 06:51:47Z king **12**/80 chall
  **16**/80; engines still 200×3. Host `host_harvest_h5.sh` pid
  **1818104** (stop 11:45Z) SCPs result → `triage_sim.py` →
  `results/h5_decision.json`. Evidence:
  `results/h5_n80_advancing_harvest_armed.json`,
  `results/h5_kt65_sim_progress.json`.
- **Rate confirmed (2026-08-07T06:55:51Z pass 74):** 120s sample
  king 15→**19** / chall 17→**24** @ **1.875** king-tpm / 3.28 chall-tpm;
  engines 200×3; sim **235312** alive; result absent; harvest **1818104**
  + deadman **1783662** alive. ETA finish **~07:28Z**. Evidence:
  `results/h5_n80_rate_confirmed.json`.
- **Mid-flight rate (2026-08-07T06:59:55Z pass 75):** 120s sample
  king 27→**34** / chall 33→**36** @ **3.5** king-tpm / **1.5** chall-tpm
  (chall now bottleneck); engines 200×3; sim **235312** alive; result
  absent; harvest **1818104** + deadman **1783662** alive. ETA finish
  **~07:29Z**. Evidence: `results/h5_n80_midflight_rate.json`.
- **Mid-flight rate (2026-08-07T07:03:59Z pass 76):** 155s sample
  king 39→**48** / chall 42→**51** @ **3.48** tpm both (king bottleneck);
  engines 200×3; sim **235312** alive; result absent; harvest **1818104**
  + deadman **1783662** alive. ETA finish **~07:13Z** (pulled forward
  ~16m vs pass75). Evidence: `results/h5_n80_midflight_rate.json`.
- **α0.65 n80 DONE (2026-08-07T07:15:40Z pass 77):** chall **INVALID** —
  `baseline_band_exceeded`; base×=**4.431**; r=**1.077**; margin forced
  **0.0**; king S=0.02874 valid; triage `reject_gates`; submit=false.
  Live-king guard match. Artifacts: `results/h5_kt65_sim_result.json`,
  `h5_decision.json`, `result.md`.
- **α0.50 launched (2026-08-07T07:17:31Z pass 77):** pipe **240001**
  `start_merge_sim_a50.sh` → `/root/merges/h5-kt50/` → chall serve →
  n80; host harvest **1847826** → `h5_a50_decision.json`. Evidence:
  `results/h5_a50_launched.json`.
- **α0.50 DONE (2026-08-07T07:29:24Z pass 78):** merge OK non-identical
  (329s); chall READY; sim rejected in 32s —
  `unpromptable:probe_no_parsable_action_in_3_turns`. Manual
  `/v1/chat/completions` → repeated `**` gibberish. Equal-weight MoE
  merge destroyed generation. Artifacts: `h5_kt50_sim_result.json`,
  `h5_a50_decision.json`, `h5_a50_unpromptable.json`, `result.md`.
- **Prediction (pre-register BEFORE merge):** n80 paired margin ≥ **+0.04**
  vs TalentPigs; H4 OK; both valid; weight_identical=false.
- **Verdict:** **refuted** for kevin×TalentPigs linear merge at
  α∈{0.65,0.50}. Successor: **H5b** TalentPigs-init thought distill.

## H5b — TalentPigs-init thought-only distill

- **Claim:** Mild thought-only LoRA (lr=**1e-5**, 1 epoch) from live king
  TalentPigs on 440 teacher_refs raises Λ2 without wrecking the crowned
  envelope → n80 margin > 0.04, H4 OK.
- **Experiment:** `experiments/s4-h5b-talentpigs-distill/` on `mine-sim-1`
  GPUs 6,7; pipe merge→chall→n80; harvest → `h5b_decision.json`.
- **Launch (2026-08-07T07:32:21Z pass 78):** train pid **245350**; pipe
  **245426**; harvest **1871830**; thought_mask 440/440; freed broken
  `h5-kt50/`. Evidence: `results/h5b_launched.json`.
- **HF salvage (2026-08-07T07:38:32Z pass 79):** launch pipe lacked
  adapter/merged HF push (same TTL-risk as pre-pass-54 H1v2). Created
  private `unconst/Affine-5czsc2fc98-h5b-lora` + `…-h5b-merged`; patched
  `post_train_pipeline.sh`; restarted pipe **246775** (train untouched);
  mid-ckpt watcher **246776**. Train step **4**/55 @ ~62s/it → ETA
  ~08:30Z. Evidence: `results/h5b_hf_salvage_armed.json`.
- **Final-adapter mid-salvage (2026-08-07T07:43:12Z pass 80):** mid
  watcher previously exited on `train.done` without pushing
  `$TRAIN_DIR/adapter` — pipeline crash before post-merge HF push would
  lose the only candidate at deadman 12:00Z. Patched
  `mid_ckpt_salvage.sh` to final-sweep checkpoints + salvage
  `adapter-final`; restarted mid **247579** (train/pipe untouched). Host
  harvest **1884718** now emits `h5b_train_progress.json` and waits HF
  push PIDs after triage. Freed unused `/root/merges/h5-kt65` (68G).
  Train step **8**/55 loss@5 **0.596**. Evidence:
  `results/h5b_final_adapter_salvage_fix.json`.
- **Identity false-positive fix (2026-08-07T07:48:10Z pass 81):** H5b
  pipe refused on `first_1MiB`+shard-name equality — TalentPigs-init LoRA
  leaves embed windows → would abort after merge (H1 lesson). Patched to
  trust `merge_lora.weight_identical` + multi-window probe; first_1MiB
  match alone is OK. Also `unset CUDA_VISIBLE_DEVICES` before chall
  serve. Restarted pipe **249279** (train **245350** + mid **247579**
  untouched). Freed `/root/h1/merged`+`/root/h1v2/merged` (~136G). Step
  **14**/55 loss@10 **0.498**. Evidence:
  `results/h5b_identity_false_positive_fix.json`.
- **GPU-release race fix (2026-08-07T07:52:29Z pass 82):** `train.done`
  is written while train still holds GPUs 6,7 during teardown; immediate
  merge would OOM. Pipe now waits for `train_lora.py` exit + 15s settle;
  adapter HF push serialized vs mid `adapter-final`; `--base-hub
  TalentPigs/...` on salvage. Restarted pipe **251842** + mid **251832**
  (train **245350** untouched). Step **19**/55 loss@15 **0.508**.
  Evidence: `results/h5b_gpu_release_race_fix.json`,
  `h5b_time_budget_pass82.json`.
- **n80 retry (2026-08-07T07:57:45Z pass 83):** H1 n80 died once on
  ReadTimeout despite engines healthy; H5b pipe had a single foreground
  sim under `set -e` (one crash → burn train at deadman). Patched
  `post_train_pipeline.sh` for ≤**3** n80 attempts with `<40m` deadman
  gate + engine health warn; vllm_client already 360s×5. Restarted pipe
  **253801** (train **245350** + mid **251832** untouched). Step
  **24**/55 loss@20 **0.521**. Evidence:
  `results/h5b_n80_retry_fix.json`, `h5b_time_budget_pass83.json`.
- **Harvest abort+done-marker gate (2026-08-07T08:00:54Z pass 84):**
  pass-83 retries `rm` result.json between attempts — bare-JSON harvest
  could triage a doomed attempt. Also pipe abort left harvest spinning
  to 11:45Z with no decision. Patched `host_harvest_h5b.sh`: triage only
  after `h5b_sim_n80.done`/`pipeline.done`; on `pipeline.aborted` write
  `h5b_decision.json` action=`pipe_aborted` immediately. Harvest
  restarted **1917667** (train/pipe/mid untouched). Step **28**/55
  loss@25 **0.429**. Evidence:
  `results/h5b_harvest_abort_done_gate_fix.json`,
  `h5b_time_budget_pass84.json`.
- **Chall VRAM pre-free (2026-08-07T08:14:54Z pass 88):** chall still
  served deleted `/root/merges/h5-kt50` from RAM (~118 GiB×2 on GPUs
  4,5). Killed chall **240863** during remaining train so post-merge
  chall-only serve skips VRAM reclaim. Teacher+king **200**; train
  **245350** / pipe **258082** / mid **251832** untouched. Step
  **42**/55 loss@40 **0.468**. Evidence:
  `results/h5b_prefree_chall_vram.json`, `h5b_time_budget_pass88.json`.
- **TalentPigs packed-visual merge fix (2026-08-07T08:18:46Z pass 89):**
  TalentPigs has **no** `model-visual*.safetensors` — 333 visual tensors
  live in `model-00016-of-00016.safetensors` with 9 language tensors.
  Old `merge_lora` only copied `model-visual*` (kevin layout) → H5b
  merge would drop vision tower → chall serve crash under restored
  wrapper config. Patched to extract missing keys into
  `model-visual-restored.safetensors`; refuse if base has visual and
  out has none; stage meta as `h5b_merge_meta.json`. SCP'd to pod
  (md5 `e5f51cec…`) at step **46**/55 — train/pipe/mid untouched.
  Evidence: `results/h5b_talentpigs_visual_restore_fix.json`,
  `h5b_time_budget_pass89.json`.
- **Bash file-offset abort + recover (2026-08-07T08:28:44Z pass 90):**
  train finished 08:26:33Z (55/55, loss@55 **0.425**, adapter OK) but
  pipe **258082** died with `line 74: ted: command not found` /
  `aborted_err_rc=127` — bash kept a file offset into
  `post_train_pipeline.sh` while earlier passes SCP'd edits during the
  wait loop. Harvest wrote false `pipe_aborted` decision and exited.
  Cleared markers, relaunched pipe **266631** + harvest **1964910**.
  Merge completed 08:35:14Z: **extracted 333** visual keys →
  `model-visual-restored.safetensors`; `identical_to_king=false`;
  chall:8002 loading on GPUs 4,5. **Never edit a live pipe script
  under a sleeping bash.** Evidence:
  `results/h5b_pipe_file_offset_abort_fix.json`, `h5b_identity.json`,
  `h5b_merge_meta.json`, `h5b_time_budget_pass90.json`,
  `h5b_decision_pass90_false_abort.json`.
- **Chall ready + n80 launched (2026-08-07T08:40:52Z pass 91):**
  chall:8002 **200** @ 08:40:51Z (`CHALL_SERVE_DONE`); n80 attempt
  **1/3** pid **276121** vs TalentPigs `dbfbb3e2…`; progress king
  **6**/chall **2** @ 08:45:23Z (advancing). HF merged salvage done
  `unconst/Affine-5czsc2fc98-h5b-merged` @ `e1d39a1…` (private; do not
  submit). Evidence: `results/h5b_n80_launched.json`,
  `h5b_sim_progress.json`, `h5b_merged_salvage.json`,
  `h5b_time_budget_pass91.json`.
- **n80 advancing (2026-08-07T08:49:11Z pass 92):** engines 200×3; sim
  **276121** + pipe **266631** alive; king **15**/chall **15**; 120s
  window ~2.13/2.55 tpm → ETA **~09:20Z**; deadman 12:00Z slack OK; no
  retries. Evidence: `results/h5b_sim_progress.json`,
  `h5b_time_budget_pass92.json`.
- **n80 advancing (2026-08-07T08:56:09Z pass 94):** engines 200×3; sim
  **276121** + pipe **266631** alive attempt 1/3; king **29**/chall
  **29**; window from 19/19@08:52:42Z → ~2.90 tpm → ETA **~09:14Z**
  (rate recovered vs pass93 ~1.14); deadman slack ~166 min OK; no
  result/retries. Evidence: `results/h5b_sim_progress.json`,
  `h5b_time_budget_pass94.json`.
- **n80 advancing (2026-08-07T08:59:13Z pass 95):** engines 200×3; sim
  **276121** + pipe **266631** alive attempt 1/3; king **33**/chall
  **33**; window from 29/29@08:56:09Z → ~1.30 tpm → ETA **~09:35Z**
  (dip vs pass94; 90s wall ~0.67); deadman slack ~145 min OK; no
  result/retries. Evidence: `results/h5b_sim_progress.json`,
  `h5b_time_budget_pass95.json`.
- **n80 advancing (2026-08-07T09:02:56Z pass 96):** engines 200×3; sim
  **276121** + pipe **266631** alive attempt 1/3; king **39**/chall
  **40**; window from 33/33@08:59:13Z → ~1.61 tpm → ETA **~09:28Z**
  (recovered vs pass95; 90s wall ~2.67); deadman slack ~152 min OK; no
  result/retries. Evidence: `results/h5b_sim_progress.json`,
  `h5b_time_budget_pass96.json`.
- **Prediction (pre-register BEFORE train):** n80 margin ≥ **+0.04**;
  H4 OK; clip-L1 ≥ +0.015; not weight-identical.
- **n80 result (2026-08-07T09:25:18Z pass 99):** margin **+0.00322**
  (z=**0.547**, SE=0.00589); chall S=0.04699 vs king S=0.04405; both
  valid; **H4 FAIL** (r=**0.670**∉[0.70,0.85], base×=0.949 OK). Chall
  mean_Λ2 better (0.0134 vs 0.0094) but clip-L1 flat (+0.0336 vs
  +0.0347). Triage `revise_recipe`; submit=false; live-king match=true.
  Artifacts: `experiments/s4-h5b-talentpigs-distill/result.md`,
  `results/h5b_sim_result.json`, `results/h5b_decision.json`. HF
  salvage only (`e1d39a1…`). chal-00300 was `load_challenger` at triage.
- **Verdict:** **refuted** for this TalentPigs-init mild thought LoRA
  (prediction ≥+0.04 missed; margin even < contract 0.02). Successor:
  **H5c** — do not repeat 440-ref king-init mild LoRA; need a larger
  lever (expanded refs / recipe change / public TalentPigs autopsy).

## H5c — L1-headroom distill vs TalentPigs (from crown autopsy)

- **Claim:** Kevin-init thought-only LoRA on **expanded** public
  teacher_refs raises mean clip-L1 to ≥ **0.042** (TalentPigs crown
  +0.01) while keeping r∈[0.70,0.85] → n80 margin > 0.04 vs live
  TalentPigs.
- **Evidence (pass 100 autopsy):** chal-00284 crown vs kevin =
  margin **+0.028**, dL1c **+0.0157**, dΛ2 +0.0123, L1 share **0.56**,
  chall r=**0.720**, clip-L1 **+0.0325**. Near-miss `…-ppp` lost at
  −0.004 with clip-L1 only +0.0232 (ΔL1 vs crown −0.009). H5b matched
  TalentPigs L1 and only nudged Λ2 → wrong axis.
- **Experiment:** `experiments/s4-h5c-crown-autopsy/` (DONE) →
  `s4-h5c-expand-refs/` harvest (DONE) → train on a fresh `mine-*` pod.
- **Prediction (pre-register BEFORE train):** n80 margin ≥ **+0.04**;
  H4 OK; chall mean clip-L1 ≥ **0.042**.
- **Autopsy status:** DONE 2026-08-07T09:32Z.
- **Harvest status (pass 101):** 60 duels → expanded **1329** /
  shortz(z≤250) **791** (1.80× H1) / shortz+nolist 790. Shortz alone
  kills listy (0.14→0.001). Primary DATA =
  `results/teacher_refs_shortz.jsonl` (gitignored full; regenerable).
- **Train launch (pass 102):** rented `mine-h5c-1` (`golden-hawk-dc`)
  8×H200 @$28/h `--ttl 10h` (remove 19:37Z). Uploaded 791 shortz +
  H1v2 train/mask + H1 merge_lora + `bootstrap_h5c.sh` / fixed
  `start_h5c.sh`. Bootstrap pid **902**: uv pip (torch/vllm/peft) →
  kevin dl → thought LoRA lr=2e-5 on GPUs 6,7; TalentPigs+teacher dl
  in bg for later n80. Prediction still pre-registered above.
- **Post-train arm (pass 104):** mid **5194** / prewarm **5206** /
  pipe **5222**; corpus 9000; HF salvage repos created.
- **Host harvest/deadman (pass 105):** harvest **2090851** (stop
  18:45Z) + deadman **2090852** (`lium rm mine-h5c-1` @ 19:00Z).
  Train step **8**/99 @ ~48s/it when armed; prewarm still loading.
- **Verdict:** **open**.

## Scaffolding

### H0 — scaffolding / no claim yet
- **Status:** retired (Stage 0–1 done).

## Refuted

### H5b — TalentPigs-init mild thought LoRA
- Prediction missed: n80 margin ≥ +0.04; H4 r∈[0.70,0.85].
- Deciding numbers: margin **+0.00322** (z=0.547); r=**0.670**;
  clip-L1 +0.0336 (pred met) but Λ2 gain only ~+0.004 vs king.
- Kept: mild king-init distill stays gate-valid and slightly ahead on S;
  nowhere near crown. Do not submit `…-h5b-merged` @ `e1d39a1…`.

### H1v2 — thought-only teacher distill (kevin init)
- Prediction missed: n80 margin ≥ +0.04; H4 r∈[0.70,0.85].
- Deciding numbers: margin **−0.00030**; r=**0.904**; clip-L1 +0.01509
  (pred met) but not enough vs kevin +0.017.
- Kept: thought mask restores clip-L1 vs full-completion H1; still not a
  crown. Do not submit `…-h1v2-merged` @ `a314357…`.

### H2 — kevin×pandora linear merge (α∈{0.5, 0.65})
- Predictions missed: first-try margin >0.02; often >0.04.
- Deciding numbers: α0.5 margin **−0.00996**; α0.65 margin **+0.00725**.
- Kept: gates/H4 OK on both; failure is ranking (Λ2 dilution / insufficient
  compound). Do not resubmit these recipes.
