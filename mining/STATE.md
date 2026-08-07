# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 4 — H28 n80 + H29/H30/H31 train (4/5).**
H1–H27/H5c/H6/H20–H26 **REFUTED**. No submit. Clip-L1 rank: `s2-clip-l1-rank`.

## Live facts

| item | value |
|---|---|
| king | `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315 |
| eval | GLM-4.5-Air-FP8 · vllm 0.22.1 / tf 5.14.1 / torch 2.11.0 |
| min_submission_block | 8767079 |
| Lium / spend | **~$190,753** · cum mining ~$2,900 · **avail ~$181k** (floor $10k) |
| miner | τ10.000 free · 0 submissions |
| H28 | n80 **20/80** chall=king (engines 200) |
| H29 | train step~15/46 · loss@15=0.597 · 368ex fit-filter |
| H30 | train launched (m7.done) · post_train armed |
| H31 | bootstrap pip → m7 dl → train lr=3e-5 |

## What's running

| name | huid | SSH | TTL | role |
|---|---|---|---|---|
| mine-h28-1 | swift-hawk-e1 | 152.236.142.232:40311 | ~06:11Z | H28 n80 `local-h28` |
| mine-h29-1 | golden-wolf-bc | 38.255.28.21:20100 | ~07:28Z | H29 LoRA train → post_train |
| mine-h30-1 | golden-hawk-9f | 38.255.28.22:20100 | ~07:39Z | H30 m7×king-self train |
| mine-h31-1 | golden-raven-d8 | 152.236.142.236:40301 | ~07:42Z | H31 m7×king-self lr=3e-5 |

known_hosts `/tmp/mine-h2{8,9,0,1}-1.known_hosts`. **Free slots: 1** (no 8×H200 left).

## Blocked

No submit until some n80 margin > 0.04. **Do not requeue plmk / H21–H27 / α lottery.**
H27 winner-zA@TP-init dead. Never tear down on ConnectError/unpromptable.
Health=200 ≠ alive — require `/v1/completions` probe.
`pgrep -f` false-matches SSH — use awk `/[w]atch…/`.
Thought-LoRA: fit-filter msg_chars≤max_len×2.5 (H29 empty-mask landmine).
**Fill free slot** when 8×H200 (≥$20/h) appears — H32 = TP×king-self lr=3e-5.

## Next action

1. H28: poll → `h28_decision.json`; m>0.04 → Stage 5; else REFUTE+rm.
2. H29: poll `train.done` → merge → n80; same gate.
3. H30: poll train → merge → n80; same gate.
4. H31: poll bootstrap/train → merge → n80; same gate.
5. Free slot (1): rent H32 (TP×king-self lr=3e-5) when 8×H200 available — not α.
