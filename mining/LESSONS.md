# LESSONS — durable findings (Reason v3 era)
Hard-won knowledge, one line each. **Cap 150 lines.** Detail → `experiments/`.
S\* v2 era (retired 2026-08-10) → `archive/legacy-sstar-v2/` — ops only, not strategy.

## Scoring (Reason v3, weight_version_key=3)
- **Reason = lpC(y_C|z_A) − lpC(y_C|∅)** per pair; miner score = mean. Formerly called Λ2.
- **Crown:** paired mean(Reason_c − Reason_k) > **k_sigma · SE** with k_sigma=3. No min_margin, no min_se.
- **No gates on score or validity.** causality / leakage / bank / r / baseline band are telemetry only.
- Miner-side terms (L1lift, lpA, calibration r) do **not** enter Reason. Do not train them as objectives.
- Absolute Reason is only comparable within one duel slice. Use paired margin vs the live king.
- Confirm `weight_version_key` from `api/v1/contract` every pass until automatic.

## Strategy under Reason
- Shape `z_A` so the frozen teacher likes its own `y_C` more with the thought than without.
- Teacher refs / distillation data remain the free starting point; score is teacher-side only.
- Pre-fork S\* margins and "clip-L1 decides duels" results do not transfer — re-measure under Reason.
- Submit when sim margin clears ~**1.5 × (3·SE)** on a fresh slice (slice-variance headroom), not the old 0.04 S\* gate.

