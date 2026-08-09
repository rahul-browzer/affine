# H139/F44 pass513 — Tok online DPO teacher-Λ2 screen rented

## Context
- Fleet F37–F43 healthy (F37 n80 ~54/80; F38 merge→chall load; F39–F42
  train; F43 merge shards). Free slots → orthogonal **F44**.
- F44 = Tok-init LoRA online DPO: sample G=2, label with teacher Λ2,
  BT vs frozen base (β=0.1). Orthogonal to F43 offline duel prefs and
  F37/F42 REINFORCE/BoN-CE.

## Rent
- Catalog `ea473ae7…` / golden-raven-d3 → live `swift-matrix-65` /
  `42097e6b…` **mine-f44-1** 8×H200 @$28.00/h `--ttl 12h`
  (remove_at ≈2026-08-09T21:28:48Z). **COUNT=8** verified via SSH.
- SSH `152.236.142.237:40300` kh `/tmp/mine-f44-1.known_hosts`.
- Stack upload + bootstrap pid=904; form + retry(d203first) + preempt armed.
- HF `unconst/Affine-5czsc2fc98-h139-{lora,merged}` created.
- soft=20:28:48Z (TTL−1h). EXP=`s4-h139-f44-tok-online-dpo-l2`.
- Data: `winner_za_high_l1.jsonl` n=406 (H27).

## Fleet at rent
- F37 n80 ~54/80; F38–F43 as before; F44 bootstrap/pip.
- Burn ~$214.7/h (8 mine-*) ≪ $833/h.
