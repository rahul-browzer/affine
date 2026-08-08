# H80 king315 recover — pass 315

## Timeline
- p314 isolated TCACHE → KING PROMPTABLE @13:39:45Z (util=0.80)
- n80 attempt 1 @~13:40 → king EngineDead **CUDA OOM** @13:41:05Z
  (tried allocate 7.58 GiB; 6.23 GiB free on GPU0 of TP pair)
- :8001→000; chall+teacher stayed 200
- p315: king-only re-fire **util=0.72** isolated TCACHE
  `king_recover_pass315.sh` pid36456 · TCACHE
  `/root/.triton/isolated/h80_king_p315_1786196616_36456`
- mid304 rearmed; form+retry watchers still armed

## Next
Await `h80_king_recover_pass315.done` / KING PROMPTABLE → n80 a203.
If exit3 OOM again → try util=0.68 or enforce_eager.
