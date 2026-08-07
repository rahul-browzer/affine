# HYPOTHESES — falsifiable claims

Ranked by expected α per dollar after Stage 2 public-duel mining
(`experiments/s2-public-duel-mine/`, 2026-08-06). Keep refuted entries.

## Ranked (Stage 2 gate)

| rank | id | expected α/$ | predicted effect on S / margin | status |
|---|---|---|---|---|
| 1 | H1 | highest | sim margin vs kevin **> 0.04** after teacher-ref SFT from kevin init | open — **next** |
| 2 | H2 | very high (almost free compute) | merge margin vs kevin **> 0.02** first try; target **> 0.04** | **refuted** (α0.5 −0.010; α0.65 +0.007) |
| 3 | H4 | high (constraint, not a train) | keep r∈[0.70,0.85], base×≤1.15 or gates kill S | open (design rule) |
| 4 | H3 | instrumental lever | once Λ2≈king, +0.01 mean clip-L1 ⇒ +0.01 S (cap +0.1) | **supported** |
| 5 | H5 | medium | SFT on near-miss lineage to flip −0.0027 → >+0.04 | open |

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
- **In flight (2026-08-07T02:18Z):** harvest 440/440; LoRA r=16 2ep from
  kevin init, 110 steps, pid 82057 (~step 26 @ 55s/it, ETA ~03:35Z).
  Post-train pipeline pid **86845** armed: HF adapter salvage
  (`unconst/Affine-5czsc2fc98-h1-lora`, private, **repo pre-created**) →
  **GPU merge on 6,7** → **chall-only re-serve** (king kept) → **n=40
  probe then n=80** (skip n80 if <50 min to **06:50Z**) →
  `/root/affine_data/h1_sim_result{,_n40}.json`. Mid-ckpt salvage
  pid 83669; `lium bk` on `/root/h1/train` every 1h; host harvester
  1405460. **Pass 33:** cancelled Lium TTL 04:53Z (n80 would miss under
  old soft deadline); host deadman 1405846 `lium rm mine-sim-1` at 07:00Z.
- **Verdict:** open.

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
