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
| Lium balance | ~$124,105 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b n80 #2 | **DONE** · `REFUTE_R1_H64_BASELINE` · margin **−0.0135** · z=−2.45 |
| R1c train | **RUNNING** · **~52/132** @~38s/it · pid **96239** · ETA ~50m |
| R1c merge waiter | **ARMED** · pid **97305** · R1b below bar → merge after train |
| R2 α→n80 | **WAITING** · pid **99246** (`r2_merge_reload.pid`) · r1b_dec=y r1c_dec=n |
| Near-miss prefetch | **RUNNING** · pid **99742** · 0pentensor@f479 + diane-cool (Reason hr **0.92×**) |
| HF quota | p1883 purged **6** legacy public merges (**~423 GiB**); kept `r1lora` |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1c + R2 wait + nearmiss prefetch |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536` (chall still `/tmp/r1b_lora_merged` until R1c merge).
- R1c train: log `/root/logs/r1c_train.log` → stamp `r1c_train.done`.
- R1c merge: log `/root/logs/r1c_merge_reload.log` → `r1c_lora_decision.json`.
- R2 waiter: `/root/logs/r2_merge_reload.{pid,log}` → `r2_alpha_decision.json`.
- Near-miss: `/root/logs/r2_prefetch_nearmiss.log` → `r2_prefetch_nearmiss.done`.

## Blocked

- Do **not** submit `r1lora@569a68be` or R1b merged — both fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge again before next ~65 GiB push if commit fails.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* (Λ2+L1) — **recompute Reason from lpC fields** before copying a “near-miss”.

## Next action

**Harvest** `/root/affine_data/r1c_lora_decision.json`. If headroom ≥ 1.5× → Stage-5. Else let R2 α→n80 run, then fuse **0pentensor awesome-v6** (Reason hr≈0.92×) into next merge/SFT once prefetch done.
