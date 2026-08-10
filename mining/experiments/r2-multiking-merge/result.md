# R2 result log

## p1885 — pure-Reason near-miss recompute + prefetch
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,105.
- R1c still training (~52/132); decision not ready — used idle CPU/network.
- Recomputed paired Reason from public duel `lpC_yc_za−lpC_yc_e` (ignore S\* pub margins):
  - **chal-00425** `0pentensor/…-awesome-v6@f479a24d` — pub m=+0.0174 → **Reason m=+0.0108 z=+2.75 hr≈0.92×**.
  - chal-00415 diane-cool — Reason m=+0.0106 z=+1.92 hr≈0.64×.
  - chal-00436 (Reason formula stamp) tojointhecommunity — m=+0.0067 z=+1.36.
- Launched `launch_prefetch_nearmiss.sh` pid **99742** → `/root/logs/r2_prefetch_nearmiss.log`.
- Artifact: `artifacts/reason_nearmiss_p1885.json`.
- Next: harvest R1c decision; if weak → R2 α→n80 then fuse 0pentensor parent.

## p1884 — R2 lane-free gate: pgrep → pidfile
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,116.
- R1c train ~47/132 (pid96239); R1c merge waiter 97305; engines 200@65536.
- Proved `pgrep -af 'train_lora.py|merge_lora.py|launch_r1c_merge'` matches SSH diagnostics (false-positive busy) — would stall α→n80 after R1c decision.
- Patched `launch_r2_merge_reload_sim.sh` → `/root/logs/r1c_train.pid` + `r1c_merge_reload.pid` + `kill -0`.
- Synced; killed old waiter **85408** by PID; relaunched **99246** (premerge reused).
- Next: harvest `r1c_lora_decision.json`; if below bar, R2 α→n80 proceeds without pgrep stall.

## p1876 — premerge harvested (READY for α→n80)
- Contract `weight_version_key=3`; king Tok af10; engines **200/200/200** @65536; burn$64/h; bal~$124,328.
- `/root/logs/r2_premerge.done`: `OK 2026-08-10T18:47:53Z max_abs_delta=0.27734375 n_keys=1026`.
- Artifact `/root/r2_out/alpha_tok_talent_kevin`: 2×33 GiB shards + index + multimodal sidecars; meta confirms distinct from Tok.
- R2 α waiter pid **85408** still on wait-r1-lane (r1b/r1c decisions absent) — will reuse premerge (no re-blend).
- R1b train **~93/126** loss~0.33; waiters 80760/83033 alive. ETA train ~0.35h then merge+n80.
- Next: harvest R1b decision; Stage-5 only if headroom ≥ 1.5×; else R1c then R2 α n80.

## p1875 — premerge healthy + meta stamp fix
- Contract `subnet.weight_version_key=3`; king Tok af10; burn$64/h; bal~$124,395.
- Prefetch **DONE** @18:42Z (TalentPigs+kevin). R1b ~**48/126**; lane pids untouched.
- α-merge running: wrote `model-00001-of-00002.safetensors` (**33 GiB**); blending shard2 (598 keys).
- Bugfix: `launch_r2_premerge.sh` looked for `merge_meta.json`; actual file is `merge_alpha_meta.json`. Patched local+pod; armed `fix_premerge_stamp.sh` pid **86376**.
- Next: harvest `r2_premerge.done` (with max_abs_delta) then R1b/R1c/R2 decisions.

## p1874 — CPU premerge overlapped with R1b
- Contract `weight_version_key=3`; king Tok af10; engines 200@65536; burn$64/h.
- R1b ~**42/126**; R1 lane pids untouched (79866/80760/83033).
- Added `launch_r2_premerge.sh`: waits prefetch → equal-α blend → `/root/logs/r2_premerge.done`.
- Patched `launch_r2_merge_reload_sim.sh` to **reuse** premerge (skip re-blend).
- Killed old waiter 84752 by PID; armed premerge pid **85406** + waiter pid **85408**.
- Prefetch: TalentPigs OK; kevin shard1 ~**28 GiB** incomplete (still downloading).
- Next: harvest R1b/R1c/R2 decisions; Stage-5 only if headroom ≥ 1.5×.

## p1873 — α-merge recipe staged + waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,407.
- R1b still **~37/126**; R1b waiter+R1c chain still armed; engines 200@65536.
- Wrote `merge_alpha.py` (CPU equal-α Tok:Talent:Kevin) + `launch_r2_merge_reload_sim.sh`.
- Armed waiter pid **84752** (log `/root/logs/r2_merge_reload.log`).
- Prefetch still running: TalentPigs ~**66 GiB** / 23/25 files; kevin not started yet.
- Decision artifacts (when ready): `/root/affine_data/r2_alpha_reason_sim.json`, `r2_alpha_decision.json`.
- Next: harvest R1b/R1c/R2 decisions; Stage-5 only if headroom ≥ 1.5×.

## p1872 — parent prefetch launched (CPU only)
- Started `launch_prefetch_parents.sh` pid **83501**:
  - TalentPigs/affine-5ekxlcg3fx-abc@dbfbb3e2…
  - kevin954/Affine-5dfqbbh8ev-sft@6a5815fa…
- Log `/root/logs/r2_prefetch_parents.log`; done stamp `/root/logs/r2_prefetch_parents.done`.
