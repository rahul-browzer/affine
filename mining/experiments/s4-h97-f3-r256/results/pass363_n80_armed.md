# H97/F3 pass363 — salvage DONE → n80 + mid304

## Facts
- Prior: chall salvage prefreeze n_so 16→22 after writable-w1 ENOENT; relaunch
  same TCACHE mode=555; health=200 @19:44:56Z poll=30.
- Recover: settle→salv_w1/w2/w3 all code=200; frozen launcher.so count=22
  mode=555; DONE_LAUNCH @19:46:08Z; rearmed form pid=20979 + watch_n80
  pid=20985 → retry → `run_sim_duel.py` local-h97 a203.
- Completions probe :8002=200 post-freeze.
- mid304 armed @19:46:40Z (recover does not rearm it) pid=21338;
  log: sim alive — enter watch loop. Engines T/K/C 200/200/200.
- TCACHE=`/root/.triton/isolated/h97_chall_p260_a1_1786217606_16759`.

## Next
Await n80 → `h97_decision.json`. Screen >+0.015 → CONFIRM k=4; else REFUTE.
