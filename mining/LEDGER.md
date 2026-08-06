# LEDGER — money in / money out

Floor rules: Lium balance ≥ $28,000 always; cumulative mining spend ≤ $4,000 until first crown.

## Balances (latest)

| UTC | Lium USD | miner free τ | miner stake τ | notes |
|---|---|---|---|---|
| 2026-08-06T23:00:03Z | 34703.01 | 10.000000 | 0 | mine-sim-1 spent $2.66; balance flat vs 22:57 (meter lag vs validator burn) |
| 2026-08-06T22:57:35Z | 34703.01 | 10.000000 | 0 | mine-sim-1 live @ $23.60/h + validator burn |
| 2026-08-06T22:51:06Z | 34709.52 | 10.000000 | 0 | validator pods burning shared credit; mining spend still $0 |
| 2026-08-06T22:47:00Z | 34715.32 | 10.000000 | 0 | opening snapshot; no mining spend yet |

## Movements

| UTC | kind | amount | from → to | running Lium USD | running miner τ free | note |
|---|---|---|---|---|---|---|
| 2026-08-06T22:47:00Z | open | — | — | 34715.32 | 10.000 | coldkey funded τ10 prior to run; Lium shared with validator |
| 2026-08-06T22:51:06Z | observe | — | — | 34709.52 | 10.000 | −$5.80 vs open ≈ validator burn; no mine-* rental |
| 2026-08-06T22:53:18Z | rent | $23.60/h | Lium credit → mine-sim-1 (8×H200) | 34709.52 (pre) | 10.000 | `lium up` golden-comet-class H200; name `mine-sim-1`; TTL 6h → remove 2026-08-07T04:53:17Z; max TTL exposure ≈ $141.60; floor OK ($34.7k ≫ $28k); cap OK |
| 2026-08-06T22:57:35Z | observe | ~$6.5 vs 22:51 | shared burn + mine-sim | 34703.01 | 10.000 | includes ~4 min mine-sim (~$1.6) + validator pods |
| 2026-08-06T23:00:03Z | observe | mine-sim spent $2.66 | Lium → mine-sim-1 | 34703.01 | 10.000 | no new rental; harness upload only (no host GPU) |

## Cumulative mining spend

| category | USD | TAO |
|---|---|---|
| Lium rentals (`mine-*`) | ~2.66 so far (meter running @ 23.60/h; TTL cap ~141.60) | — |
| registration burns | — | 0 |
| Lium top-ups from miner | — | 0 |
| **total** | **~2.66+ (accruing)** | **0** |

Cap remaining to first crown: **~$3,858** (of $4,000) after full 6h TTL if unused early kill.
