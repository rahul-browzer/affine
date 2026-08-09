# H137/F42 pass505 — Tok×teacher-Λ2 BoN-CE screen rented

## Context
- Fleet F37–F41 healthy (F37 RL step≈150/200; F38/F39 early RL; F40
  teacher serve; F41 TalentPigs DL). Free slots → orthogonal **F42**.
- F42 = Tok-init LoRA Best-of-N CE: sample G=4, CE on argmax teacher-Λ2 z.
  Same reward as F37 REINFORCE, different update (winner-take-all CE).

## Rent
- Catalog `37b3ea5c…` → live `noble-raven-de` /
  `195e9633…` **mine-f42-1** 8×H200 @$28.00/h `--ttl 12h`
  (remove_at ≈2026-08-09T20:25:39Z). COUNT=8 verified via SSH.
- SSH `152.236.142.236:40300` kh `/tmp/mine-f42-1.known_hosts`.
- Stack upload + bootstrap pid=884; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h137-{lora,merged}` created.
- soft=19:25:39Z (TTL−1h). EXP=`s4-h137-f42-tok-bon-l2`.

## Fleet at rent
- F37 RL ~150/200; F38–F41 as before; F42 bootstrap/pip.
- Burn ~$154.8/h (6 mine-*) ≪ $833/h.
