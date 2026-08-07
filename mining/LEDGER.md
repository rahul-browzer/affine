# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$28,000**; pre-crown mining spend ≤ **$4,000**.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $33,225.35 | 2026-08-07T13:05Z |
| cumulative mining spend | ~$590 (`mine-sim-1` ~$252 + h5c ~$98 + h7 ~$28 + h8 ~$27 + h9 ~$32 + h10 ~$30 + h11 ~$16 + h12 ~$12) | 2026-08-07T13:05Z |
| headroom to floor | ~$5,225 | |
| headroom to $4,000 cap | ~$3,410 | |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-07T13:05Z | 33225.35 | h5c+h9+h10+h11+h12 accruing (~$590 cum); H6/H10/H11 retry watchers (no rent); floor OK |
| 2026-08-07T13:02Z | 33242.62 | h5c+h9+h10+h11+h12 accruing (~$570 cum); H12 false-refuse recovery (no rent); floor OK |
| 2026-08-07T12:59Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$545 cum); H9 n80 retry (no rent); floor OK |
| 2026-08-07T12:56Z | 33261.64 | h5c+h9+h10+h11+h12 accruing (~$520 cum); H13 staged no rent; floor OK |
| 2026-08-07T12:51Z | 33279.69 | h5c+h9+h10+h11+h12 accruing (~$500 cum); H12 pivot plmk (no new rent); floor OK |
| 2026-08-07T12:47Z | 33297.79 | h5c+h9+h10+h11+h12 accruing (~$480 cum); H6 train DONE + mid50 gate; H10 merge DONE; no new rent; floor OK |
| 2026-08-07T12:43Z | 33314.80 | rented mine-h12-1 8×H200 @$28/h ttl8h (max~$224); H12 boot; 5/5 (~$460 cum); floor OK |
| 2026-08-07T12:38Z | 33330.62 | h5c+h9+h10+h11 accruing (~$430 cum); no new rent; H11 resume + mid50 retry; floor OK |
| 2026-08-07T12:33Z | 33344.93 | H8 REFUTE rm (~$27); rented mine-h11-1 8×H200 @$28/h ttl8h (max~$224); h5c+h9+h10+h11 (~$415 cum); floor OK |
| 2026-08-07T12:27Z | 33361.67 | H7 REFUTE; rm mine-h7-1 (~$28 final); h5c+h8+h9+h10 accruing (~$414 cum); floor OK |
