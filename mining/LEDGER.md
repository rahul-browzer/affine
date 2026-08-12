# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $117,581.794 | 2026-08-12T09:28Z |
| cumulative mining spend | ~$80,019 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-12T09:28Z |
| **available for mining** | **~$107,582** (balance − $10,000 floor) | 2026-08-12T09:28Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (4 pods) | **$220.25/h** (2×B300 $64 + 2×B200 $52.25+$40) · **vs floor $833/h** | 2026-08-12T09:28Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-12T09:28Z | 117581.794 | p2217 no new rent (8×=0; R24 post KING→guass; burst**3682673**); burn **$220.25/h**; Δ−$24 vs p2216 |
| 2026-08-12T09:24Z | 117605.928 | p2216 no new rent (8×=0; R25 guass DONE enforce-eager; teacher restore); burn **$220.25/h**; Δ−$24 vs p2215 |
| 2026-08-12T09:14Z | 117654.475 | p2215 no new rent (8×=0; R25 guass retarget; burst**3652502** next=R27); burn **$220.25/h**; Δ−$24 vs p2214 |
| 2026-08-12T09:07Z | 117678.702 | p2214 no new rent (8×=0; R25 guass-armed; burst**3644233** next=R27); burn **$220.25/h**; Δ−$23 vs p2213 |
| 2026-08-12T09:03Z | 117701.494 | p2213 no new rent (8×=0; R26 warm-arm on crown; burst**3638049** next=R27); burn **$220.25/h**; Δ−$26 vs p2212 |
| 2026-08-12T08:58Z | 117727.103 | p2212 no new rent (8×=0; burst**3623101** next=R26); R21 warm-arm on R4; burn **$220.25/h**; Δ−$47 vs p2211 |
| 2026-08-12T08:48Z | 117774.314 | p2211 **RENTED** mine-r25-hitemp-1 8×B200 $40/h; R20 REFUTE harvest; burn **$220.25/h**; Δ−$21 vs p2210 |
| 2026-08-12T08:43Z | 117795.192 | p2210 no rent (8×=0; burst**3557663**); R17 REFUTE harvest; burn **$180.25/h**; Δ$0 vs p2209 |
| 2026-08-12T08:40Z | 117795.192 | p2209 no rent (8×=0; burst**3557663**); R17 n80 vs guass relaunch; burn **$180.25/h**; Δ−$42 vs p2208 |
| 2026-08-12T08:29Z | 117857.915 | p2208 no rent (8×=0; burst**3557663**); R3 guass retarget armed; burn **$180.25/h**; Δ$0 vs p2207 |
