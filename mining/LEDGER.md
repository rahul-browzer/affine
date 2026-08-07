# LEDGER — money in / money out

Floor rules: Lium balance ≥ $28,000 always; cumulative mining spend ≤ $4,000 until first crown.

## Balances (latest)

| UTC | Lium USD | miner free τ | miner stake τ | notes |
|---|---|---|---|---|
| 2026-08-06T23:57:49Z | 34609.61 | 10.000000 | 0 | mine-sim-1 spent $25.38; H2 sim launched; no new rental |
| 2026-08-06T23:51:51Z | 34617.36 | 10.000000 | 0 | mine-sim-1 spent $22.59; H2 merge DONE + re-serve; no new rental |
| 2026-08-06T23:42:03Z | 34632.93 | 10.000000 | 0 | mine-sim-1 spent $19.17; H2 pipeline started; no new rental |
| 2026-08-06T23:37:31Z | 34640.74 | 10.000000 | 0 | mine-sim-1 spent $17.39; Stage3 MET; no new rental |
| 2026-08-06T23:32:11Z | 34648.42 | 10.000000 | 0 | mine-sim-1 spent $15.29; shared validator burn continues |
| 2026-08-06T23:00:03Z | 34703.01 | 10.000000 | 0 | mine-sim-1 spent $2.66; balance flat vs 22:57 (meter lag vs validator burn) |
| 2026-08-06T22:57:35Z | 34703.01 | 10.000000 | 0 | mine-sim-1 live @ $23.60/h + validator burn |
| 2026-08-06T22:51:06Z | 34709.52 | 10.000000 | 0 | validator pods burning shared credit; mining spend still $0 |
| 2026-08-06T22:47:00Z | 34715.32 | 10.000000 | 0 | opening snapshot; no mining spend yet |

## Movements

| UTC | kind | amount | from → to | running Lium USD | running miner τ free | note |
|---|---|---|---|---|---|---|
| 2026-08-06T23:57:49Z | observe | mine-sim spent $25.38 | Lium → mine-sim-1 | 34609.61 | 10.000 | H2 serve READY; sim duel nohup'd; floor OK |
| 2026-08-06T23:51:51Z | observe | mine-sim spent $22.59 | Lium → mine-sim-1 | 34617.36 | 10.000 | H2 merge complete; re-serve started; floor OK |
| 2026-08-06T23:42:03Z | observe | mine-sim spent $19.17 | Lium → mine-sim-1 | 34632.93 | 10.000 | H2 download→merge nohup; no new rental; floor OK |
| 2026-08-06T23:37:31Z | observe | mine-sim spent $17.39 | Lium → mine-sim-1 | 34640.74 | 10.000 | Stage3 gate MET (+0.0689); engines kept hot |
| 2026-08-06T22:47:00Z | open | — | — | 34715.32 | 10.000 | coldkey funded τ10 prior to run; Lium shared with validator |
| 2026-08-06T22:51:06Z | observe | — | — | 34709.52 | 10.000 | -$5.80 vs open ≈ validator burn; no mine-* rental |
| 2026-08-06T22:53:18Z | rent | $23.60/h | Lium credit → mine-sim-1 (8×H200) | 34709.52 (pre) | 10.000 | `lium up` H200; name `mine-sim-1`; TTL 6h → remove 2026-08-07T04:53:17Z; max TTL ≈ $141.60; floor OK |
| 2026-08-06T22:57:35Z | observe | ~$6.5 vs 22:51 | shared burn + mine-sim | 34703.01 | 10.000 | includes ~4 min mine-sim (~$1.6) + validator pods |
| 2026-08-06T23:00:03Z | observe | mine-sim spent $2.66 | Lium → mine-sim-1 | 34703.01 | 10.000 | no new rental; harness upload only (no host GPU) |
| 2026-08-06T23:32:11Z | observe | mine-sim spent $15.29 | Lium → mine-sim-1 | 34648.42 | 10.000 | serve+gate; drop vs 23:00 ≈ validator burn + mine-sim |

## Cumulative mining spend

| category | USD | TAO |
|---|---|---|
| Lium rentals (`mine-*`) | ~25.38 so far (meter running @ 23.60/h; TTL cap ~141.60) | — |
| registration burns | — | 0 |
| Lium top-ups from miner | — | 0 |
| **total** | **~25.38+ (accruing)** | **0** |

Cap remaining to first crown: **~$3,858** (of $4,000) after full 6h TTL if unused early kill.
