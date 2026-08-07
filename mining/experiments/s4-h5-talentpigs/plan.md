# s4-h5-talentpigs — Stage 4 H5: pivot to TalentPigs + kevin×TalentPigs merge

## Hypothesis

**H5:** After H1 / H1v2 / H2 all miss vs kevin, the live king is
`TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4`
(reign 3, S=0.0315). A linear weight merge of kevin (higher absolute S /
envelope) × TalentPigs (just crowned) clears sim margin **> 0.04** vs the
**live** king on public D.

Fallback if merge fails: mild thought-only distill from TalentPigs init
(separate recipe; not this first shot).

## Prediction (pre-registered BEFORE merge)

First recipe `α=0.65` (kevin-heavy; H2 showed α0.65 > α0.5 on kevin×pandora):

- n80 paired mean margin vs TalentPigs **≥ +0.04**
- both sides gate-valid; H4 OK (r∈[0.70,0.85], base×≤1.15)
- weight_identical to king = false

If margin < 0.02 after α∈{0.65, 0.50}, refute H5 merge for these parents
and pivot to mild TalentPigs-init thought distill.

## Method

1. Download TalentPigs into pod HF cache (`download_talentpigs.sh`).
2. Pivot king:8001 → TalentPigs @ `dbfbb3e2…` (teacher:8000 stays;
   chall may stay H1v2 until merge swaps it) via `pivot_king.sh`.
3. `merge_linear.py` (reuse s4-h2-merge): `out = α·kevin + (1−α)·TalentPigs`
   → `/root/merges/h5-kt65/`; verify ≠ king first_1MiB.
4. Re-serve chall:8002 = merge; run `run_sim_duel.py` n80 vs TalentPigs king.
5. Triage with live-king guard; submit only if margin > 0.04 + H4.

## Decision rule

- **Submit path** only if sim margin > 0.04, gates pass, H4 ok, stock vLLM.
- **Try α=0.50** if 0.02 ≤ margin ≤ 0.04.
- **Refute merge parents** if margin < 0.02 after both α.
- Never submit without Stage-5 checklist + fresh hotkey + `--check`.

## Out of scope

No host-side weights. No validator edits. No submit of H1/H1v2/H2 ckpts.
