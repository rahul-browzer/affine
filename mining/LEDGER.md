# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$28,000**; pre-crown mining spend ≤ **$4,000**.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $33,113.90 | 2026-08-07T13:38Z |
| cumulative mining spend | ~$760 (`mine-sim-1` ~$252 + h5c ~$112 + h7 ~$28 + h8 ~$27 + h9 ~$48 + h10 ~$40 + h11 ~$30 + h12 ~$26 + h13/h14 accruing) | 2026-08-07T13:38Z |
| headroom to floor | ~$5,114 | |
| headroom to $4,000 cap | ~$3,240 | |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-07T13:38Z | 33113.90 | rm h9(~$48)+h11(~$30); rented mine-h14-1 8×H200 @$31.92/h ttl8h (max~$255); ~$760 cum; floor OK |
| 2026-08-07T13:32Z | 33133.65 | rented mine-h13-1 8×H200 @$31.92/h ttl8h (max~$255); H10 rm'd (~$40); ~$670 cum; floor OK |
| 2026-08-07T13:31Z | 33133.65 | lium rm mine-h10-1 after H10 REFUTE base×1.983 (no new rent yet) |
| 2026-08-07T13:14Z | 33207.10 | h5c+h9+h10+h11+h12 accruing (~$620 cum); H13/H14 retry hardened (no rent); floor OK |
| 2026-08-07T13:10Z | 33225.35 | h5c+h9+h10+h11+h12 accruing (~$610 cum); H14 staged no rent; H12 n80 live; floor OK |
| 2026-08-07T13:05Z | 33225.35 | h5c+h9+h10+h11+h12 accruing (~$590 cum); H6/H10/H11 retry watchers (no rent); floor OK |
| 2026-08-07T13:02Z | 33242.62 | h5c+h9+h10+h11+h12 accruing (~$570 cum); H12 false-refuse recovery (no rent); floor OK |
| 2026-08-07T12:59Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$545 cum); H9 n80 retry (no rent); floor OK |
| 2026-08-07T12:56Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$520 cum); H13 staged no rent; floor OK |
| 2026-08-07T12:51Z | 33279.69 | h5c+h9+h10+h11+h12 accruing (~$500 cum); H12 pivot plmk (no new rent); floor OK |
