# s4-h2-merge progress

- 2026-08-06T23:44Z download parents DONE (kevin hub cache + pandora at `$HF_HOME/models--*`)
- 2026-08-06T23:44Z first merge FAILED: resolve_snapshot only checked `$HF_HOME/hub/`
- 2026-08-06T23:50:12Z merge DONE after dual-layout fix — see `merge_meta.json`
- 2026-08-06T23:51:48Z re-serve launched (local merge, no Hub revision); waiting READY then sim
- 2026-08-06T23:57:20Z serve READY (king+chall health 200 after ~5.5 min load)
- 2026-08-06T23:57:4xZ `run_sim_duel.py --save-artifact` nohup'd → pid `/root/logs/h2_sim.pid` (=68843); log `/root/logs/h2_sim.nohup`; out `/root/affine_data/h2_sim_result.json`
- 2026-08-07T00:02Z pass 12 poll: pid 68843 ALIVE; engines 8000/8001/8002 health 200; log progress `[sim] king 5/80`, `[sim] challenger 5/80`, `[sim] challenger 10/80`; teacher GPUs 0–1 ~100% util; no `h2_sim_result.json` yet; king still kevin S≈0.03956
