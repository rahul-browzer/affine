# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h18-1 | golden-comet-e1 | 8×H200 | $28.00 | 2026-08-07T22:57:31Z | H18 TP×Shatoria α0.75 | n80 retry @15:27Z |
| mine-h19-1 | eager-eagle-c6 | 8×H200 | $28.00 | 2026-08-07T22:49:58Z | H19 TP×kkkk α0.90 | n80 @15:27Z |
| mine-h20-1 | swift-lion-ac | 8×H200 | $31.92 | 2026-08-07T22:52:59Z | H20 TP×leary α0.90 | n80 retry (false probe cleared) |

SSH: h18 .232:40307 · h19 .234:40297 · h20 .22:20100
known_hosts `/tmp/mine-h{18,19,20}-1.known_hosts` · **Free slots: 2**. Cap 5.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h17-1 | ~$45 | 2026-08-07T15:19Z | H17 REFUTE m=−0.0037 base×1.133 |
| mine-h16-1 | ~$41 | 2026-08-07T15:19Z | H16 REFUTE m=+0.0097 base×1.146 |
| mine-h18-1 (zesty-hawk-bc) | ~$2 | 2026-08-07T14:57Z | dud: API 8×H200, host 2 GPUs |
| mine-h15-1 | ~$33 | 2026-08-07T14:52Z | H15 REFUTE base×2.107 |
| mine-h14-1 | ~$38 | 2026-08-07T14:49Z | H14 REFUTE base×2.044 |
| mine-h13/12/5c/11… | ~$600 | earlier | band/idle teardowns |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T15:29Z | h18–h20 match | H16/H17 REFUTE rm; recovered H18 teacher / H19 king / H20 chall; n80 relaunched; 2 free |
| 2026-08-07T14:58Z | h16–h20 match | H18 dud rm; rented golden-comet-e1 @$28/h; COUNT=8 |
| 2026-08-07T14:53Z | h16–h20 match | H14/H15 REFUTE rm; rented h19+h20 α0.90 |
