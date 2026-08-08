# H100 / F4 — Non-king base: Genesis-init × high-Λ2 (family screen)

## Family
**F4** (operator 2026-08-08): non-king base model. Prior family was 100%
LoRA-init from the incumbent king (mean −0.004). F2 keeps Tok-init and
changes data; F4 keeps high-Λ2 data and changes the base to genesis.

## Claim
`dendriteholdings/albedo-qwen3.6-35b-king-genesis` @ `abe89194…` init,
thought-only LoRA r=16/α32 lr=5e-6 1ep on 1059 high-Λ2 z_A → screen margin
>+0.015 vs Tok331102. Genesis beats the king field by +0.16 on the honest
panel; Λ2 is a base-model property that LoRA-on-Tok cannot move.

## Prediction (pre-registered)
Screen n80 mean margin **> +0.015** vs Tok331102. Submit gate still >0.04.

## Decision rule
- m≤0 or gate fail → REFUTE family cell; tear `mine-f4-1`.
- 0.015<m≤0.04 → CONFIRM k=4 before any sweep.
- m>0.04 + gates → Stage 5 shortlist.
