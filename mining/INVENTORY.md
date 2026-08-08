# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h40-1 | gentle-eagle-c9 | 8×B200 | $40.00 | ~2026-08-08T11:12Z | H40 m7×wZA ep3 | chall p218 recover |
| mine-h41-1 | zesty-lion-26 | 8×H200 | $31.92 | ~2026-08-08T11:14Z | H41 m7×wZA r32 | n80 a203 ~60/80 |
| mine-h42-1 | cosmic-matrix-bb | 8×H200 | $31.92 | ~2026-08-08T12:04Z | H42 m7×wZA lr5e6 | n80 b203 att2 |
| mine-h43-1 | noble-eagle-18 | 8×H200 | $31.92 | ~2026-08-08T12:05Z | H43 m7×wZA α64 | n80 b203 att2 |
| mine-h44-1 | zesty-lion-e0 | 8×H200 | $28.00 | ~2026-08-08T12:45Z | H44 clipL1≥0.08 | training |

SSH: h40 .147:20300 · h41 .19:20099 · h42 .21:20100 · h43 .22:20099 ·
h44 .232:40298 · known_hosts `/tmp/mine-h{40,41,42,43,44}-1.known_hosts` ·
**Free: 0**. Cap 5. Burn ~$163.8/h mining.

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-h39-1 | ~$52 | 2026-08-08T00:43Z | H39 REFUTE m=+0.00544 |
| mine-h44-1 (brave-fox-27) | ~$0.1 | 2026-08-08T00:44Z | REJECT 4 GPU @$11.60 |
| mine-h38-1 | ~$61 | 2026-08-08T00:03Z | H38 REFUTE m=−0.00037 |
| mine-h37-1 | ~$61 | 2026-08-08T00:03Z | H37 REFUTE m=−0.00088 |
| mine-h36-1 | ~$59 | 2026-08-07T23:13Z | H36 REFUTE m=+0.00052 |
| mine-h35-1 | ~$59 | 2026-08-07T23:10Z | H35 REFUTE m=+0.01602 |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-08T00:49Z | h40–h44 match | dual-sim kill h42/h43; H40 p218 |
| 2026-08-08T00:46Z | h40–h44 match | H39 rm+H44 rent; H40 p217 recover |
| 2026-08-08T00:20Z | h39–h43 match | H40 chall recover p216 (isolated TCACHE) |
