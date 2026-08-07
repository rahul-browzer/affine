# s4-h10-tp-kevin-merge — H10

**Hypothesis:** Linear merge of live king TalentPigs × reign-2 kevin
(TalentPigs-dominant α) beats TalentPigs on n80. H5 refuted
*kevin-dominant* mixes (α=0.65 → base×4.43; α=0.50 unpromptable). This
flips A/B: `out = 0.75·TalentPigs + 0.25·kevin` — untried direction.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·kevin`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4.0], baseline≤1.25×king, weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If margin<0.02 after both → refute H10 for this direction

## Why these parents

kevin holds highest published S (0.0396) among earners; H7–H9 cover
pandora/golden-crown/diane. TP-dominant borrow of kevin's clip-L1 style
is the remaining reign-pair merge, independent of H6 train.

## Method

1. Rent `mine-h10-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM stack; download TalentPigs + kevin + teacher.
3. `merge_linear.py` → `/root/merges/h10-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80 vs TalentPigs; decide per rule above.

## Decision rule

- margin > 0.04 + chall_valid → Stage 5 prep.
- 0.02≤margin≤0.04 → TRY_ALPHA_085 on same pod.
- margin < 0.02 → REFUTE_H10; tear `mine-h10-1` only (name-check). No submit.

## Out of scope

No host-side weights. Never touch validator pods.
