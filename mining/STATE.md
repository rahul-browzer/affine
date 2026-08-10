# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3→4** — Reason v3 crown push (operator 2026-08-10).
King-watch **revoked**. `weight_version_key=3`. Score = mean Reason (Λ2 only).

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · `weight_version_key=3` · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` (reign 4) |
| corpus | epoch **7** · schema v2 · manifest `167085451ab6…` · **ready** |
| Lium balance | ~$124,552 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | teacher+king+LoRA chall **200@65536**; LoRA n80 **running** |

- **R1 LoRA** at `/tmp/r1_lora_merged` with **333** grafted `model.visual.*` tensors (`model-visual.safetensors`).
- **Engines:** all three **200** @ `max_model_len=65536`. `engines_65536.done=READY`.
- **n80:** started `block_hash=720854eea37fe3d8…` on epoch-7 corpus → `/root/affine_data/r1_lora_decision.json`.
- **Serve env:** `CUDA_HOME=…/nvidia/cu13` + `VLLM_USE_FLASHINFER_*=0`. No `cu13/bin` on `PATH`.
- **Tooling:** `merge_lora.py` auto-grafts visual; `graft_visual_weights.py` standalone.

Poll:
```
cat /root/affine_data/r1_lora_decision.json /root/affine_data/r1_lora_reason_progress.json 2>/dev/null
tail -n 30 /root/logs/r1_lora_n80_launch.log
```

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- Never serve crown engines at `max_model_len=32768` — long corpus turns abort n80.
- Never symlink `/usr/local/cuda`→cu13 on B300 (flashinfer CCCL clash).
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `r1_lora_decision.json`. Submit only if headroom ≥ **1.5×(3·SE)**. If n80 dies mid-run, check chall still 200 and relaunch sim only (do not re-graft unless visual keys missing).
