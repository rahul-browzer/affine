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
| Lium balance | ~$124,618 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | engines relaunch **65536**; R1 LoRA train + merge waiter |

- **H64 n80 CRASHED** @52/80: `ContextLengthError` (prompt~30977+1792 > **32768**). `r1_decision.json` = **CRASH** (do not submit).
- **Fix (p1859):** serve knobs → **`max_model_len=65536`** (matches `affine.toml`). Engines relaunch pids **24941/24942/24943** loading (not 200 yet). Stamp → `/root/logs/engines_65536.done`.
- **R1 LoRA train** pid **23282** GPUs 6–7: ~**42/66** @17:02Z. Adapter → `/root/r1_out/lora_tok_high_reason/adapter`.
- **Merge waiter** pid **24831**: waits train.done → merge → reload chall @**65536** → LoRA n80 → `r1_lora_decision.json`.

Poll:
```
cat /root/logs/engines_65536.done /root/affine_data/r1_lora_decision.json 2>/dev/null
tail -n 20 /root/logs/relaunch_engines_65536.log /root/logs/r1_train.log /root/logs/r1_merge_reload.log
for p in 8000 8001 8002; do curl -s http://127.0.0.1:$p/v1/models | python3 -c 'import sys,json; d=json.load(sys.stdin)["data"][0]; print(d["id"], d.get("max_model_len"))'; done
```

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- Never serve crown engines at `max_model_len=32768` — long corpus turns abort n80.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `r1_lora_decision.json` after engines **200** + train merge + LoRA n80. Submit only if headroom ≥ **1.5×(3·SE)**. Confirm `/v1/models` reports `max_model_len=65536` before trusting any sim.
