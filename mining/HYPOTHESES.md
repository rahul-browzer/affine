# HYPOTHESES — falsifiable claims

Ranked by expected α per dollar after Stage 2 public-duel mining
(`experiments/s2-public-duel-mine/`, 2026-08-06). Keep refuted entries.

## Ranked (Stage 2 gate)

| rank | id | expected α/$ | predicted effect on S / margin | status |
|---|---|---|---|---|
| 1 | H5 / new-king | highest now | pivot to TalentPigs king; merge or mild distill → margin **> 0.04** | **open** — α0.65 merge DONE; chall loading→n80 |
| 2 | H1v2 | was highest | thought-only SFT → r∈[0.70,0.85] + margin **> 0.04** | **refuted** — n80 margin **−0.00030**; r=0.904 H4 fail; clip-L1 +0.015 OK |
| 3 | H1 | was highest | full (z,y) SFT margin **> 0.04** | **refuted** (this recipe) — n40 −0.0024; n80 **−0.01994** z=−2.42; H4 fail both |
| 4 | H2 | very high (almost free compute) | merge margin vs kevin **> 0.02** first try; target **> 0.04** | **refuted** (α0.5 −0.010; α0.65 +0.007) |
| 5 | H4 | high (constraint, not a train) | keep r∈[0.70,0.85], base×≤1.15 or gates kill S | open (design rule; H1/H1v2 breached) |
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
- **Prediction (pre-register BEFORE merge):** n80 paired margin ≥ **+0.04**
  vs TalentPigs; H4 OK; both valid; weight_identical=false.
- **Verdict:** open — merge OK; chall load→n80 pending.

## Scaffolding

### H0 — scaffolding / no claim yet
- **Status:** retired (Stage 0–1 done).

## Refuted

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
