# INVENTORY — mine-* pods only

**Cap: 40 lines.** Live table + last 3 reconciles. Never touch non-`mine-*`.
Pre-compaction: `archive/INVENTORY-full-2026-08-07.md`.

## Live

| name | huid | gpu | $/hr | remove_at | purpose | status |
|---|---|---|---|---|---|---|
| mine-h5c-1 | golden-hawk-dc | 8×H200 | $28.00 | 2026-08-07T19:37:46Z (ttl 10h) | H5c n80 + H6 train | RUNNING |

SSH 152.236.142.234:40298 · id b14c030f-4588-4090-a704-61e1e212c86a ·
n80 pid 43690 (0–5) · H6 train pid 46680 (6,7) · HF h5c-merged public DONE ·
host harvest/deadman @19:00Z · known_hosts `/tmp/mine-h5c-1.known_hosts` ·
**keep until H6 resolves** (not only H5c)

## Dead

| name | final spent | removed UTC | reason |
|---|---|---|---|
| mine-sim-1 | ~$252 | 2026-08-07T09:33:06Z | idle after H5b; H5c autopsy was CPU-only |

## Recent reconciles (last 3)

| UTC | lium ps mine-* | action |
|---|---|---|
| 2026-08-07T11:25:19Z | mine-h5c-1 RUNNING | matches; spent $50.18; H6 train launched GPUs 6,7; validator untouched |
| 2026-08-07T11:19:45Z | mine-h5c-1 RUNNING | matches; spent $47.57; chall READY + n80 launched; validator untouched |
| 2026-08-07T11:16:45Z | mine-h5c-1 RUNNING | matches; spent $45.64; final merge DONE + chall loading; validator untouched |
