# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 1 complete → enter Stage 2.**

Stage 0 gate met (pass 1). Stage 1 gate met (pass 2): offline `score.duel`
on stored logprobs reproduces AGENTS.md retroactive crown margins
(kevin +0.070000 / z=6.3107; pandora +0.060845 / z=5.6472).
No GPU spend. No `mine-*` pods.

## Live facts (verified this pass)

| item | value |
|---|---|
| king | `kevin954/Affine-5dfqbbh8ev-sft` @ `6a5815fad8f4e34c983b1933c1fae5762fe25220` |
| king S | 0.03955783762471344 (= chal-00224 challenger mean_mix) |
| reign # | 2 |
| teacher | `zai-org/GLM-4.5-Air-FP8` |
| min_submission_block | 8767079 |
| weight_version_key | 1 |
| eval stack | vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0 |
| Lium balance | $34,715.32 (floor $28,000; unchanged, no rentals) |
| miner coldkey free | τ10.000 |
| mining spend to date | $0 / τ0 |
| our submissions | none |
| mine-* pods | none (lium ps: only affine-eval + affine-bench) |

## What's running

Nothing mining-owned.

## Blocked

Nothing.

## Next action (single, highest value)

**Stage 2 — cheap hypotheses from public duel data (no GPU).**

1. Pull `evals/index.jsonl` + a useful sample of `evals/*.json.gz` (winners +
   near-misses + gate failures) into `experiments/s2-public-duel-mine/`.
2. Decompose per duel: Λ2 vs clip(L1) contribution, which gates bind, r and
   baseline ratios, bank knife-edge.
3. Rank open hypotheses in `HYPOTHESES.md` by expected α per dollar
   (H1 teacher-ref SFT, H2 king merge, H3 L1lift lever — settle or refine H3
   with the numbers).
4. Gate for Stage 2: ranked list with predicted effect on S, written before
   any rental.

Evidence already local: `experiments/s1-replay-chal00224/` (artifacts + `replay.py`).
No GPU. Work only under `/home/const/subnet120/mining/`. Read-only on `affine/`.
