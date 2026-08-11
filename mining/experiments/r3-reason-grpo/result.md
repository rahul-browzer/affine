# R3 — results log

## p2054 — rented mine-r3-grpo-1 (8×B300)

- **When:** 2026-08-11T16:29:38Z
- **Node:** `noble-matrix-b8` → pod `golden-hawk-ff`
- **id:** `d55eec0f-6dc6-4e07-a3fb-602395dca847`
- **Config:** 8×B300 @$64.00/h · `--ttl 24h` → removal 2026-08-12T16:29:36Z
- **SSH:** `ssh root@204.9.206.245 -p 40051` (verified: 8×B300 SXM6, disk 1.1T)
- **Axis:** R3 GRPO/REINFORCE on Reason (not another R2 board parent)
- **Fleet after rent:** mine-crown-1 B200 $52.25 + mine-r3-grpo-1 B300 $64 = **$116.25/h**
  (B300 floor target $833/h; `lium ls --gpu B300 --count 8` → **0 left**)
- **Next:** bootstrap teacher+king+train stack on this pod (do not idle).
