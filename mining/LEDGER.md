# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Rate cap **$20,000/day = $833/h** (operator 2026-08-08).
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $178,362.62 | 2026-08-09T10:42Z |
| cumulative mining spend | ~$19,372 (Δ bal + F38~$64) | 2026-08-09T10:42Z |
| **available for mining** | **~$168,363** (balance − $10,000 floor) | 2026-08-09T10:42Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (8 pods) | ~$223.4/h | 2026-08-09T10:42Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-09T10:42Z | 178362.62 | rm mine-f38-1 after REFUTE (spent ~$64); burn ~$223.4/h |
| 2026-08-09T10:31Z | 178428.66 | rm mine-f43-1 (spent ~$62) after REFUTE; burn ~$246.6/h |
| 2026-08-09T10:28Z | 178465.01 | rm orphan mine-f48-1 (spent ~$4.85); burn briefly ~$312→$279 |
| 2026-08-09T10:26Z | 178466.67 | no rent/rm; F41 rearm only; burn ~$278.6/h |
| 2026-08-09T10:14Z | 178576.30 | no rent/rm; burn accruing ~$278.6/h |
| 2026-08-09T10:07Z | 178610.69 | rent mine-f47-1 8×H200 @$31.92/h TTL12h |
| 2026-08-09T10:03Z | 178641.11 | rent mine-f46-1 8×H200 @$23.20/h TTL12h |
| 2026-08-09T09:58Z | 178673.40 | no rent/rm; F40 recover264 |
| 2026-08-09T09:54Z | 178704.16 | no rent/rm; F44 train live |
| 2026-08-09T09:47Z | 178734.95 | no rent/rm; F44 teacher recover |
