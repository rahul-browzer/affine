# H138/F43 pass506 — Tok offline DPO on duel-Λ2 prefs rented

## Context
- Fleet F37–F42 healthy (F37 RL ~165/200; F38–F40 training; F41 teacher
  serve; F42 Tok DL). Free slots → orthogonal **F43**.
- F43 = Tok-init LoRA offline DPO: 604 pairs from public duels, chosen =
  higher teacher-Λ2 z, rejected = lower (mean gap ≈0.125). No teacher at train.

## Rent
- First try `dd87f25e…` / golden-wolf-48 API 8×H200 → **COUNT=3** → rm
  `mine-f43-1` golden-lion-4a immediately (LESSONS).
- Retry `3bb98239…` → live `zesty-matrix-8e` /
  `588f4609…` **mine-f43-1** 8×H200 @$31.92/h `--ttl 12h`
  (remove_at ≈2026-08-09T20:34Z). **COUNT=8** verified via SSH before upload.
- SSH `38.255.28.22:20099` kh `/tmp/mine-f43-1.known_hosts`.
- Stack upload + bootstrap pid=947; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h138-{lora,merged}` created.
- soft=19:34:00Z (TTL−1h). EXP=`s4-h138-f43-tok-dpo-l2`.
- Data: `results/dpo_duel_l2.jsonl` n=604.

## Fleet at rent
- F37 RL ~165/200; F38–F42 as before; F43 bootstrap/pip.
- Burn ~$186.7/h (7 mine-*) ≪ $833/h.
