# s4-h9-tp-diane-merge — H9

**Hypothesis:** Linear merge of live king TalentPigs × reign earner
diane613 (TalentPigs-dominant α) beats TalentPigs on n80. Untried B-parent
— H7=pandora, H8=golden-crown; diane613 earns with null published S.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·diane613`)
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4.0], baseline≤1.25×king, weight ≠ king
- If 0.02≤margin≤0.04: try α=0.85
- If margin<0.02 after both → refute H9 for these parents

## Why these parents

diane613 is in the earning reign set (null published S, still weighted).
Independent of H7/H8 B-parents → parallel cheap merge while H6/H7/H8 run.

## Method

1. Rent `mine-h9-1` 8×H200 `--ttl 8h`.
2. Bootstrap pinned vLLM stack; download TalentPigs + diane613 + teacher.
3. `merge_linear.py` → `/root/merges/h9-tp75/`.
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80 vs TalentPigs; decide per rule above.

## Decision rule

- margin > 0.04 + chall_valid → Stage 5 prep (submit checklist).
- 0.02≤margin≤0.04 → TRY_ALPHA_085 on same pod.
- margin < 0.02 → REFUTE_H9; tear `mine-h9-1` only (name-check). No submit.

## Out of scope

No host-side weights. Never touch validator pods.
