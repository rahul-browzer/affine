# Pass 397 — F8 king-only recover (Tok)

- Pre: merge.done 68G; teacher:200; king APIServer alive but :8001=000
  (shm_broadcast hang since ~22:13Z); chall:000 (placeholder killed post-merge).
- Bug: `king_recover_pass332.sh` still had Genesis REPO/REV — would have
  served the wrong model on :8001. Patched → Tok331102@eb8bf9a.
- Launched king332 pid=23468 @22:28:10Z; reaped hung 6779; isolated TCACHE
  `/root/.triton/isolated/h103_king_p332_1786228095_23468` util=0.72.
- Next: wait `h103_king_recover_pass332.done` → relaunch_chall_pass264
  (`/root/h103/merged`) → n80.
