# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$28,000**; pre-crown mining spend ≤ **$4,000**.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $33,207.10 | 2026-08-07T13:14Z |
| cumulative mining spend | ~$620 (`mine-sim-1` ~$252 + h5c ~$100 + h7 ~$28 + h8 ~$27 + h9 ~$34 + h10 ~$32 + h11 ~$18 + h12 ~$13 + accruing) | 2026-08-07T13:14Z |
| headroom to floor | ~$5,207 | |
| headroom to $4,000 cap | ~$3,380 | |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-07T13:14Z | 33207.10 | h5c+h9+h10+h11+h12 accruing (~$620 cum); H13/H14 retry hardened (no rent); floor OK |
| 2026-08-07T13:10Z | 33225.35 | h5c+h9+h10+h11+h12 accruing (~$610 cum); H14 staged no rent; H12 n80 live; floor OK |
| 2026-08-07T13:05Z | 33225.35 | h5c+h9+h10+h11+h12 accruing (~$590 cum); H6/H10/H11 retry watchers (no rent); floor OK |
| 2026-08-07T13:02Z | 33242.62 | h5c+h9+h10+h11+h12 accruing (~$570 cum); H12 false-refuse recovery (no rent); floor OK |
| 2026-08-07T12:59Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$545 cum); H9 n80 retry (no rent); floor OK |
| 2026-08-07T12:56Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$520 cum); H13 staged no rent; floor OK |
| 2026-08-07T12:51Z | 33279.69 | h5c+h9+h10+h11+h12 accruing (~$500 cum); H12 pivot plmk (no new rent); floor OK |
| 2026-08-07T12:47Z | 33297.79 | h5c+h9+h10+h11+h12 accruing (~$480 cum); H6 train DONE + mid50 gate; H10 merge DONE; no new rent; floor OK |
| 2026-08-07T12:43Z | 33314.80 | rented mine-h12-1 8×H200 @$28/h ttl8h (max~$224); H12 boot; 5/5 (~$460 cum); floor OK |
| 2026-08-07T12:38Z | 33330.62 | h5c+h9+h10+h11 accruing (~$430 cum); no new rent; H11 resume + mid50 retry; floor OK |