## Ops (still true — details in legacy archive if needed)
- Live corpus is **schema v2** (Parquet index + chunks). `sync_corpus.sh` must accept `turns_index.parquet`, not only `turns.jsonl`.
- Schema-v2 Reason sim needs **pandas + pyarrow** in the pod venv (`CorpusSync` reads parquet). vLLM-only installs miss them — pin in `restore_warm_stack.sh`.
- Pods: `mine-*` only; never `rm` non-mine; always `--ttl`; reconcile `lium ps` first every pass.
- Heavy work on pods; push to HF `unconst` with `source mining/.env` → `export HF_TOKEN`.
- King is multimodal Qwen MoE — CausalLM save can drop `model.visual.*`; restore before vLLM.
- Tok af10 ships visual tensors inside language shards (index→lang is OK) but **no** `preprocessor_config.json` — derive from `processor_config.json` before vLLM.
- B300 SM10.3 + vllm 0.22.1: patch `flash_fwd_sm100` upper bound to `Arch.sm_121f` before serve or every engine dies at profile_run.
- Prefer COUNT=8 verified from `lium ls`; bare `yes|` floods SSH — use `-y`.
- Never `pkill -f` over SSH (matches your session). Kill by PID. Seed chall Triton from live king TCACHE when recovering.
- Never edit a running `restore_warm_stack.sh` on the pod (bash re-reads mid-file); write `.new` and swap after exit.
- Mid-run edit failure mode: after a long heredoc, bash can die with `syntax error near unexpected token '**kw'` (Python seen as bash). Kill by PID, install `.new`, re-run — stamps skip re-download.
- After any restore kill/relaunch, **re-check the n80 watcher PID** — pid3045 died silently (log froze at iter=60) while engines were still loading; without relaunch, PROMPTABLE would never start the sim.
- `/root/mine.env` must **export** vars (or `set -a` before `source`); bare `HF_TOKEN=…` does not reach the python child — sim then hits unauth HF Hub and stalls on tokenizer download before first progress.
- Public duel rows expose Reason components as `lpC_yc_za` / `lpC_yc_e` on `king_rows[].pairs[]`; rank SFT targets by that delta, not by L1lift/lpA.
- Join high-Reason completions to schema-v2 corpus prefixes via `CorpusSync.materialize_turns` (index hit 1403/1403 on epoch 7) before LoRA; completions alone are not trainable.
- Crown pod venv is **uv**-managed (`uv pip install --python /root/venv/bin/python …`); bare `pip` / system python hits PEP 668.
- R1 SFT `max_len=8192` fit-filter kept only **527/1403** high-Reason rows (rest truncated out); sample0 thought-supervised tokens can be tiny (45/1461) — watch loss signal / raise max_len if margin stays flat.
- After LoRA train: merge on freed GPUs 6–7, kill chall by **PID file only**, reload `/tmp/r1_lora_merged` with same vLLM knobs as restore (tp=2 util=0.72), then fresh n80 — do not yank chall mid-baseline.
- Crown engines must use **`max_model_len=65536`** (live `affine.toml`); **32768** knife-edges ~31k prefixes + 1792 gen → `ContextLengthError` aborts whole n80 gather (H64 died 52/80).
- B300 serve env = restore recipe: `CUDA_HOME=…/nvidia/cu13` + `VLLM_USE_FLASHINFER_*=0`. **Do not** symlink `/usr/local/cuda`→cu13 and **do not** put `cu13/bin` on `PATH` (flashinfer CCCL ↔ nvcc 13.3 "headers incompatible").
- LoRA `merge_and_unload` via `AutoModelForCausalLM` writes **text-only** `config.json` (`Qwen3_5MoeForCausalLM`); vLLM needs base multimodal config (`Qwen3_5MoeForConditionalGeneration`). Always overwrite `config.json` from king base with `shutil.copyfile` / `cp -L` (HF snapshot symlinks break if copied as links).
- CausalLM merge also **drops `model.visual.*` weights** (index 693 vs king 1026). Restoring config alone is not enough — graft visual tensors from base (`graft_visual_weights.py` / `merge_lora._graft_visual_weights`) into `model-visual.safetensors` or vLLM fails "weights were not initialized".
- **unconst private HF storage ≈ one ~65GiB merged king**; private `upload_folder` dies with "Private repository storage limit reached". Push pre-submit artifacts **public** (or delete old private merged first).
- **unconst public HF storage is also capped** — commit fails with "exceeded your public storage space" after xet finalize (looks like a hang). Purge old public `Affine-5czsc*-h*-merged` / mock kings before each ~65 GiB push; verify Hub sibling count after DONE.
- R1 LoRA@8192 (527/1403 high-Reason rows, r=16, 1 epoch) vs Tok af10: Reason margin **+0.0005** (z=0.105) — noise, not crown; need stronger/longer-ctx distill or different parents before Stage-5.
- SFT fit-filter keep rates on epoch-7 high-Reason set (budget=max_len×2.5 chars): 8192→527/1403, **16384→1006**, 24576→1374, 32768→1394 — R1b uses 16384 first (OOM risk at longer).
- Thought-loss **nsup** (supervised tokens after fence mask) @16384 on R1b keep-set: med **54**, mean 72; only **176/1006** have nsup≥100 — char budget alone starves the loss; filter `sft_high_reason_nsup100.jsonl` (nsup_med=137) before next LoRA (R1c).
- R1c on 176 nsup≥100 rows @ grad_accum=8 is only ~22 steps/epoch — use **EPOCHS≈6** (~132 opt-steps) so the high-signal subset matches R1b's update budget; arm `launch_r1c_merge_reload_sim.sh` after train starts.
- While R1b train+n80 is in flight, arm `launch_r1b_to_r1c_chain.sh` so a below-bar decision auto-starts R1c (EPOCHS=6) + merge waiter — avoid idle GPU hours waiting for the next Ralph pass.
- Prefetch R2 reign parents (TalentPigs/kevin) on crown CPU/network while R1b owns GPUs 6–7 — download does not disturb TK engines or train; ready the merge lane before R1 resolves.
- R2 equal-α merge can be **CPU-only** on crown (~2 TB RAM): blend safetensors by key with Tok as layout/config donor; refuse if `max_abs_delta==0` (weight-identical). Arm `launch_r2_merge_reload_sim.sh` to wait prefetch + R1c decision before chall reload.
- Overlap R2 CPU α-merge with R1 train via `launch_r2_premerge.sh` (no GPU); stamp `/root/logs/r2_premerge.done` so the α→n80 waiter reuses the blend and only does chall reload+sim.
- `merge_alpha.py` writes **`merge_alpha_meta.json`** under `/root/r2_out/alpha_tok_talent_kevin/` (not `affine_data/`) — stamp scripts must read that name (not `merge_meta.json`) or `r2_premerge.done` loses `max_abs_delta` / `n_keys`.
- Equal-α Tok×Talent×kevin premerge on epoch-7 parents: **max_abs_delta=0.277**, identical_frac≈0.44, 66 GiB — distinct enough for α→n80 (refuse only if max_abs_delta==0).
- Crown n80 @65536: stock `vllm_client` **180s×3** can `ReadTimeout` on teacher sample mid-gather (~76/80 observed) — patch mining_src to **600s×5** before long sims (`patch_vllm_timeout.py` / `relaunch_r1b_n80.sh`).
- Relaunch sims with `/root/venv/bin/python` + `set -a; source mine.env` — bare `python` misses pyarrow and dies before first progress.
- Overlap next LoRA train on **GPUs 6–7** while n80 gather uses vLLM on 0–5 — saves an idle hour; merge waiter may arm early **only if** it waits for `r1b_lora_decision.json` (and SKIPs when headroom≥1.5×) before killing chall:8002.
- `launch_r1c_merge_reload_sim.sh` without an R1b-dec gate will yank `:8002` the moment train finishes — fatal if n80 is still gathering; always gate merge/reload on the prior lane’s decision file.
- Guard “already training” with **pidfile `kill -0`**, not `pgrep|grep r1c` — SSH/`bash -c` command lines contain the needle and false-positive skip the launch.
- R1b LoRA@16384 on 1006 high-Reason rows **hurt** Reason vs Tok: margin **−0.0135** (z=−2.45, n_paired=75); chall mean_len_z 569 vs king 406 — longer/noisier thoughts, fewer scored pairs (195 vs 311). Char-keep ≠ teacher-helpful.
- R1b→R1c chain correctly LAUNCHed on negative headroom and skipped double-train via pidfile while merge waiter stayed armed for post-train reload.
- R2 α→n80 lane-free gate must use **r1c_train.pid / r1c_merge_reload.pid + kill -0**, never `pgrep -af 'train_lora|launch_r1c_merge'` — SSH diagnostics match the needle and stall R2 after R1c decision.
- Many 2026-08-10 duels still stamp `ranking_formula=Λ2+L1lift` in the gzip; **recompute Reason from `lpC_yc_za−lpC_yc_e`** before trusting published margin/z (chal-00425 pub +0.017/z2.79 → Reason +0.0108/z2.75; still best near-miss ~0.92×).
- Best live Reason near-miss vs Tok af10: `0pentensor/Affine-5dflhtkufw-awesome-v6@f479a24d452f` (hr≈0.92×) — prefer as merge/SFT parent over older S\*-margin leaders.
- Overlap Tok×near-miss CPU α-premerge (`launch_r2b_tok_awesome_premerge.sh`) with R1c train + nearmiss download — same pattern as R2 Talent/kevin premerge; stamp `r2b_premerge.done` before chall reload.
- Prefetch scripts: mark optional HF parents non-fatal — `diane613/…-cool` is **gated 403** for unconst; a hard fail after awesome-v6 OK left `r2_prefetch_nearmiss.done` unstamped and stalled R2b (p1887).
- Duel gzips store king under **`request.king_repo`** (no top-level `king`); filter near-misses on that field or you mix pre-Tok margins into the ranking.
- HF `model_info`/API **200** and even public `config.json` ≠ weight access — probe `model.safetensors.index.json` before arming prefetch. Gated for unconst vs Tok: diane cool/new, nvidia, Tok af16/af8, aurora.
- Among completed duels vs Tok af10, the **only downloadable Reason+ parent** is `0pentensor/…-awesome-v6` (hr≈0.92×). Tok×awesome equal-α premerge: max_abs_delta=**0.006** (tiny but >0; not weight-identical).
- Equal-α Tok×awesome barely moves weights (Δ≈0.006) — queue a **skew** blend (Tok0.25/awesome0.75) as R2c before burning another GPU n80 on near-identical chall.
- Confirmed gated for unconst (index probe + snapshot_download): Tok af16/af8, aurora prince — do not re-arm R2c parent prefetch on those.
- R2c skew Tok0.25/awesome0.75 CPU premerge: max_abs_delta=**0.00899** (vs equal-α 0.006) · identical_frac=0.45 · 70 GiB · ~5 min — still tiny but not weight-identical; n80 still required.
- After Tok×awesome blends stay Δ≪0.01, queue **pure awesome-v6** as chall (R2d) before more α knobs — published hr≈0.92× is the transfer question; derive `preprocessor_config.json` like Tok.
- TalentPigs×awesome-v6 skew (0.25/0.75) CPU premerge: max_abs_delta=**0.626** vs Tok×awesome Δ≈0.006–0.009 — non-Tok layout donor escapes near-identical blends; queue as R2e after pure-awesome n80.
- Skip Tok×awesome equal-α/skew n80 when Δ≪0.01 — stamp `r2_weak_lanes_skipped.done` + below-bar stubs; **kill prior waiters before writing stub decisions** (old R2d raced on R2C stub and killed chall).
- Do **not** use `SKIP_R2C` done text to jump the queue — R2d/R2e honor SKIP_* and cascade-exit; use weak_skip stamp + R1c-lane gate instead.
- R1c nsup≥100 / EPOCHS=6 LoRA vs Tok: margin **−0.0171** (z=−2.75, hr −0.92×, n_paired=67) — worse than R1b; king-init high-Reason SFT family closed for this reign; pivot to R2d/R2e parents.
- Near-miss rescan p1896 (chal≥405, per-turn mean Reason): **awesome-v6 still only DL Reason+** (hr≈0.92×); chal-00438 aurora prince gated hr≈0.17×; chal-00439 darius3th DL but hr≈−1.79× — do not prefetch as parent.
- While R2d n80 burns GPU, arm next non-Tok×awesome CPU skew (**kevin×awesome** R2f) so R2e→R2f has no idle merge gap; kevin snapshot already on crown from early prefetch.
- kevin×awesome skew (0.25/0.75) max_abs_delta=**0.00899** ≈ Tok×awesome — reign parents that share awesome-v6 weights stay near-identical; only Talent×awesome (Δ=0.626) is a real blend; WEAK_SKIP kevin n80 (p1898).
- R2d pure awesome-v6 vs Tok af10: margin **+0.00223** (z=0.66, 3·SE=0.0102, hr **0.22×**, n=80) — published near-miss hr≈0.92× did **not** transfer as chall; need non-Tok blend (R2e) or stronger parents, not more α knobs on awesome alone.
- Duel gzip pairs lack `turn_id` — id is on `king_rows[]`/`challenger_rows[]`; Reason scan = mean(lpC_yc_za−lpC_yc_e) **per row** then pair turns (repo fields = `request.challenger_repo` / `challenger_revision`).
- p1901: chal-00433 `vera6/…-cc` Reason hr≈**−0.21×** (DL, not a parent); live chal-00440 `saysth/…-v9a@6e13f365…` **weights_ok** — prefetch while R2e runs; do not merge until post-verdict Reason+.
- p1902: saysth chal-00440 HF snapshot cached in **~4.8 min** (~65 GiB); arm CPU `watch_chal00440_reason.sh` to stamp Reason hr from duel gzip so R2g does not wait on Ralph cadence.
- Arm R2g Talent×saysth CPU premerge as a **gated waiter** (hr>0 on `chal00440_reason.json`) while R2e n80 runs — SKIP stamp if Reason−; avoids idle merge gap without blending a losing parent.
- After R2g premerge is gated, also arm `launch_r2g_merge_reload_sim.sh` (wait premerge.done|skip + R2e decision/lane) so a Reason+ saysth blend auto-reloads chall→n80 without idle GPU after R2e.
- p1893 `r2_alpha_decision.json` SKIP_WEAK was for **Tok×awesome** (Δ≈0.006–0.009) — it does **not** cover Tok×Talent×kevin (Δ=0.277). That blend was never n80'd; arm as R2h after R2e (take GPU while 440 pending) and make R2g wait on `r2h_ttk_reload.pid`.
