# H142/F47 pass520 — raw Qwen3-Coder rented

## Context
- Fleet F38–F46 healthy (F38 n80 ~15→19/80; F43 ~31→38/80; F40 n80
  started 10:04Z post recover264; F39/F41/F42/F44/F45 train; F46 boot).
  Free slot → orthogonal **F47** (non-Albedo base; not another RL/DPO cell).
- F47 = unmodified `Qwen/Qwen3-Coder-30B-A3B-Instruct` @ `b2cff646…`
  (~61 GB, no auto_map) raw n80 vs Tok331102.

## Rent
- Catalog `5aed9800…` / cosmic-fox-ec → live `golden-matrix-bb` /
  `5ad24fcf…` **mine-f47-1** 8×H200 @$31.92/h `--ttl 12h`
  (remove_at ≈2026-08-09T22:07:03Z). **COUNT=8** verified via SSH.
- SSH `38.255.28.18:20099` kh `/tmp/mine-f47.kh`.
- Stack upload + bootstrap pid=937; form + retry(d203first) armed.
- soft=21:07:03Z deadman=21:37:03Z. EXP=`s4-h142-f47-raw-qwen3-coder`.

## Fleet at rent
- Burn ~$278.6/h (10 mine-*) ≪ $833/h. Balance ~$178,611.
