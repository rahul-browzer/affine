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
| Lium balance | ~$124,652 · floor ≥$10k · burn **$64/h** (≤$833/h ok) |
| fleet | `mine-crown-1` = `lunar-orbit-50` 8×B300 @ $64/h · TTL→2026-08-11T16:12Z |
| submissions | 0 · hotkey `default` unused |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-crown-1 | lunar-orbit-50 | `ssh root@86.38.182.50 -p 40300` | 2026-08-11T16:12Z | engines **200/200/200**; H64 n80 + R1 LoRA train |

- **p1857:** R1 LoRA train **launched** on GPUs 6–7 (pid **23282** / bash **23274**):
  - data `sft_high_reason.jsonl` n=1403 · init Tok af10 `eb8bf9a…`
  - out `/root/r1_out/lora_tok_high_reason` · log `/root/logs/r1_train.log`
  - loading base weights @16:49Z (GPU6/7 ~34GB each)
- H64 n80 sim pid **20566** still alive @16:49Z: last progress **30/80 / 30/80** (stale stamp 16:47Z; engines busy on teacher 0–1).

Poll:
```
cat /root/affine_data/r1_decision.json /root/affine_data/r1_reason_progress.json 2>/dev/null
tail -n 30 /root/logs/r1_reason_sim.log /root/logs/r1_train.log
test -f /root/logs/r1_train.done && cat /root/r1_out/lora_tok_high_reason/train_result.json
```

## Blocked

- Do **not** use S\* submit gate 0.04, clip-L1 shaping, or king-watch idle.
- Do **not** treat telemetry gates as crown blockers.
- HF: `unconst` public storage may still be full — verify before push.
- Coldkey TAO is not convertible without a dated instruction.

## Next action

**Harvest** `/root/affine_data/r1_decision.json` when n80 finishes. Submit only if headroom ≥ **1.5×(3·SE)**. Else (or after train): merge LoRA → reload chall:8002 → fresh n80 vs Tok. Watch `/root/logs/r1_train.done`.
