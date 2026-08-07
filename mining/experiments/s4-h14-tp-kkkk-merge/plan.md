# s4-h14-tp-kkkk-merge — H14

**Hypothesis:** Linear merge of live king TalentPigs × chal-00268 near-miss
(`kkkk`, +0.0132 z=1.24 gate-valid) beats TalentPigs on n80. Independent of
H6/H9–H13. Weaker than H13 (+0.0244) — launch only after H13 is already running
or if kkk-af vanishes.

**B parent:** `vincentwarrior/affine-5ccebdzvsj-kkkk` @
`3ca1ebe6a952b7ad935ca53f7dd8e85b498bfcb0` (= exact chal-00268 rev of
`dfwas…/…-kkkk`; ungated; `hf_hub_download(.gitattributes)` OK 2026-08-07T13:09Z).

## Prediction (pre-register BEFORE rent)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·kkkk`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4], base×≤1.25 (chal-00268 base×≈0.86); weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If INVALID band or margin<0.02 → refute; no α0.85 on gate-fail

## Method

1. On a free `mine-*` slot (prefer after H13 launched): rent `mine-h14-1`
   8×H200 `--ttl 8h`.
2. `DST_HOST=… DST_PORT=… bash upload_and_launch.sh`
3. merge → serve_three → n80; nested `write_merge_decision.py`.

## Decision rule

- margin > 0.04 + gates OK → Stage 5 prep.
- else refute; tear `mine-h14-1` only. No submit.

## Gate to launch

Slots full (5/5). H13 has priority. Launch H14 on the *second* free slot, or
first free slot if H13's B parent 404s.
