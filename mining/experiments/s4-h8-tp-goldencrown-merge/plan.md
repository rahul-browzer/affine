# s4-h8-tp-goldencrown-merge — H8

**Hypothesis:** Linear merge of live king TalentPigs × reign earner
golden-crown (TalentPigs-dominant α) beats TalentPigs on n80. Untried
parents — H7 is TalentPigs×pandora; H2/H5 used kevin.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·golden-crown`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- H4: r∈[0.70,0.85], base×≤1.15; weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If margin<0.02 after both → refute H8 for these parents

## Why these parents

golden-crown is in the earning reign set (null published S, still weighted).
Different B-parent from H7 (pandora) → independent cheap merge bet while
H5c/H6/H7 occupy other pods.

## Method

1. Rent `mine-h8-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM stack; download TalentPigs + golden-crown + teacher.
3. `merge_linear.py` → `/root/merges/h8-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80 vs TalentPigs; decide per rule above.

## Decision rule

- margin > 0.04 + H4 OK → Stage 5 prep.
- else refute; tear `mine-h8-1` only (name-check first). No submit.

## Out of scope

No host-side weights. Never touch validator pods.
