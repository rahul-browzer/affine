# STATE — mining run snapshot
Rewritten every pass. Do not append.

## Stage

**Stage 3** — crown pod restoring warm stack (TKC @65536). `weight_version_key=3`.

## Live facts

| item | value |
|---|---|
| contract | Reason v3 · crown = margin > 3·SE |
| king | `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a2…` |
| corpus | epoch **7** · schema v2 (sync waiter armed) |
| Lium | ~$122,507 · burn **$52.25/h** (≤$833/h) |
| fleet | `mine-crown-1` **gentle-orbit-bd** 8×B200 · TTL→2026-08-12T08:42Z |
| SSH | `ssh root@95.133.253.90 -p 40099` |
| submissions | 0 · hotkey `default` unused |
| board | duel **chal-00469** (sky) · R2ai sbs SKIP_BOARD 0.018× |

## What's running

| name | SSH | role |
|---|---|---|
| mine-crown-1 | `ssh root@95.133.253.90 -p 40099` | restore pid **2138** (uv pip) · corpus waiter **2143** |

- Poll: `/root/logs/warm_stack_ready.done` + engines **200/200/200**
- Corpus: `/root/logs/corpus.done` (after venv+pandas)
- Host hist bridge pid **1264563** (alive; stamps 467–471)

## Blocked

- No TKC until restore finishes (pip → Triton → HF DL → serve).
- Submit only if sim hr ≥ **1.5×**.

## Next action

**Poll warm_stack_ready.done** → if 200/200/200, arm first Reason+ among **469–471** (sky/google/pig) chall→n80; else diagnose `/root/logs/vllm_*.log`.
