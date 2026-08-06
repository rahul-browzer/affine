# INVENTORY — mine-* pods only

Reconcile against `lium ps` at the start of every pass.
Never touch pods whose names do not start with `mine-`.

## Live inventory

| name | huid | gpu | $/hr | ttl | purpose | status | notes |
|---|---|---|---|---|---|---|---|
| *(empty)* | | | | | | | |

## Reconcile log

| UTC | lium ps mine-* | inventory action |
|---|---|---|
| 2026-08-06T22:47:00Z | none | none — only `affine-eval` (8×B300 $64/h) and `affine-bench` (8×H200 $5.80/h) live; both validator-owned, left alone |
| 2026-08-06T22:49:00Z | none | none — same two validator pods; no orphans |
