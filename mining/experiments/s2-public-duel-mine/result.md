# s2-public-duel-mine — result

**UTC:** 2026-08-06T22:52Z  
**Verdict: Stage 2 gate MET.** H3 supported. Hypotheses ranked by expected α/$.

## Artifacts

| file | what |
|---|---|
| `index.jsonl` | 38 published duels (full manifest) |
| `chal-*.json.gz` | 16 stratified duel records (~3.8 MB) |
| `analyze.py` | decomposition + current-knob recompute |
| `summary.json` | machine-readable per-duel stats |
| `table.txt` | human table |

Symlinks: `chal-00203`, `chal-00224` → `../s1-replay-chal00224/`.

## H3 decision (pre-registered)

On n=14 band-valid duels under current knobs:

| metric | value |
|---|---|
| Spearman(d_mix, d_clip_l1) | **+0.921** |
| Spearman(d_mix, d_Λ2) | +0.644 |
| mean \|d_clip_l1\| | 0.0177 |
| mean \|d_Λ2\| | 0.0091 |
| mean clip-L1 share of \|Δ\| | 0.59 |

**H3 SUPPORTED.** Paired margin tracks clip(L1) more than Λ2. Kevin still only
at mean clip-L1 = +0.031 (19% of pairs at +0.1 cap) → theoretical L1 headroom
≈ +0.069 on S if Λ2 holds and gates stay green.

## Winning shape (current knobs, vs genesis)

| id | repo | mix | Λ2 | clipL1 | r | base× | margin | z |
|---|---|---|---|---|---|---|---|---|
| chal-00224 | kevin954/…-sft | **+0.0396** | +0.0086 | +0.0310 | 0.716 | 1.062 | **+0.070** | 6.31 |
| chal-00203 | pandora …ckpt300-m4 | +0.0187 | −0.0072 | +0.0260 | 0.763 | 1.079 | **+0.061** | 5.65 |
| chal-00215 | hf99jack/…-cali | +0.0180 | −0.0080 | +0.0260 | 0.755 | 1.062 | **+0.041** | 3.95 |
| chal-00194 | pandora …ckpt300-m3 | +0.0069 | −0.0139 | +0.0208 | 0.812 | 0.995 | +0.029 | 2.62 (fails 3σ) |

Signature: r ∈ ~0.72–0.81, base× ≤ 1.08, positive clip-L1, Λ2 near zero or
slightly positive. Baseline saboteurs (base× 1.86–3.06) are band-INVALID.

## vs live king (kevin)

| id | challenger | cS | kS (slice) | margin | note |
|---|---|---|---|---|---|
| chal-00254 | michael-chan …-h2 | +0.0176 | +0.0203 | −0.0027 | closest live loss; L1c only +0.015 |
| chal-00255 | Tok331102 …-af5 | −0.0145 | +0.0015 | −0.0165 | |
| chal-00244 | Sansaliu …-second | −0.0472 | +0.0014 | −0.0486 | L1 drag |

King S on a random 80-turn slice is far below his crown-duel 0.0396 — slice
noise is large; submit gate margin > 0.04 is warranted.

## Ranked next bets (α per dollar, pre-rental)

See `HYPOTHESES.md`. Top: H1 teacher-ref SFT from kevin init; H2 merge
kevin×pandora-m4 / kevin×hf99jack; H4 stay inside distill envelope (r, base×).

## Stage 2 gate

**MET** — ranked hypotheses with predicted ΔS written before any GPU rental.
