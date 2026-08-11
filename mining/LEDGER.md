# LEDGER — money in / money out

**Cap: 40 lines.** Totals + last 10 movements. Older → `archive/`.
Floor ≥ **$10,000**. Mining B300 burn floor **>$20,000/day = $833/h**.
Live burn = Σ $/h over `mine-*` pods every pass.

## Totals

| item | value | as of |
|---|---|---|
| Lium balance | $120,796.951 | 2026-08-11T20:39Z |
| cumulative mining spend | ~$76,791 (Δ bal from p526 baseline; includes shared-acct Δ) | 2026-08-11T20:39Z |
| **available for mining** | **~$110,797** (balance − $10,000 floor) | 2026-08-11T20:39Z |
| validator burn (never starve) | ~$70/h — eval $64 + bench $5.80 | 2026-08-08T08:52Z |
| miner burn (2 pods) | **$116.25/h** (B300 $64 + B200 $52.25) · **vs floor $833/h** | 2026-08-11T20:39Z |
| miner coldkey free | τ10.000000 | unchanged |
| miner stake | 0 positions | |
| registrations / submissions | 0 / 0 | |

## Recent movements

| UTC | Lium USD | event |
|---|---|---|
| 2026-08-11T20:39Z | 120796.951 | p2103 R2bb ckp333 armed on crown + fleet-rent refresh @10s (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2102 |
| 2026-08-11T20:35Z | 120796.951 | p2102 R2ba WEAK + R28 HiLR-GRPO uploader + fleet-boot @10s (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2101 |
| 2026-08-11T20:30Z | 120812.089 | p2101 R27 BigG-GRPO (G=16) uploader + fleet-boot @10s poll (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2100 |
| 2026-08-11T20:27Z | 120827.954 | p2100 R26 LoTemp-GRPO uploader + fleet-boot @10s poll (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2099 |
| 2026-08-11T20:25Z | 120827.954 | p2099 R25 HiTemp-GRPO uploader + fleet-boot @10s poll (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2098 |
| 2026-08-11T20:21Z | 120843.447 | p2098 R24 longctx-GRPO uploader + fleet-boot @10s poll (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2097 |
| 2026-08-11T20:17Z | 120858.998 | p2097 R23 diane-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$16 vs p2096 |
| 2026-08-11T20:14Z | 120874.58 | p2096 R22 golden-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ$0 vs p2095 |
| 2026-08-11T20:10Z | 120874.58 | p2095 R21 pandora-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2094 |
| 2026-08-11T20:07Z | 120890.00 | p2094 R20 kevin-GRPO uploader + fleet-boot (no rent; B300×8=0); burn **$116.25/h**; Δ−$15 vs p2093 |
