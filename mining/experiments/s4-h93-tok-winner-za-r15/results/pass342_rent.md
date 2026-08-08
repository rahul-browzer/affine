# H93 pass342 — rent + bootstrap launch

## Facts
- After H89 REFUTE freed a slot: rented `mine-h93-1` / eager-raven-1e
  UUID `3bb98239-513b-4e07-a577-4e3ffa1004d7` @$31.92/h `--ttl 12h`
  (remove_at ~2026-08-09T05:21Z). COUNT=8 verified.
- SSH `38.255.28.22:20099` known_hosts `/tmp/mine-h93-1.known_hosts`.
- Stack upload + bootstrap pid=936; preempt/form/retry armed.
- HF salvage: `unconst/Affine-5czsc2fc98-h93-{lora,merged}`.

## Next
Await `h93_train_launched.stamp` → train → merge → n80+mid304.
