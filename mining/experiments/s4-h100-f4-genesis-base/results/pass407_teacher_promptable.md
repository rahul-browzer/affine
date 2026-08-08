# pass 407 — F4 teacher recover332 confirmed promptable; n80 a203 resumed

## Confirm
- Teacher :8000 health/models **200** @~23:23:53Z (load+compile ~7m after p406 launch).
- Completions probe `hi` → 200; live n80 POSTs `/v1/completions` 200.
- TCACHE=`/root/.triton/cache/teacher_p332_1786230992_98838` (n_so≥8); king :8001 / chall :8002 still 200.
- `retry_h100_n80_longwait`: first promptable poll=34 → settle20 → engines double-promptable → **n80 a203** launched 23:24:26Z (pid 102257).

## Fleet (screen, no margins yet)
- F7: b203 chall 400 → attempt2 **c203** king3/chall5 (FALSE_PROBE≠REFUTE).
- F8 a203: king43/chall43.
- F9 b203: king54/chall54.

## Next
Await n80 margins; on m>+0.015 → CONFIRM k=4.
