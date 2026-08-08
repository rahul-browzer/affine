# H76 pass297 — train→merge→chall serve

UTC 2026-08-08T11:51–12:03Z on mine-h76-1 (gentle-raven-df).

- train.done @11:51Z (26/26 steps, lr=5e-6 r=18 α32 m7×winner-zA)
- merge LoRA → `/root/h76/merged` @12:03Z; `OK_NON_IDENTICAL` vs m7 and Tok331102
- tok331102.done @11:55Z (last shard lag ~14m after teacher)
- prewarm teacher+king ready @12:01Z; chall-only re-serve launched @12:03:13Z
  (`vllm serve /root/h76/merged` :8002 util 0.72); :8000/:8001=200, :8002 loading
- HF push background: `unconst/Affine-5czsc2fc98-h76-{lora,merged}`

Next: await chall health+completions probe → n80 vs Tok a203.
