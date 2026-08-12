# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $119,610.731 | 2026-08-12T01:29Z |
| cumulative mining spend | ~$77,983 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T01:29Z |
| **available for mining** | **~$109,611** (balance − $10,000 floor) | 2026-08-12T01:29Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-12T01:29Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T01:29Z | 119610.731 | p2153 no rent (API B300/B200×8=0); R3+R8 post→ckp333; burn **$180.25/h**; Δ$0 vs p2152 |
| 2026-08-12T01:26Z | 119610.731 | p2152 no rent (API B300/B200×8=0); reign5 retarget armed; burn **$180.25/h**; Δ−$21 vs p2151 |
| 2026-08-12T01:17Z | 119652.351 | p2151 no rent (API B300/B200×8=0); R6b REFUTE→R8 warm-arm; burn **$180.25/h**; Δ−$21 vs p2150 |
| 2026-08-12T01:12Z | 119673.238 | p2150 no rent (API B300/B200×8=0); killed dual snatcher; R6b n80~28/80; burn **$180.25/h**; Δ−$21 vs p2149 |
| 2026-08-12T01:07Z | 119694.227 | p2149 no rent (API B300/B200×8=0); R6b merge+stale-chall kill; R2bj n80~8/80; burn **$180.25/h**; Δ−$20 vs p2148 |
| 2026-08-12T01:04Z | 119713.950 | p2148 no rent (API B300/B200×8=0); R2bj reload dead→relaunched chall load; burn **$180.25/h**; Δ−$22 vs p2147 |
| 2026-08-12T00:58Z | 119736.005 | p2147 no rent (API B300/B200×8=0); R2bi UNSERVABLE→R2bj saysth armed; burn **$180.25/h**; Δ−$21 vs p2146 |
| 2026-08-12T00:54Z | 119756.763 | p2146 no rent (API B300/B200×8=0); R2bi self-PID fix→mt2 chall load; burn **$180.25/h**; Δ$0 vs p2145 |
| 2026-08-12T00:51Z | 119756.763 | p2145 no rent (API B300/B200×8=0); R2bh REFUTE→R2bi armed; burn **$180.25/h**; Δ−$63 vs p2144 |
| 2026-08-12T00:36Z | 119819.501 | p2144 no rent (API B300/B200×8=0); R9 warm-arm crown 6–7; burn **$180.25/h**; Δ−$42 vs p2143 |
