# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `subnet.weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest ready |
| Lium balance | ~$124,172 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b train/merge | **DONE** · chall `/tmp/r1b_lora_merged` |
| R1b n80 #2 | **RUNNING** · 25/80 @20:21Z · timeout 600s×5 · pid **95336** |
| R1c train | **RUNNING** · 3/132 @~40s/it · pid **96239**/96252 |
| R1c merge waiter | **ARMED** · pid **97305** · waits train + R1b dec; SKIP if R1b ≥1.5× |
| R1b→R1c chain | **ARMED** · pid **83033** · skip-relaunch if train alive/done |
| R1c data | **READY** · nsup100 **176** rows |
| R2 prefetch/premerge | **DONE** · max_abs_delta=0.277 · α→n80 waiter **85408** |
| HF pre-push | `unconst/Affine-5czsc2fc98-r1lora` **public** @ `569a68be…` (not for submit) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1b n80 + R1c train + merge/R2 waiters |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536`.
- R1b n80: log `/root/logs/r1b_lora_reason_sim.log` → decision `/root/affine_data/r1b_lora_decision.json`.
- R1c train: log `/root/logs/r1c_train.log` → `/root/r1_out/lora_tok_high_reason_r1c` · stamp `r1c_train.done`.
- R1c merge: log `/root/logs/r1c_merge_reload.log` → `r1c_lora_decision.json` (gated on R1b dec).
- R2 n80 waiter waits R1 lane → `/root/affine_data/r2_alpha_decision.json`.

## Blocked

- Do **not** submit `r1lora@569a68be` — headroom 0.035×(3·SE) vs bar 1.5×.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge before every ~65 GiB push.
- Never `pkill -f` over SSH; kill by PID / pidfile only.

## Next action

**Harvest** `/root/affine_data/r1b_lora_decision.json`. If headroom ≥ 1.5× → Stage-5 (kill R1c; merge waiter self-SKIPs). Else harvest R1c/`r1c_lora_decision.json` (waiter already armed) or R2.
