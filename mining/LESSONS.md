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
