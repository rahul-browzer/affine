# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h16-1 | cosmic-eagle-2d | 8×H200 | $28.00 | 2026-08-07T21:51:17Z | H16 TP×plmk α0.90 | n80 ~52/80 |
| mine-h17-1 | cosmic-orbit-9b | 8×H200 | $31.92 | 2026-08-07T21:56:20Z | H17 TP×kkk-af α0.90 | n80 ~38/80 |
| mine-h18-1 | golden-comet-e1 | 8×H200 | $28.00 | 2026-08-07T22:57:31Z | H18 TP×Shatoria α0.75 | bootstrap (8GPU verified) |
| mine-h19-1 | eager-eagle-c6 | 8×H200 | $28.00 | 2026-08-07T22:49:58Z | H19 TP×kkkk α0.90 | bootstrap |
| mine-h20-1 | swift-lion-ac | 8×H200 | $31.92 | 2026-08-07T22:52:59Z | H20 TP×leary α0.90 | bootstrap |

SSH: h16 .237:40109 · h17 .21:20099 · h18 .232:40307 · h19 .234:40297 · h20 .22:20100
known_hosts `/tmp/mine-h{16..20}-1.known_hosts` · **Free slot: 0**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h18-1 (zesty-hawk-bc) | ~$2 | 2026-08-07T14:57Z | dud: API 8×H200, host 2 GPUs |
| mine-h15-1 | ~$33 | 2026-08-07T14:52Z | H15 REFUTE base×2.107 |
| mine-h14-1 | ~$38 | 2026-08-07T14:49Z | H14 REFUTE base×2.044 |
| mine-h13-1 | ~$34 | 2026-08-07T14:35Z | H13 REFUTE base×2.047 |
| mine-h12-1 | ~$31 | 2026-08-07T13:49Z | H12 REFUTE base×2.017 |
| mine-h5c-1 | ~$116 | 2026-08-07T13:45Z | H6 REFUTE +0.00330 |
| mine-h11/9/10/7/8/sim | ~$425 | earlier | band/idle teardowns |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T14:58Z | h16–h20 match | H18 dud rm (~$2); rented golden-comet-e1 @$28/h; nvidia-smi COUNT=8; pipeline relaunch |
| 2026-08-07T14:53Z | h16–h20 match | H14/H15 REFUTE rm; rented h19+h20 α0.90 hedges |
| 2026-08-07T14:36Z | h14–h18 match | H13 REFUTE rm; rented dud h18 @$5.66/h |
