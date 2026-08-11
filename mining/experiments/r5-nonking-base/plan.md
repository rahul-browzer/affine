# R5 — non-king base + Reason FT

## Axis
Train from Genesis (not Tok king-init). Structural cross vs R3/R4.
Goal: raise paired Reason margin without copying incumbent style.

## Pod
`mine-r5-nonking-1` via fleet-rent. 8×B300 prefer. TTL 24h.
Auto-bootstrap (p2074): `fleet-rent/wait_bootstrap_fleet.sh` →
`r5-nonking-base/upload_and_launch.sh` → H122 Genesis full-FT stack
(`dendriteholdings/albedo-qwen3.6-35b-king-genesis` @ `abe89194…`) on
`winner_za_high_l1` (same data family as R4; base is the isolate).

## Decision
n80 vs Tok; submit only if hr ≥ 1.5×(k_sigma·SE), live k=2.0.
- hr < 0.5× → REFUTE
- 0.5× ≤ hr < 1.5× → WEAK_SKIP
- hr ≥ 1.5× fresh slice → Stage 5
