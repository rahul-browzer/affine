# Fleet rent — scale mine-* toward $20k/day B300 floor

## Why
Operator 2026-08-11: burn ≥$833/h on mine-* 8×B300 (~≥13 boxes @ ~$64/h).
Cap 25. One-pod waiters under-rent when stock appears in bursts.

## Method
`wait_fleet_b300.sh` polls every 30s; prefers 8×B300; falls back to 8×B200;
rents next free name from a distinct-axis QUEUE until `TARGET_MINES=13` or
queue empty. Hard stop if Lium bal < $10k. Always `--ttl 24h`.

## Queue (first free names)
R4 full-FT · R5 non-king · R6 thought-format · R7 data-filter · R8 REINFORCE ·
R3b GRPO alt-LR · R9 teacher-zc · R4b full-FT family · R5b non-king-2 ·
R10 merge+RL · R6b format ablate.

## After rent
`wait_bootstrap_fleet.sh` auto-uploads R4–R9 + R3b + R4b + R5b. Remaining
R10/R6b still stamp `needs_axis_uploader` until armed. Stamps:
`artifacts/rented_<name>.json`.
