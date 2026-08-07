# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H28 n80 + H29/H30 train (3/5).**
H1–H27/H5c/H6/H20–H26 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,765** · cum mining ~$2,860 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H28 | n80 ~15/80 chall · 14/80 king (engines 200) |
| H29 | train step~9/46 · loss@5=0.666 · 368ex fit-filter |
| H30 | bootstrap pip/m7-dl · king-self×m7 · form+retry armed |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 n80 `local-h28` |
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 LoRA train → post_train |
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 m7×king-self bootstrap |

known_hosts `/tmp/mine-h2{8,9,0}-1.known_hosts`. **Free slots: 2.**

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H27 / α lottery.**
H27 winner-zA@TP-init dead. Never tear down on ConnectError/unpromptable.
Health=200 ≠ alive — require `/v1/completions` probe.
`pgrep -f` false-matches SSH — use awk `/[w]atch…/`.
Thought-LoRA: fit-filter msg_chars≤max_len×2.5 (H29 empty-mask landmine).
**Fill free slots** — do not wait on H28/H29 for next non-α variant (GOAL).

## Next action

1. H28: poll → `h28_decision.json`; m>0.04 → Stage 5; else REFUTE+rm.
2. H29: poll `train.done` → merge → n80; same gate.
3. H30: poll bootstrap/train → merge → n80; same gate.
4. Free slots (2): next non-α variant (e.g. lr≠1e-5 or Tok/af6-init×king-self if ungated) — not α.
