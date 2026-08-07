# s4-h7-tp-pandora-merge — H7

**Hypothesis:** Linear merge of live king TalentPigs × reign-1 pandora-m4
(TalentPigs-dominant α) beats TalentPigs on n80. Untried parents — H2 was
kevin×pandora, H5 was kevin×TalentPigs; both refuted.

## Prediction (pre-register BEFORE merge)

- α=0.75 first (`out = 0.75·TalentPigs + 0.25·pandora`), TalentPigs shard/config
- n80 paired margin ≥ **+0.04** vs live TalentPigs
- Gates: r∈[0.3,4.0], baseline≤1.25×king, weight ≠ king (H4 tight band REFUTED)
- If 0.02≤margin≤0.04: try α=0.85
- If margin<0.02 after both → refute H7 for these parents

## Why α high toward TalentPigs

H5 α=0.50 MoE merge was unpromptable; α=0.65 blew baseline_band (base×4.43).
Stay TalentPigs-dominant to keep generation + envelope; borrow pandora's
clip-L1 style (crown clipL1 +0.026, r≈0.76).

## Method

1. Rent `mine-h7-1` 8×H200 `--ttl 8h` (independent of mine-h5c-1).
2. Bootstrap pinned vLLM stack; download TalentPigs + pandora + teacher.
3. `merge_linear.py` → `/root/merges/h7-tp75/` (reuse s4-h2-merge).
4. Serve teacher:8000 / king:8001=TalentPigs / chall:8002=merge.
5. `run_sim_duel.py` n80 vs TalentPigs; decide per rule above.

## Decision rule

- margin > 0.04 + chall_valid → Stage 5 prep (submit checklist).
- 0.02≤margin≤0.04 → TRY_ALPHA_085 on same pod.
- margin < 0.02 → REFUTE_H7; tear `mine-h7-1`. Do not submit.

## Out of scope

No host-side weights. No submit without margin>0.04. Never touch validator pods.
