# H138 / F43 — Tok offline DPO on duel Λ2 preferences (family screen)

## Family
**F43**: Offline DPO on published duel thought pairs ranked by teacher Λ2.
Chosen = higher-Λ2 `z` (king or chall), rejected = lower-Λ2 sibling on the
same turn. Tok-init LoRA. **No live teacher during train** — orthogonal to
F37–F42 (all online teacher-Λ2 RL / BoN-CE). Not past-king FT/raw; not CE on
harvested z alone (F2).

## Claim
Bradley-Terry preference on real duel Λ2 margins moves mean Λ2 (hence paired
margin vs Tok) where unidirectional CE/SFT on high-Λ2 z failed (F2 m≈0).
Screen margin >+0.015.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Method
1. Data: 604 pairs from `s2-public-duel-mine` chal-*.json.gz, gap≥0.02,
   messages/y from `winner_za_high_l2` (mean gap ≈0.125).
2. Tok-init LoRA r=16/α32 lr=5e-6 β=0.1 max_steps=200 max_len=6144.
3. DPO loss on thought tokens only (prompt shared); no sampling / no teacher.
4. Merge → n80 vs Tok (teacher served only for post_train sim).

## Decision rule
- m≤0 or gate fail → REFUTE; tear `mine-f43-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.

## Why a family (not a cell)
Loss class change: offline preference BT vs online REINFORCE / BoN-CE / SFT.
Uses duel-relative Λ2 labels, not self-generated rewards.
