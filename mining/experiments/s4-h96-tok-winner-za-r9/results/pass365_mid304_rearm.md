# Pass 365 — H96 mid304 rearm

**When:** 2026-08-08T19:54:11Z
**Pod:** mine-h96-1 (golden-matrix-af)

## Symptom
- Prior mid304 exited `sim gone` @19:50:30Z (fired=0) between n80 attempts.
- New n80 live @pid=25241 (`block_hash=b203…`) with engines 200/200/200, no mid304.

## Action
- Rearmed `watch_mid_n80_bare_tcache_pass304.sh h96 s4-h96-tok-winner-za-r9` pid=25760.
- Log: `sim alive — enter watch loop`.
- Chall TCACHE isolated: `/root/.triton/isolated/h96_chall_p260_a1_1786217327_19770`.
- Progress at rearm: challenger 3/80, king 1/80.

## Next
Await `h96_decision.json`. Do not launch more r-neighbours.
