# HYPOTHESES — falsifiable claims

Ranked by expected α per dollar after Stage 2 public-duel mining
(`experiments/s2-public-duel-mine/`, 2026-08-06). Keep refuted entries.

## Ranked (Stage 2 gate)

| rank | id | expected α/$ | predicted effect on S / margin | status |
|---|---|---|---|---|
| 1 | H1v2 | highest (fixes H1 envelope) | thought-only SFT → r∈[0.70,0.85] + margin **> 0.04** | open — **training** step43/55 loss0.400; pipe **171602** prefer-n80; H1 n80 freed engines |
| 2 | H1 | was highest | full (z,y) SFT margin **> 0.04** | **refuted** (this recipe) — n40 −0.0024; n80 **−0.01994** z=−2.42; H4 fail both |
| 3 | H2 | very high (almost free compute) | merge margin vs kevin **> 0.02** first try; target **> 0.04** | **refuted** (α0.5 −0.010; α0.65 +0.007) |
| 4 | H4 | high (constraint, not a train) | keep r∈[0.70,0.85], base×≤1.15 or gates kill S | open (design rule; H1 breached) |
| 5 | H3 | instrumental lever | once Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S (cap +0.1) | **supported** |
| 6 | H5 | medium | SFT on near-miss lineage to flip −0.0027 → >+0.04 | open (fallback after H1v2) |

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
- **Verdict:** open — training in progress (prediction unchanged).


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

## H5 — near-miss continuation (michael-chan h2 class)

- **Claim:** Live-king near-miss `michael-chan-000/affine-5EqYW8McUc-h2`
  (chal-00254, margin **−0.0027**, cS=+0.0176, clip-L1 only +0.0148) is one
  small teacher-ref SFT away from clearing noise — but our submit gate needs
  **>0.04**, so treat as a warm start, not a one-shot.
- **Experiment:** optional after H1/H2; Stage 4 sim.
- **Prediction:** +teacher-ref SFT from that init → margin ≥ +0.02 vs kevin;
  reaching +0.04 may still need H1-from-kevin or a merge.
- **Verdict:** open (lower priority than H1/H2).

## Scaffolding

### H0 — scaffolding / no claim yet
- **Status:** retired (Stage 0–1 done).

## Refuted

### H2 — kevin×pandora linear merge (α∈{0.5, 0.65})
- Predictions missed: first-try margin >0.02; often >0.04.
- Deciding numbers: α0.5 margin **−0.00996**; α0.65 margin **+0.00725**.
- Kept: gates/H4 OK on both; failure is ranking (Λ2 dilution / insufficient
  compound). Do not resubmit these recipes.
