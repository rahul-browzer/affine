# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $118,922.133 | 2026-08-12T04:10Z |
| cumulative mining spend | ~$78,676 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T04:10Z |
| **available for mining** | **~$108,922** (balance − $10,000 floor) | 2026-08-12T04:10Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T04:10Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T04:10Z | 118922.133 | p2184 no rent (200-iter SKIP_PID_LOCK burst 8×=0); burn **$180.25/h**; Δ−$21 vs p2183 |
| 2026-08-12T04:06Z | 118943.077 | p2183 no rent (150-iter SKIP_PID_LOCK burst 8×=0); burn **$180.25/h**; Δ−$42 vs p2182 |
| 2026-08-12T04:00Z | 118984.780 | p2182 no rent (burst+API 8×=0); crown TTL+12h; burn **$180.25/h**; Δ−$21 vs p2181 |
| 2026-08-12T03:54Z | 119005.577 | p2181 no rent (API 8×=0); R9+R2bn gate; burn **$180.25/h**; Δ−$21 vs p2180 |
| 2026-08-12T03:52Z | 119026.214 | p2180 no rent (API 8×=0); R2bn alloy→n80 armed; burn **$180.25/h**; Δ$0 vs p2179 |
| 2026-08-12T03:47Z | 119026.214 | p2179 no rent (API 8×=0); R2bn alloy prefetch; burn **$180.25/h**; Δ−$21 vs p2178 |
| 2026-08-12T03:41Z | 119047.301 | p2178 no rent (API 8×=0); R3b Soft/Dead+QUEUE prune; burn **$180.25/h**; Δ−$21 vs p2177 |
| 2026-08-12T03:38Z | 119068.223 | p2177 no rent (API 8×=0 burst); R12 Soft/Dead TTL-fix; burn **$180.25/h**; Δ−$21 vs p2176 |
| 2026-08-12T03:34Z | 119088.759 | p2176 no rent (API 8×=0); R2bm REFUTE harvest; burn **$180.25/h**; Δ$0 vs p2175 |
| 2026-08-12T03:31Z | 119088.759 | p2175 no rent (API 8×=0); R11 REFUTE→R12 warm-arm; burn **$180.25/h**; Δ−$21 vs p2174 |
