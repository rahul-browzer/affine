# H90 pass341 — rearm n80 retry mid king340 load

**Trigger:** king_recover_pass340 still loading (`:8001=000`, torch.compile @17:14:50Z).
Retry was in mid-attempt `_wait_engines 40` at poll=24/40 (~4 min to ABORT)
while king health budget still had ~150/180 polls left.

**Action:** kill retry `$0` pid=20802 (not watcher). Watcher relaunched
`retry_h90_n80.sh` pid=25144 → fresh `_wait_engines 120` @17:15:46Z poll=0/120.
King recover untouched (pid=22446, isolated TCACHE util=0.72).

**Check next:** `h90_king_recover_pass340.done` + `:8001=200` → n80 a203 + arm mid304.
