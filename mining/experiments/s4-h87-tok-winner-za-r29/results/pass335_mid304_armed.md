# H87 pass335 — mid304 armed on live n80

## Facts
- n80 already live (sim pid earlier ~24118) block_hash=a203 vs Tok331102.
- Progress @16:34:48Z: challenger 8/80, king 5/80.
- Ports t/k/c all 200. Chall TCACHE isolated
  `/root/.triton/isolated/h87_chall_p260_a1_1786206280_21851` mode=555.
- mid304 was **not** armed (recover264 only rearms form+n80).
- Armed `watch_mid_n80_bare_tcache_pass304.sh` pid=25109 via remote file
  (argv1 match; not SSH `-c` false positive).
- Log: START @16:34:34Z → "sim alive — enter watch loop".

## Next
Await `h87_decision.json` / progress→80. Keep mid304.
