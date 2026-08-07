# s4-h5c-expand-refs — expand teacher_refs + train path for H5c

**Hypothesis:** H5c (see `../s4-h5c-crown-autopsy/result.md`, `HYPOTHESES.md`).
Kevin-init thought-only LoRA on **expanded** public teacher_refs (not the
stale 440-only H1 set) raises mean clip-L1 ≥ 0.042 at r∈[0.70,0.85] → n80
margin > 0.04 vs live TalentPigs.

**Prediction (pre-registered before train):** n80 margin ≥ +0.04; H4 OK;
chall mean clip-L1 ≥ 0.042.

## Method (this pass = harvest only; no GPU)

1. Read all public `chal-*.json.gz` under validator evals store
   (`affine/state/evals/`, **read-only**).
2. Dedupe by `turn_id`, keep highest `lp_own` bash-ok teacher sample.
3. Join corpus prefixes from `research/data/turns_minicoder.jsonl` (read-only).
4. Emit:
   - full expanded JSONL
   - short-z subset (`z` chars ≤ 250; crown abc μ≈232)
   - meta + length/list stats
5. Prefer **short-z** as the H5c train set (autopsy: shorter thoughts +
   fewer list markers on the crown).

## Decision rule (unchanged from autopsy)

- Train next on a fresh `mine-*` pod (kevin `6a5815…` init, thought-only LoRA).
- Sim n80 vs live TalentPigs; submit only if margin > 0.04 and H4 OK.
- Do **not** submit any prior H1/H1v2/H5/H5b checkpoint.

## Train path (next pass — do not start until harvest meta exists)

```
DATA = teacher_refs_shortz.jsonl   # primary; fallback expanded if shortz < 200
INIT = kevin954/Affine-5dfqbbh8ev-sft @ 6a5815fad8f4e34c983b1933c1fae5762fe25220
LOSS = thought-only (reuse s4-h1v2-sft/train_lora.py --loss-on thought)
LR   = 2e-5, 1 epoch, LoRA r=16 (same as H1v2; recipe lever is DATA not lr)
SIM  = n80 vs TalentPigs/affine-5ekxlcg3fx-abc @ dbfbb3e2…
GATE = margin > 0.04, r∈[0.70,0.85], base×≤1.15, clip-L1≥0.042
```
