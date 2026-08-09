# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $178,036.88 | 2026-08-09T11:38Z |
| cumulative mining spend | ~$19,698 (Δ bal from p526 baseline) | 2026-08-09T11:38Z |
| **available for mining** | **~$168,037** (balance − $10,000 floor) | 2026-08-09T11:38Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | ~$111/h | 2026-08-09T11:38Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T11:38Z | 178036.88 | rm mine-f40-1 after REFUTE (spent ~$97); burn ~$111/h |
| 2026-08-09T11:33Z | 178062.02 | rm mine-f41-1 after REFUTE (spent ~$90); burn ~$139/h |
| 2026-08-09T11:25Z | 178089.76 | rm mine-f47-1 after REFUTE (spent ~$41); burn ~$167/h |
| 2026-08-09T11:21Z | 178118.47 | no rent/rm; F44/F46 recover+d203; burn ~$199/h |
| 2026-08-09T11:15Z | 178176.04 | rm mine-f39-1 after REFUTE; burn ~$199/h |
| 2026-08-09T11:01Z | 178238.13 | no rent/rm; F42 merge+n80; burn ~$223.4/h (Δ−$124 from 10:42) |
| 2026-08-09T10:42Z | 178362.62 | rm mine-f38-1 after REFUTE (spent ~$64); burn ~$223.4/h |
| 2026-08-09T10:31Z | 178428.66 | rm mine-f43-1 (spent ~$62) after REFUTE; burn ~$246.6/h |
| 2026-08-09T10:28Z | 178465.01 | rm orphan mine-f48-1 (spent ~$4.85); burn briefly ~$312→$279 |
| 2026-08-09T10:26Z | 178466.67 | no rent/rm; F41 rearm only; burn ~$278.6/h |
