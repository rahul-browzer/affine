# R2 result log

## p1890 — R2c skew PREMERGE DONE
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,060.
- Harvested `/root/logs/r2c_premerge.done`: **OK** 21:12:32Z · w_tok=0.25 w_awesome=0.75 · max_abs_delta=**0.008987** · n_keys=1026 · identical_frac=0.452 · 70 GiB @ `/root/r2_out/alpha_tok_awesome_v6_skew`.
- R2c n80 waiter **102560** past premerge → wait-r2b-lane (needs R2b decision + lane free).
- R1c still ~84/132 (no decision yet); engines 200@65536 untouched.
- Incremental chal≥436 Reason scan: chal-00437 syntaxs0cerer hr≈−0.13× (downloadable, not a parent); 00438/00439 pairing incomplete / negative — **awesome-v6 still best downloadable Reason+**.
- Artifacts: `artifacts/r2c_skew_merge_alpha_meta.json`, `r2c_premerge.done`, `reason_nearmiss_p1890.json`.
- Next: harvest R1c; if weak → R2→R2b→R2c skew n80.

## p1889 — R2c skew Tok×awesome premerge + n80 waiter
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,071.
- R1c still ~76/132 — no decision; R2b equal-α Δ≈0.006 is almost Tok → arm stronger pull.
- Wrote+synced `launch_r2c_tok_awesome_skew_premerge.sh` (W_TOK=0.25 W_AWESOME=0.75 → `/root/r2_out/alpha_tok_awesome_v6_skew`) pid **102471**.
- Wrote+synced `launch_r2c_merge_reload_sim.sh` pid **102560** (waits R2b below bar → chall reload → n80 → `r2c_alpha_decision.json`).
- Stamped failed af16/aurora prefetch DONE (n_ok=0 gated) so next pass does not re-chase.
- Pre-reg: submit only if headroom ≥ 1.5×(3·SE); refuse if max_abs_delta==0.
- Next: harvest R1c; if weak → R2 → R2b → R2c skew n80.

## p1888 — R2b premerge DONE + vs-Tok near-miss access scan
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,082.
- R1c still ~73/132 — no decision; harvested R2b CPU premerge instead.
- `/root/logs/r2b_premerge.done`: **OK** 21:02:18Z · max_abs_delta=**0.005997** · n_keys=1026 · identical_frac≈0.45 · 66 GiB @ `/root/r2_out/alpha_tok_awesome_v6`.
- R2b n80 waiter **101161** past premerge → **wait-r2-lane** (r1c_dec=n).
- Recomputed pure Reason for all evals with `request.king_repo==Tok af10`; probed weight download:
  - Best / only downloadable Reason+: **awesome-v6** hr≈0.92× (already in R2b).
  - Gated 403: diane cool/new, nvidia, Tok af16/af8, aurora (API 200 ≠ weights).
- Artifacts: `artifacts/reason_nearmiss_p1888.json`, `reason_vs_tok_p1888.json`.
- Next: harvest R1c; if weak → R2 α n80 then R2b n80.

## p1887 — nearmiss DONE unblocked + R2b n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,094.
- Prefetch pid 99742 **died** after awesome-v6 OK: `diane613/…-cool` **GatedRepoError 403** → no `r2_prefetch_nearmiss.done` → R2b stuck.
- Patched `launch_prefetch_nearmiss.sh` (optional parents non-fatal); stamped DONE (awesome-only); R2b **100240** resumed α-merge shard1.
- Wrote+synced+armed `launch_r2b_merge_reload_sim.sh` pid **101161** → waits `r2b_premerge.done` + R2 lane → chall:8002 reload → n80 → `r2b_alpha_decision.json`.
- R1c ~61/132; engines 200@65536 untouched.
- Next: harvest R1c; if weak → R2 α n80 then R2b n80.

## p1886 — R2b Tok×awesome CPU premerge armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,105.
- R1c still ~56/132 — no decision yet; used idle CPU lane.
- Wrote+synced `launch_r2b_tok_awesome_premerge.sh`: wait `r2_prefetch_nearmiss.done` → equal-α Tok×awesome-v6 → `/root/r2_out/alpha_tok_awesome_v6` + `r2b_premerge.done`.
- Armed pid **100240** (log `/root/logs/r2b_premerge.log`). Prefetch still on awesome-v6 (~26 GiB, 10/11 files).
- Pre-reg: later n80 submit only if headroom ≥ 1.5×(3·SE); refuse if `max_abs_delta==0`.
- Next: harvest R1c; if weak → R2 α n80 then R2b reload+n80 after premerge stamp.

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
