# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z (ttl 10h) | H5c train→n80 + mid50 early | RUNNING |

SSH 152.236.142.234:40298 · id b14c030f-4588-4090-a704-61e1e212c86a ·
train 2820 (GPUs 6,7) step~55/99 · mid-salvage 5194 · pipe 10642 ·
**mid50 early 21557** merge→n40 on GPUs 4,5 · teacher :8000 + king :8001 READY ·
host harvest 2090851 / deadman 2090852 @19:00Z · known_hosts `/tmp/mine-h5c-1.known_hosts`

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T10:31:40Z | mine-h5c-1 RUNNING | matches; spent $23.78; launched mid50 early on 4,5; validator untouched |
| 2026-08-07T10:27:48Z | mine-h5c-1 RUNNING | matches; spent $23.26; mid50 salvaged; validator pods untouched |
| 2026-08-07T10:01:07Z | mine-h5c-1 RUNNING | matches; spent $10.88; train step17/99; validator pods untouched |
