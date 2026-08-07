# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z (ttl 10h) | H5c final chall→n80 | RUNNING |

SSH 152.236.142.234:40298 · id b14c030f-4588-4090-a704-61e1e212c86a ·
train DONE · mid50 early DONE (n40 FAIL) · final merge DONE 11:12Z ·
chall :8002 loading GPUs 4,5 · teacher :8000 + king :8001 READY ·
HF push merged in-flight · host harvest 2090851 / deadman 2090852 @19:00Z ·
known_hosts `/tmp/mine-h5c-1.known_hosts`

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T11:16:45Z | mine-h5c-1 RUNNING | matches; spent $45.64; final merge DONE + chall loading; validator untouched |
| 2026-08-07T11:06:47Z | mine-h5c-1 RUNNING | matches; spent $41.52; mid50 n40 recorded FAIL; validator untouched |
| 2026-08-07T10:31:40Z | mine-h5c-1 RUNNING | matches; spent $23.78; launched mid50 early on 4,5; validator untouched |
