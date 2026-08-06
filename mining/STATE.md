# STATE — mining run snapshot

Rewritten every pass. Do not append.

## Stage

**Stage 0 complete → enter Stage 1.**

Stage 0 gate met: every S* term and gate explained in `NOTES.md` (2026-08-06 pass 1).
No GPU spend yet. No `mine-*` pods.

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
| reg burn | ~τ0.692 |
| Lium balance | $34,715.32 (floor $28,000; headroom OK) |
| miner coldkey free | τ10.000 |
| mining spend to date | $0 / τ0 |
| our submissions | none |
| mine-* pods | none (lium ps: only affine-eval + affine-bench) |

## What's running

Nothing mining-owned.

## Blocked

Nothing.

## Next action (single, highest value)

**Stage 1 — offline replay of a published duel.**

1. Download `https://s3.hippius.com/affine-sn120/evals/chal-00224.json.gz`
   (kevin954's genesis duel; index shows margin 0.0 / wins=false because it was
   gated under r_lo=1.0 then crowned retroactively when r_lo→0.3).
2. Also pull `chal-00203.json.gz` (pandora-box ckpt300-m4) as backup.
3. Recompute with local `affine.score.duel` under current knobs
   (`r_lo=0.3`, `baseline_band=1.25`, `min_margin=0.02`).
4. Target: reproduce AGENTS.md claimed margins (~+0.070/z≈6.3 for kevin,
   ~+0.061/z≈5.7 for pandora) or match whatever the stored pair logprobs imply.
5. Write `experiments/s1-replay-chal00224/{plan,result}.md` with exact numbers.
6. Gate for Stage 1: recomputed margin matches a published/claimed duel figure.

No GPU. Work only under `/home/const/subnet120/mining/`. Read-only on `affine/`.
