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
| Lium balance | ~$124,026 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b n80 #2 | **DONE** · `REFUTE_R1_H64_BASELINE` · margin **−0.0135** · z=−2.45 |
| R1c train | **RUNNING** · **~116/132** @~37s/it · pid **96239** · ETA ~10m |
| R1c merge waiter | **ARMED** · pid **97305** · after train → merge+n80 |
| R2/R2b/R2c | **SKIPPED** (p1893) · Tok×awesome Δ≪0.01 · stubs headroom=0 |
| R2d pure awesome-v6 | **WAITING R1c** · pid **106493** · weak_skip=y |
| R2e Talent×awesome | **WAITING R2d** · pid **104742** · premerge Δ=**0.626** |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1c→R2d→R2e |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536` (chall restored `/tmp/r1b_lora_merged` pid **106728**).
- R1c train: `/root/logs/r1c_train.log` → `r1c_train.done`.
- R1c merge: `/root/logs/r1c_merge_reload.log` → `r1c_lora_decision.json`.
- R2d n80: `/root/logs/r2d_awesome_reload.log` → `r2d_awesome_decision.json` (waits R1c).
- R2e n80: `/root/logs/r2e_merge_reload.log` → `r2e_alpha_decision.json` (waits R2d).
- Weak skip stamp: `/root/logs/r2_weak_lanes_skipped.done`.

## Blocked

- Do **not** submit `r1lora@569a68be` or R1b merged — both fail submit bar.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge again before next ~65 GiB push if commit fails.
- Never `pkill -f` over SSH; kill by PID / pidfile only.
- R2 lane-free check must use **pidfile kill -0**, never `pgrep -af`.
- Published duel `margin` can still be S\* (Λ2+L1) — **recompute Reason from lpC fields**.
- Write stub decisions **only after** killing prior waiters (old R2d raced on R2C stub).
- Prefer R2d/R2e over Tok×awesome α (Δ≈0.006–0.009).

## Next action

**Harvest** `/root/affine_data/r1c_lora_decision.json`. If headroom ≥ 1.5× → Stage-5. Else let **R2d** (pure awesome) then **R2e** (Talent×awesome Δ=0.626) run; harvest those decisions.
