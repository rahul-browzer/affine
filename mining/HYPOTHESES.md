# HYPOTHESES — falsifiable claims

One entry per hypothesis. Keep refuted entries.
**Ranked by expected α per dollar (Stage 2 gate — 2026-08-06T22:51Z).**

Evidence: `experiments/s2-public-duel-mine/{table.txt,summary.json,result.md}`.

---

## Ranked open (do these in order)

### #1 — H1 teacher-ref SFT beats the king
- **Claim:** SFT / distill on published `teacher_refs` (z_C, y_C) from duel
  records raises S enough to clear sim margin > 0.04 vs current king.
- **Why #1 α/$:** Both live crowns are this lineage (pandora ckpt300-m4, kevin
  sft). Every sampled duel ships 80 teacher refs for free. No need to invent a
  thought distribution — copy the teacher's on scored turns.
- **Target shape (from winners):** r ∈ [0.65, 0.85], base× ≤ 1.15, bank ≫ 0.08,
  mean clipL1 ≥ +0.03, Λ2 ≥ king Λ2 (~+0.009 on kevin's crown duel).
- **Experiment:** Stage 4 after Stage 3 simulator gate; train on pod
  `mine-sft-1`, score vs `kevin954/Affine-5dfqbbh8ev-sft`.
- **Prediction (pre-register):** challenger mean S ≥ king S + 0.04 on an
  80-turn public-D slice; all gates pass; r ∈ [0.65, 0.85].
- **Predicted ΔS vs king:** **+0.04 to +0.08** (kevin beat genesis by +0.070;
  next crown needs >0.02 live / >0.04 our submit gate).
- **Verdict:** open — highest expected α/$.

### #2 — H2 weight-merge of recent kings beats both
- **Claim:** Linear / SLERP merge of `kevin954/…-sft` ×
  `pandora-box/…ckpt300-m4` (and/or m3) yields S > max(parents) at near-zero
  train cost.
- **Why #2 α/$:** Merge is hours of GPU vs days of SFT; m3 already shows
  winner-shaped r=0.81 / clipL1=+0.021 (chal-00194 recompute margin +0.029).
  Cheap probe before committing to a long SFT.
- **Experiment:** merge on `mine-merge-1`; score in Stage 3 simulator.
- **Prediction:** first merge clears noise floor (margin > 0.02 vs king);
  often clears our 0.04 submit gate.
- **Predicted ΔS vs king:** **+0.02 to +0.05**.
- **Verdict:** open — run in parallel with H1 once simulator exists; prefer
  this if Lium budget is tight.

### #3 — H3 L1lift is the cheap lever once Λ2 is near king
- **Claim:** After thoughts are teacher-like enough for Λ2≈king, most remaining
  crown margin comes from clipped L1lift (cap ±0.1/turn).
- **Evidence (Stage 2):** n=15 valid duels; Spearman(Δmix, ΔclipL1)=**0.936**
  vs Spearman(Δmix, ΔΛ2)=0.711; winners' paired margins are 57–82% ΔclipL1;
  kevin mean clipL1=+0.031 with only 19% pairs at +clip ⇒ ~+0.069 headroom to
  the +0.1 mean cap.
- **Experiment (operational):** treat as selection / train objective inside H1
  and H2 — not a third model family. Reject candidates with mean clipL1 <
  king's unless ΔΛ2 alone clears +0.04.
- **Prediction (already tested on public data):** ΔS correlates more with
  ΔclipL1 than ΔΛ2 — **confirmed**.
- **Predicted residual headroom on S if Λ2 held at king and clipL1 → +0.1:**
  up to **~+0.069** (upper bound; r / baseline_band will bind earlier).
- **Verdict:** **supported** (public-duel decomposition). Keep as objective
  constraint for H1/H2, not a separate rental.

---

## Supporting observations (not separate bets yet)

### H4 — baseline sabotage is dead; do not chase free L1 via empty baseline
- chal-00178 / 00181 killed at base× 1.86 / 3.06. Honest winners sit at
  1.06–1.08×. Soft cap for us: base× ≤ 1.15 in sim before submit.
- **Verdict:** supported as a negative constraint.

### H5 — r>1 is a losing signature on this sample
- Valid losers cluster at r>1 with negative clipL1; winners at r≈0.72–0.76.
- **Verdict:** supported as a filter (reject r>1.0 candidates early).

---

## Scaffolding / closed

### H0 — scaffolding
- **Status:** closed (Stages 0–2 done).

## Refuted

*(none yet)*
