# H101 / F6 — Thought format/length: ultrashort≤80 z targets (family screen)

## Family
**F6** (operator queue): thought format/length axis. Not a winner-zA rank
cell and not F2's high-Λ2 *selection* (that kept raw z, mean 177 chars).
F2 REFUTE proved selecting high-Λ2 z under king-LoRA does not move Λ2.
F6 keeps the same high-Λ2 *content source* but **rewrites every z** to a
first-sentence / ≤80-char prose target (mean 60 chars) so train teaches a
different emit format at sample time.

## Claim
Tok331102-init thought-only LoRA (r=16/α32, lr=5e-6, 1 ep) on **1058**
ultrashort≤80 reformats of high-Λ2 z_A → screen margin >+0.015 vs Tok.
Short non-listy crown style historically correlates with wins; forcing the
policy to emit that format is a structural leave from CE-on-raw-harvest.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Compress `winner_za_high_l2.jsonl` → `za_ultrashort80.jsonl` (strip list
   markers, first sentence, hard ≤80; drop <15 chars). Meta in
   `results/compress_meta.json`.
2. Tok @ `eb8bf9a…` init; train GPUs 6,7; merge → n80 vs Tok (same stack).
3. Pod `mine-f6-1`.

## Decision rule
- m≤0 or gate fail → REFUTE family cell; tear `mine-f6-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any length/template sweep.
- m>0.04 + gates → Stage 5 shortlist.
