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
| Lium balance | ~$124,563 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | teacher+king **200@65536**; LoRA chall loading; n80 armed |

- **R1 LoRA train DONE** 17:10Z · adapter `/root/r1_out/lora_tok_high_reason/adapter` · merged `/tmp/r1_lora_merged`.
- **Engines:** teacher:8000 + king:8001 **200**, `max_model_len=65536`. Chall:8002 relaunched after multimodal `config.json` restore (CausalLM merge had written text-only).
- **Waiters:** engines stamp pid in `/root/logs/engines_stamp.pid` → `engines_65536.done`; n80 `/root/logs/r1_lora_n80_launch.pid` → `r1_lora_decision.json`.
- **Serve env (required):** `CUDA_HOME=…/nvidia/cu13` + `VLLM_USE_FLASHINFER_*=0`. No `/usr/local/cuda` symlink; do not put `cu13/bin` on `PATH`.

Poll:
```
cat /root/logs/engines_65536.done /root/affine_data/r1_lora_decision.json 2>/dev/null
tail -n 20 /root/logs/engines_stamp.log /root/logs/r1_lora_n80_launch.log /root/logs/vllm_chall.log
for p in 8000 8001 8002; do curl -s http://127.0.0.1:$p/v1/models | python3 -c 'import sys,json; d=json.load(sys.stdin)["data"][0]; print(d["id"], d.get("max_model_len"))'; done
```

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- Never serve crown engines at `max_model_len=32768` — long corpus turns abort n80.
- Never symlink `/usr/local/cuda`→cu13 on B300 (flashinfer CCCL clash).
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `r1_lora_decision.json` after chall **200** + LoRA n80. Submit only if headroom ≥ **1.5×(3·SE)**. If chall dies again, confirm `config.json` is a real file with `Qwen3_5MoeForConditionalGeneration` (not a dangling HF symlink / not text-only).
