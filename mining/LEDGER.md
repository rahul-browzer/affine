# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $116,430.022 | 2026-08-12T13:30Z |
| cumulative mining spend | ~$81,171 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T13:30Z |
| **available for mining** | **~$106,430** (balance − $10,000 floor) | 2026-08-12T13:30Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (3 pods) | **$180.25/h** (2×B300 $64 + 1×B200 $52.25) · **vs floor $833/h** | 2026-08-12T13:30Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T13:30Z | 116430.022 | p2254 no rent (8×=0); HF purge −281 GiB; burn **$180.25/h**; Δ−$23 vs p2253 |
| 2026-08-12T13:24Z | 116453.164 | p2253 no rent (8×=0); R27 warm on R4; burst→R28; burn **$180.25/h**; Δ−$23 vs p2252 |
| 2026-08-12T13:12Z | 116497.491 | p2252 no rent (8×=0); R23 warm on R3; R19 harvest; burn **$180.25/h**; Δ−$21 vs p2251 |
| 2026-08-12T13:06Z | 116518.564 | p2251 tore dead R25 ($40) + CREATION_FAILED R23; burn **$180.25/h**; Δ−$47 vs p2250 |
| 2026-08-12T13:00Z | 116565.372 | p2250 no rent (8×=0); R25 n80 LIVE on R3; burn **$220.25/h**; Δ−$24 vs p2249 |
| 2026-08-12T12:54Z | 116589.488 | p2249 no rent (8×=0); R33 REFUTE→R22 warm crown; burst next R23; burn **$220.25/h**; Δ−$24 vs p2248 |
| 2026-08-12T12:48Z | 116613.669 | p2248 no rent (8×=0); R25 HF complete→chall load on R3; burn **$220.25/h**; Δ−$24 vs p2247 |
| 2026-08-12T12:40Z | 116637.862 | p2247 no rent (8×=0); R24 n80 done; R25 reboot-failed+HF migrate; burn **$220.25/h**; Δ−$72 vs p2246 |
| 2026-08-12T12:10Z | 116807.400 | p2246 no rent (8×=0); R25 chall warm→n80 gather; burn **$220.25/h**; Δ−$48 vs p2245 |
| 2026-08-12T11:56Z | 116855.752 | p2245 no rent (8×=0); R25 merge→serve+Triton seed; burn **$220.25/h**; Δ−$24 vs p2244 |
