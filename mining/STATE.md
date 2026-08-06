# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 2 complete → enter Stage 3.**

Stage 0–1 gates met (passes 1–2). Stage 2 gate met (passes 3–4): public duel
mining + decomposition; H3 supported; hypotheses ranked by expected α/$ in
`HYPOTHESES.md` (H1 > H2 > H4 > H3 > H5). No GPU spend. No `mine-*` pods.

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
| Lium balance | $34,709.52 (floor $28,000; re-check before rent) |
| miner coldkey free | τ10.000 |
| mining spend to date | $0 / τ0 |
| our submissions | none |
| mine-* pods | none (lium ps: only affine-eval + affine-bench) |

## What's running

Nothing mining-owned.

## Blocked

Nothing. Stage 3 may rent **one** `mine-sim-1` pod only after re-checking
`lium balance` ≥ $28k + rental headroom and cumulative mining spend ≤ $4k.

## Next action (single, highest value)

**Stage 3 — build local duel simulator on one rented pod.**

1. Re-check `lium balance`; if renting would breach $28k floor, stop and record.
2. `lium up` a single pod named `mine-sim-1` with `--ttl` (suggest 6h), record in
   `INVENTORY.md` + `LEDGER.md` in the same pass.
3. On the pod: serve teacher + king + a known challenger under eval stack
   (vllm 0.22.1 / TP=2 / max-model-len 32768), run real scoring path on a
   public-D slice.
4. Gate: simulator reproduces a known duel result within noise (prefer
   replaying chal-00224 margin shape or kevin-vs-genesis on a fixed slice).
5. Do **not** train yet (Stage 4). Do **not** submit.

Evidence ready: `experiments/s2-public-duel-mine/` (index, 16 gz, analyze,
plan/result, ranked hypotheses). Top post-sim bets: H1 teacher-ref SFT from
kevin; H2 merge kevin×pandora-m4 / kevin×hf99jack.

Work only under `/home/const/subnet120/mining/`. Read-only on `affine/`.
Never touch non-`mine-*` pods.
