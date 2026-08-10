# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest `167085451ab6…` · **ready** |
| Lium balance | ~$124,429 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |
| R1 LoRA n80 | **DONE** · `SIGNAL_POS_BELOW_3SE` · margin +0.0005 ≪ 3·SE 0.0147 |
| R1b train | **RUNNING** · max_len=16384 · **16/126** @~34s/it · loss~0.41 · pid **79866** |
| R1b waiter | **ARMED** · merge→reload→n80 pid **80760** |
| R1c data | **READY** · `/root/r1_data/sft_high_reason_nsup100.jsonl` **176** rows (nsup≥100) |
| HF pre-push | `unconst/Affine-5czsc2fc98-r1lora` **public** @ `569a68be…` (not for submit) |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | TK@65536 + R1b train + merge waiter |

- Engines 8000/8001/8002 **200** @ `max_model_len=65536`.
- R1b: log `/root/logs/r1b_train.log`; done `/root/logs/r1b_train.done`; out `/root/r1_out/lora_tok_high_reason_r1b`.
- Waiter → `/root/affine_data/r1b_lora_decision.json` after merge+n80.
- ETA train ~1.0h (110×~34s); then merge+reload+n80.
- R1c staged: `launch_r1c_train.sh` + nsup100 jsonl (do **not** start until R1b frees GPUs 6–7).

## Blocked

- Do **not** submit `r1lora@569a68be` — headroom 0.035×(3·SE) vs bar 1.5×.
- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Never serve crown engines at `max_model_len=32768`.
- Never symlink `/usr/local/cuda`→cu13 on B300.
- Coldkey TAO is not convertible without a dated instruction.
- **unconst HF storage** — purge before every ~65 GiB push (private + public caps).

## Next action

**Harvest R1b n80** at `/root/affine_data/r1b_lora_decision.json`. If headroom < 1.5×(3·SE), launch **R1c** on `sft_high_reason_nsup100.jsonl` (176 rows, nsup_med=137) via `launch_r1c_train.sh`.
