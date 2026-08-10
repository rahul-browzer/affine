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
| Lium balance | ~$124,395 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b train | **RUNNING** · max_len=16384 · **~48/126** @~45s/it · loss~0.30 · pid **79866** |
| R1b waiter | **ARMED** · merge→reload→n80 pid **80760** |
| R1b→R1c chain | **ARMED** · pid **83033** · auto-launch R1c if headroom < 1.5× |
| R1c data | **READY** · nsup100 **176** rows · EPOCHS=6 staged |
| R2 prefetch | **DONE** · TalentPigs+kevin cached · `.done` @18:42Z |
| R2 CPU premerge | **RUNNING** · shard1 **33 GiB written**; blending shard2/2 · pid **85406**/py **85512** |
| R2 premerge stamp | meta path **fixed** (`merge_alpha_meta.json`); fixer pid **86376** |
| R2 α→n80 | **ARMED** · waiter pid **85408** · reuses premerge stamp |
| HF pre-push | `unconst/Affine-5czsc2fc98-r1lora` **public** @ `569a68be…` (not for submit) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1b + R1/R2 waiters + R2 α-merge |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536`.
- R1b: log `/root/logs/r1b_train.log`; decision → `/root/affine_data/r1b_lora_decision.json`.
- R1c chain: `/root/logs/r1b_to_r1c_chain.log` → `/root/affine_data/r1c_lora_decision.json`.
- R2 premerge: `/root/logs/r2_premerge.log` → `/root/logs/r2_premerge.done`.
- R2 n80: `/root/logs/r2_merge_reload.log` → `/root/affine_data/r2_alpha_decision.json`.
- ETA R1b train ~0.9h; α-merge finishing shard2; chall reload+n80 after R1 lane below bar.

## Blocked

- Do **not** submit `r1lora@569a68be` — headroom 0.035×(3·SE) vs bar 1.5×.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge before every ~65 GiB push (private + public caps).

## Next action

**Harvest** `/root/logs/r2_premerge.done` (confirm `max_abs_delta` in stamp) then R1b/R1c/R2 decisions. If any clears 1.5× → Stage-5 prep. Else wait R2 α n80 after R1 lane frees GPUs.
