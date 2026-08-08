# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h49-1 | zesty-shark-45 | 8×H200 | $33.81 | ~2026-08-08T13:59Z | H49 m7×wZA α4 | n80 b203 ~45/80 |
| mine-h50-1 | eager-hawk-5b | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H50 m7×wZA lr7.5e-6 | n80 a203 ~21/80 |
| mine-h51-1 | brave-lion-47 | 8×H200 | $28.00 | ~2026-08-08T15:03Z | H51 m7×wZA α16 | n80 a203 started |
| mine-h52-1 | noble-wolf-4b | 8×H200 | $31.92 | ~2026-08-08T15:05Z | H52 m7×wZA lr6e-6 | n80 a203 ~11/80 |
| mine-h53-1 | zesty-raven-e1 | 8×H200 | $31.92 | ~2026-08-08T15:20Z | H53 m7×wZA lr4e-6 | chall load→n80 |

SSH: h49 .54:40300 · h50 .237:40499 · h51 .232:40300 · h52 .18:20099 ·
h53 .22:20100 · known_hosts `/tmp/mine-h{49,50,51,52,53}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$153.7/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h45-1 | ~$55 | 2026-08-08T03:20Z | H45 REFUTE m=+0.00819 |
| mine-h46-1 | ~$52 | 2026-08-08T03:04Z | H46 REFUTE m=+0.00802 |
| mine-h48-1 | ~$45 | 2026-08-08T03:01Z | H48 REFUTE band×1.269 |
| mine-h47-1 | ~$46 | 2026-08-08T03:01Z | H47 REFUTE m=+0.00463 |
| mine-h44-1 | ~$34 | 2026-08-08T01:58Z | H44 REFUTE m=−0.00017 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T03:59Z | h49–h53 match | H51 n80 a203; H53 merge→chall; H49~45 H50~21 H52~11 |
| 2026-08-08T03:52Z | h49–h53 match | H52 n80 a203; H51 chall EngineDead→relaunch |
| 2026-08-08T03:44Z | h49–h53 match | H50/H51 chall→n80 a203; H49~17/80 |
