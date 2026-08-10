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
| Lium balance | ~$124,194 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b train | **DONE** @19:35Z · max_len=16384 · 126/126 · adapter ready |
| R1b merge | **DONE** @19:38Z · graft visual 333 keys · chall :8002 reloaded |
| R1b n80 #1 | **CRASHED** @~76/80 · `httpx.ReadTimeout` (180s×3) on teacher sample |
| R1b n80 #2 | **RUNNING** · patched timeout **600s×5** · king **1**/80 · pid **95336** |
| R1b waiter | relaunch bash pid **95237** → writes `r1b_lora_decision.json` |
| R1b→R1c chain | **ARMED** · pid **83033** · auto-launch R1c if headroom < 1.5× |
| R1c data | **READY** · nsup100 **176** rows · EPOCHS=6 staged |
| R2 prefetch | **DONE** · TalentPigs+kevin cached |
| R2 CPU premerge | **DONE** @18:47Z · `max_abs_delta=0.27734375` · 66 GiB |
| R2 α→n80 | **ARMED** · waiter pid **85408** · waits R1 lane |
| HF pre-push | `unconst/Affine-5czsc2fc98-r1lora` **public** @ `569a68be…` (not for submit) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1b n80 relaunch + R1c/R2 waiters |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536` (chall=`/tmp/r1b_lora_merged`).
- R1b n80 #2: log `/root/logs/r1b_lora_reason_sim.log`; progress `/root/affine_data/r1b_lora_reason_progress.json`.
- Decision target: `/root/affine_data/r1b_lora_decision.json` (not written yet).
- Relaunch: `/root/logs/r1b_relaunch_n80.nohup` · pidfile `/root/logs/r1b_relaunch_n80.pid`.
- R1c chain: `/root/logs/r1b_to_r1c_chain.log` → `/root/affine_data/r1c_lora_decision.json`.
- R2 n80: `/root/logs/r2_merge_reload.log` → `/root/affine_data/r2_alpha_decision.json`.
- Slice #2: block_hash `b99bfc9c84c74794…`; hotkey `local-r1b-lora-20260810T201317Z`.
- Client patch: `vllm_client` Timeout **600s**, connect 30s, **5** attempts (was 180×3).

## Blocked

- Do **not** submit `r1lora@569a68be` — headroom 0.035×(3·SE) vs bar 1.5×.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge before every ~65 GiB push (private + public caps).
- Never `pkill -f` over SSH (kills session); kill by PID / pidfile only.

## Next action

**Harvest** `/root/affine_data/r1b_lora_decision.json` from relaunch. If headroom ≥ 1.5× → Stage-5 prep. Else confirm R1c chain launch, then R1c/R2 decisions.
