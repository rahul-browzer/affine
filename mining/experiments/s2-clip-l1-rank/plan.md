# s2-clip-l1-rank — select B by measured clip-L1 (H3)

**Claim:** Parent published margin is a bad selector for α-merges (H20).
Challenger mean clip-L1 on the *same* TalentPigs-era slice should rank
merge parents better. Offline, no GPU.

**Method:** Download +margin / interest `evals/*.json.gz` from Hippius;
recompute mean clip(L1lift,±0.1) and d_clipL1 = c−k via `affine.score`.
Rank TP-era (chal≥284) by d_clipL1; mark inflight/gated/already-tested.

**Decision rule (pre-registered):** Next free-slot B must be the top
ungated, untested, band-clear TP-era parent by d_clipL1 (or c_clipL1),
not by published margin. If top is already refuted as an α0.90 merge,
do not requeue — escalate to a mean-shift recipe instead.
