# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 2 complete → enter Stage 3.**

Stage 0–1 gates met (passes 1–2). Stage 2 gate met (pass 4): public-duel
decomposition in `experiments/s2-public-duel-mine/`; H3 supported; H1/H2/H3
ranked by expected α/$ in `HYPOTHESES.md`.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 |
| reign # | 2 |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,709.52 (floor $28,000; validator burn only — no mine rentals) |
| miner coldkey free | τ10.000 |
| mining spend to date | $0 / τ0 |
| our submissions | none |
| mine-* pods | none (`lium ps`: only affine-eval + affine-bench) |

## What's running

Nothing mining-owned.

## Blocked

Nothing. Stage 3 needs a rental — check floor ($28k) and $4k pre-crown cap
before `lium up`.

## Next action (single, highest value)

**Stage 3 — build local duel simulator on one `mine-*` pod (first GPU spend).**

1. Check `lium balance` ≥ $28k + rental; cumulative mining spend still $0 / cap $4k.
2. `lium up` **one** pod named `mine-sim-1`, with `--ttl` (suggest 6h), GPU
   class that can hold teacher FP8 + king + challenger under eval stack
   (vllm 0.22.1 / tf 5.14.1 / torch 2.11.0). Record in `INVENTORY.md` +
   `LEDGER.md` in the same pass.
3. Serve teacher + current king + a known challenger (kevin's own revision or
   genesis) with stock `vllm serve` knobs matching eval; run scoring path on a
   public-D slice / replay a known duel.
4. Gate: simulator reproduces a known duel result within noise (use
   chal-00224 margin +0.070 / z≈6.31 as anchor, or king-vs-self ~0).
5. Do **not** start SFT (H1) or merge (H2) until Stage 3 gate MET.

No work outside `/home/const/subnet120/mining/`. Never touch validator pods.
