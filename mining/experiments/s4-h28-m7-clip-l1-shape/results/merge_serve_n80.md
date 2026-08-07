# H28 merge → chall → n80 (pass 181)

- merge.done 18:57Z; elapsed_s≈416; weight_identical=false
- identity: ≠ m7 base, ≠ TalentPigs king (`h28_identity.json`)
- adapter salvage: `unconst/Affine-5czsc2fc98-h28-lora` @56ec576b (TTL insurance)
- merged HF push: background to `unconst/Affine-5czsc2fc98-h28-merged` (public)
- chall :8002 health=200 @19:04Z; `/v1/completions` probe=200 (Triton ImportError warn during GDN load was non-fatal)
- n80 `local-h28` launched 19:04Z; form+retry armed
- pass183: king :8001 died mid-n80 → relaunch + recover_wait
- pass185: recover DONE 19:30:47Z (health+completions probe=ok); n80 attempt1
  relaunched; @19:35Z progress chall 9/80 king 6/80; engines 8000/1/2=200
