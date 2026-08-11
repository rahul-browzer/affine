# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,843.447 | 2026-08-11T20:21Z |
| cumulative mining spend | ~$76,745 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T20:21Z |
| **available for mining** | **~$110,843** (balance − $10,000 floor) | 2026-08-11T20:21Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T20:21Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T20:21Z | 120843.447 | p2098 R24 longctx-GRPO uploader + fleet-boot @10s poll (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2097 |
| 2026-08-11T20:17Z | 120858.998 | p2097 R23 diane-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2096 |
| 2026-08-11T20:14Z | 120874.58 | p2096 R22 golden-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2095 |
| 2026-08-11T20:10Z | 120874.58 | p2095 R21 pandora-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2094 |
| 2026-08-11T20:07Z | 120890.00 | p2094 R20 kevin-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2093 |
| 2026-08-11T20:05Z | 120904.84 | p2093 R19 Talent-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2092 |
| 2026-08-11T20:02Z | 120904.84 | p2092 R18 sbs-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2091 |
| 2026-08-11T19:59Z | 120921.18 | p2091 R17 coder-RL uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2090 |
| 2026-08-11T19:56Z | 120921.18 | p2090 R2az REFUTE + R2ba awesome-v10 armed (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2089 |
| 2026-08-11T19:52Z | 120936.63 | p2089 R16 golden-RL uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2088 |
