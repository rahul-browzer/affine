# H101/F6 pass385 — mid-load peer-seed after a1 Triton ghost

## a1 death
- recover264 a1 seeded from local `/root/.triton/cache/king` (16 launchers).
- chall_pid=19433 died @21:36:14 before health=200.
- Cause: `ImportError` ENOENT on
  `…/6YKNXZRSISLNJ4CS4OWPJQS5TDKFFEVRF6W2VZ4O7MYHPZ7PACUQ/__triton_launcher…so`
  during a completions probe mid-load. That hash was **absent** from local king
  seed (ghost JIT path).

## a2 + peer seed
- a2 launched 21:37:08 TCACHE=`…/h101_chall_p260_a2_1786225020_19128`
  (again seeded from weak local 16).
- Mid-load rsync from F7 (`mine-f7-1`) isolated king TCACHE
  (`h102_king_p332_…`, 19 launchers, 85 MiB) → F6 `/root/.triton/cache/king`
  **and** live chall a2 TCACHE. Staging via host `/tmp` then deleted.
- Post-seed: `king_so=19` `chall_so=19`; `6YKNXZRS…` present; chall_pid=22538
  alive, :8002 still 000 (weight load), GPUs 4/5 allocating.

## Next
Await a2 health=200 → diverse warm → freeze → n80 vs Tok.
