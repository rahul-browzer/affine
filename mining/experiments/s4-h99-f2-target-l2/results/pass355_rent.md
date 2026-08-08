# H99/F2 pass355 — first Target-Λ2 family screen

## Facts
- Harvested 1059 high-Λ2 z_A (min Λ2≥0.02, z≤300) from 99 public duels;
  mean Λ2=0.086; overlap with clip-L1 set only 35% (688 unique turns).
- Scaffolded `s4-h99-f2-target-l2` (Tok-init r=16/α32 thought-only SFT).
- First rent `cosmic-wolf-e2` H200 catalog-8 → **COUNT=7** → bootstrap abort →
  `lium rm mine-f2-1` (zesty-orbit-24) only.
- Replaced with B200 `calm-orbit-5c` → pod `zesty-orbit-85` /
  `2f0373fc-5b85-4585-bd70-14e17ba68a23` @$40/h `--ttl 12h`. COUNT=8 verified.
- SSH `150.136.71.147:20295` kh `/tmp/mine-f2-1.known_hosts`.
- Stack upload + bootstrap pid=942; form/retry/preempt armed.
- HF salvage: `unconst/Affine-5czsc2fc98-h99-{lora,merged}`.

## Next
Await bootstrap→train→merge→n80. Screen >+0.015 → CONFIRM k=4.
