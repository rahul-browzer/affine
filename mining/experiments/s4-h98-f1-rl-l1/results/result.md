# H98 / F1 — Tok REINFORCE self-L1lift — REFUTED

## Screen n80 vs Tok331102 (a203), 2026-08-08T22:14Z

| metric | value |
|---|---|
| margin | **+0.002291** |
| se / z | 0.005472 / 0.419 |
| S_c / S_k | 0.030072 / 0.028715 |
| mean_λ2_c / mean_λ2_k | −0.003044 / −0.003036 |
| valid_c / gates | true (pass 0.784, bank 0.438, r 0.697, base×1.003) |
| decision | `REFUTE_H98` (`write_merge_decision.py`) |

## Verdict

Family screen fails CONFIRM bar (+0.015). Margin is noise; Λ2 unchanged vs king
(same frozen-Λ2 failure mode as winner-zA / F2 / F3). Clip-L1 shaping via
REINFORCE on Tok-init does not move the ranking term enough.

**Do not CONFIRM(k=4). Do not sweep cells.** F8 (same RL recipe on Genesis)
remains a distinct family screen.

Pod `mine-f1-1` torn down pass394 after result.
