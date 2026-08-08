# H98/F1 pass354 — first Direct-RL-on-S family screen

## Facts
- Live fleet H91/93/94 n80 (~54/61/46); H95 SKIP_MERGE resume after CPU merge;
  H96 train; H97/F3 bootstrap. Free slots → operator priority **F1**.
- Scaffolded `s4-h98-f1-rl-l1`: REINFORCE on thought tokens, reward =
  `clip(self L1lift, ±0.1)`, G=2, r=16/α32, max_steps=200. No CE on harvested z.
- Rented `mine-f1-1` / brave-hawk-5a UUID
  `876b614a-505a-4959-a59f-f8272be006f2` @$33.81/h `--ttl 12h`
  (pod id `a3dec2a5-c270-4bf0-9e4f-6b7fc432c723`). Rejected $23.2/h peer (<$28).
- SSH `86.38.238.54:40099` known_hosts `/tmp/mine-f1-1.known_hosts`.
- COUNT=8 verified. Stack upload + bootstrap pid=884; form/retry/preempt armed.
- HF salvage: `unconst/Affine-5czsc2fc98-h98-{lora,merged}`.

## Next
Await bootstrap→RL train→merge→n80. Screen hit >+0.015 → CONFIRM k=4.
On REFUTE of draining winner-zA cells: tear that `mine-*` only; fill F2/F4.
