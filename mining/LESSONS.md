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
