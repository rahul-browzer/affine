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
| Lium balance | ~$124,641 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | engines **200/200/200**; H64 n80 + R1 LoRA + merge waiter |

- **H64 n80** pid **20566** @16:51Z: **34/80 / 35/80** → will write `r1_decision.json`.
- **R1 LoRA train** pid **23282** on GPUs 6–7: step **5/66**, loss **0.429** @16:51Z (~18m left). Adapter → `/root/r1_out/lora_tok_high_reason/adapter`.
- **p1858 merge waiter** pid **24147**: waits train.done + H64 decision → merge LoRA → reload chall:8002 → fresh LoRA n80 → `r1_lora_decision.json`.

Poll:
```
cat /root/affine_data/r1_decision.json /root/affine_data/r1_lora_decision.json 2>/dev/null
tail -n 20 /root/logs/r1_train.log /root/logs/r1_merge_reload.log /root/logs/r1_lora_reason_sim.log
test -f /root/logs/r1_merge_reload.done && cat /root/affine_data/r1_lora_decision.json
```

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `r1_decision.json` (H64) and/or `r1_lora_decision.json` when ready. Submit only if headroom ≥ **1.5×(3·SE)**. If LoRA n80 fails bar, raise max_len / more epochs or try R2 — do not idle the crown pod.
