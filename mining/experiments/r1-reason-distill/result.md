# R1 result log

## p1880 — R1c train overlapped with R1b n80 gather
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,183.
- R1b n80#2 healthy @**16/80** (pid95336, 600s×5); engines 200/200/200; GPUs 6–7 were idle.
- Pre-started R1c train: 176 nsup100 rows × EPOCHS=6 on CUDA 6,7 → pidfile **96239** / train_lora **96252**; out `/root/r1_out/lora_tok_high_reason_r1c`.
- Patched `launch_r1b_to_r1c_chain.sh` to skip train relaunch when pidfile alive (avoid double-launch after decision).
- Do **not** merge/reload R1c until R1b n80 frees chall:8002.
- Next: harvest `r1b_lora_decision.json`; Stage-5 only if headroom ≥ 1.5×(3·SE).

## p1879 — R1b n80#1 ReadTimeout; patched + relaunched
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,194.
- n80#1 (slice `b6a1f946…`, pid92752) reached ~76/80 then died: `httpx.ReadTimeout` in teacher `sample` (stock client 180s×3).
- No `r1b_lora_decision.json` written; merge waiter exited; R1c/R2 waiters still armed.
- Patched `/root/mining_src/affine_pkg/evalsrv/vllm_client.py` → Timeout **600s**, connect 30s, **5** attempts (`patch_vllm_timeout.py`).
- Relaunched via `relaunch_r1b_n80.sh` (venv python + mine.env): bash pid **95237**, sim pid **95336**, slice `b99bfc9c…`, progress king **1**/80 @20:14Z.
- Engines still 200/200/200 @65536; chall `/tmp/r1b_lora_merged` unchanged.
- Next: harvest `r1b_lora_decision.json`; Stage-5 only if headroom ≥ 1.5×(3·SE).

## p1878 — R1b train+merge DONE; n80 live (~10/80)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,250.
- Train finished **2026-08-10T19:35:55Z** (126/126, elapsed ~4839s, adapter `/root/r1_out/lora_tok_high_reason_r1b/adapter`).
- Merge+graft finished **19:38:43Z** → `/root/r1_out/r1b_lora_merged` (visual_keys=333); chall :8002 pid88838.
- Engines **200/200/200** @65536; n80 launched **19:42:28Z** slice `b6a1f9464448f214…`.
- Progress @19:46Z: challenger **10**/80, king **9**/80; pid **92752**; decision file not yet written.
- R1b→R1c chain pid83033 + R2 α waiter pid85408 still armed (waiting decision / R1 lane).
- Next: harvest `r1b_lora_decision.json`; Stage-5 only if headroom ≥ 1.5×(3·SE).

## p1870 — R1c hardened (EPOCHS=6) + merge→n80 waiter staged
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,429.
- R1b still training **23/126** @~34s/it loss~0.34; waiter pid80760 waiting; engines 200@65536.
- R1b decision not ready (~0.9h train left) — used idle to fix R1c under-training:
  - 176 rows × grad_accum=8 ⇒ ~22 steps/epoch at EPOCHS=1 (too weak vs R1b's 126).
  - `launch_r1c_train.sh` now defaults **EPOCHS=6** (~132 opt-steps).
  - Staged `launch_r1c_merge_reload_sim.sh` → `/root/affine_data/r1c_lora_decision.json`.
- Synced both scripts to `/root/mining_src/r1-reason-distill/` (bash -n clean). Do **not** start until R1b frees GPUs 6–7.
- Next: harvest R1b decision; if weak, launch R1c + arm its waiter.

## p1869 — thought-nsup starvation diagnosed; R1c filter ready
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,429.
- R1b train live **16/126** @~34s/it loss~0.41; waiter pid80760 still waiting; engines 200@65536.
- Probed thought-only supervised tokens @16384 on R1b keep-set (`probe_supervised_tokens.py`):
  - nsup med/mean/min/max = **54 / 71.8 / 13 / 1224**
  - nsup<50 = **435/1006**; nsup≥100 = **176/1006**; nsup≥200 = 44
  - Explains R1 noise margin: char fit-filter ≠ thought signal under fence mask.
- Built `filter_nsup_sft.py` → `/root/r1_data/sft_high_reason_nsup100.jsonl` **176** rows (nsup_med=137, reason_med=0.043).
- Staged `launch_r1c_train.sh` (do not start until R1b frees GPUs 6–7).
- Artifacts: `artifacts/r1b_nsup_probe.log`, `artifacts/r1c_nsup_filter_meta.json`.
- Next: harvest R1b decision; if weak, launch R1c on nsup100 set.

## p1868 — R1b merge→reload→n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,451.
- R1b train live: fit-filter **1006/1403** @16384; steps **3/126** @~42s/it (ETA ~1.4h); GPUs 6–7.
- Staged + launched `launch_r1b_merge_reload_sim.sh` pid **80760**:
  - waits `/root/logs/r1b_train.done` + adapter
  - merge+graft → `/root/r1_out/r1b_lora_merged` → `/tmp/r1b_lora_merged`
  - kill chall by PID, reload :8002 @65536, fresh n80 → `/root/affine_data/r1b_lora_decision.json`
- TK+old-LoRA chall still 200@65536 until waiter swaps chall post-train.
- Next: harvest `r1b_lora_decision.json`; submit only if headroom ≥ 1.5×(3·SE).

## p1867 — R1b train launched (max_len=16384)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,451.
- Fit-filter probe: max_len 8192→527/1403; **16384→1006/1403**; 24576→1374 (deferred — OOM risk).
- Staged `launch_r1b_train.sh` + parameterized `launch_train.sh` (`MAX_LEN`/`OUT`/`DONE_STAMP`).
- Launched pid **79866**: CUDA 6,7 · base Tok `eb8bf9a…` · out `/root/r1_out/lora_tok_high_reason_r1b` · log `/root/logs/r1b_train.log` · done `/root/logs/r1b_train.done`.
- @18:15Z loading weights (GPU6/7 ~34GB); TK+old-LoRA chall still 200@65536 on 0–5.
- Next: harvest `r1b_train.done` → merge+graft → reload chall → fresh n80; submit only if headroom ≥ 1.5×(3·SE).

## p1866 — LoRA n80 harvest: SIGNAL_POS_BELOW_3SE (no submit)
- Contract `weight_version_key=3`; king Tok af10 `eb8bf9a…`; epoch 7; slice `720854ee…`.
- `r1_lora_decision.json` @18:12:44Z: **SIGNAL_POS_BELOW_3SE**.
- margin **+0.000516** · SE **0.004907** · z **0.105** · 3·SE **0.01472** · headroom_vs_3se **0.035** (≪1.5).
- reason_c **−0.006087** vs reason_k **−0.006381** (n=80); challenger_wins=false.
- HF public `unconst/Affine-5czsc2fc98-r1lora@569a68be…` stays pre-submit only — **do not register/submit**.
- Artifacts copied to `artifacts/r1_lora_{decision,reason_sim}.json`.
- Next: R1b — rebuild SFT @ higher `max_len` (8192 kept only 527/1403) and retrain on warm crown GPUs 6–7.

## p1865 — public HF quota purge → r1lora push DONE
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,496.
- n80 pid76726 @ **chall 44 / king 46**; engines still 200@65536.
- Public push pid79102 failed at Hub commit: **exceeded public storage space** (xet had finalized; looked like a hang).
- Deleted public junk: `Teutonic-LXXX-mock-{king,chall}` (~153 GiB each) + 8 old `Affine-5czsc*-h*-merged` (~67 GiB each) ≈ **~840 GiB**.
- Relaunched push pid **79270** → **DONE** `569a68bea1e39d9333c34447ab4f9d04120d21b1` (public, 14 files, 65.41 GiB, multimodal+visual).
- Next: harvest `r1_lora_decision.json`; submit only if headroom ≥ 1.5×(3·SE) against that revision.

## p1864 — HF private push failed → public retry
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,529.
- n80 pid76726 @ **chall 22 / king 21**; engines still 200@65536.
- Private push pid78057 **FAILED**: `Private repository storage limit reached` on commit.
- Freed private quota: deleted `Affine-5czsc2fc98-h5b-merged` (~65.4 GiB) + tiny private adapters/probe; flipped `Affine-5czsc2fc98-r1lora` **public**.
- Relaunched push pid **78558** with `--public` (scripts updated). Meta may show `FAILED_THEN_RETRYING_PUBLIC` until upload finishes.
- Next: harvest `r1_lora_decision.json`; submit only if headroom ≥ 1.5×(3·SE).

## p1863 — HF pre-push while LoRA n80 runs
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,529.
- Engines still **200/200/200** @65536; n80 pid76726 @ **chall 15 / king 16**.
- Probed HF private write OK (`Affine-5czsc2fc98-r1lora-probe`).
- Launched `push_r1_lora.py` pid **78057**: uploading `/tmp/r1_lora_merged` **65.4 GiB** → private `unconst/Affine-5czsc2fc98-r1lora` (not a submission).
- Meta target: `/root/affine_data/r1_lora_hf_push.json`. Scripts: `push_r1_lora.py`, `launch_hf_push.sh`.
- Next: harvest `r1_lora_decision.json`; submit only if headroom ≥ 1.5×(3·SE).

## p1862 — LoRA n80 confirmed live under 65536
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,541.
- Engines **200/200/200** @ `max_model_len=65536`; GPUs 0–5 ~95–97%.
- Sim pid **76726** (`local-r1-lora-20260810T173551Z`, `block_hash=720854ee…`, epoch 7).
- Progress @17:39Z: challenger **4/80**, king **6/80** — no ContextLengthError / Traceback.
- `r1_lora_decision.json` still missing (expected until n80 completes).
- Next: harvest decision; submit only if headroom ≥ 1.5×(3·SE).

## p1859 — H64 ctx crash → engines max_model_len=65536
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,618.
- H64 n80 died @**52/80**: `ContextLengthError` on chall:8002 — prompt≥30977 + 1792 out > **32768**.
- Live evalsrv `affine.toml` already sets **`max_model_len=65536`** for this exact knife-edge.
- Patched `restore_warm_stack.sh` + `launch_merge_reload_sim.sh` + new `relaunch_engines_65536.sh`.
- Wrote `r1_decision.json` decision=**CRASH** (no submit). Stopped old merge pid24147.
- Relaunched engines pids **24941/24942/24943** with `--max-model-len 65536` (loading; GPUs 0–5).
- Train still ~**42/66** on GPUs 6–7; merge waiter pid **24831** rearmed → LoRA n80 after train.
- Next: confirm `/v1/models` max_model_len=65536 + harvest `r1_lora_decision.json`.

## p1858 — armed merge→reload→LoRA-n80 waiter
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,641.
- H64 n80 pid20566: **34/80 / 35/80** @16:51Z (still no `r1_decision.json`).
- LoRA train pid23282: weights loaded; fit-filter **527/1403** @ max_len=8192; step **5/66** loss **0.429**; sample0 supervised **45/1461** thought tokens.
- Staged + launched `merge_lora.py` + `launch_merge_reload_sim.sh` pid **24147**:
  - waits `/root/logs/r1_train.done` + H64 decision
  - merges adapter → `/root/r1_out/r1_lora_merged` → `/tmp/r1_lora_merged`
  - kills chall by PID, reloads :8002 (tp=2 util=0.72), fresh n80 → `r1_lora_decision.json`
- Next: harvest H64 + LoRA decisions; submit only if headroom ≥ 1.5×(3·SE).

## p1857 — launched R1 LoRA train on idle GPUs 6–7
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,652.
- n80 H64 sim pid **20566** still ~**30/80** (no `r1_decision.json` yet).
- Started `launch_train.sh` → train_lora pid **23282** (CUDA 6,7):
  - base Tok `eb8bf9a…` · data n=1403 · out `/root/r1_out/lora_tok_high_reason`
  - knobs: epochs=1 lr=2e-5 lora_r=16 α=32 batch=1 accum=8 loss_on=thought max_len=8192
  - @16:49Z loading base weights (GPU6/7 ~34GB); done stamp `/root/logs/r1_train.done`
- Parallelize: train while baseline finishes; next pass harvest decision + watch train.

## p1856 — train-ready SFT while n80 runs
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,652.
- n80 still running pid **20566**: **30/80 / 29/80** @16:47Z (no decision yet).
- Built `/root/r1_data/sft_high_reason.jsonl`: **1403/1403** rows with corpus `messages` + high-Reason `completion` (`build_sft_jsonl.py`).
- Staged `train_lora.py` + `thought_mask.py` + `launch_train.sh` (CUDA 6,7; init=Tok af10 snapshot `eb8bf9a…`).
- Installed peft **0.15.2** + accelerate **1.14.0** via `uv pip` into `/root/venv`.
- Next: harvest `r1_decision.json`; on REFUTE `bash /root/mining_src/r1-reason-distill/launch_train.sh`.

## p1855 — stage R1 SFT data while n80 runs
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,675.
- n80 still running pid **20566**: **19/80 / 19/80** @16:44Z (no decision yet).
- Added `harvest_high_reason.py`: picks top-40 public duels by duel-z, extracts king pairs with Reason=`lpC_yc_za−lpC_yc_e` ≥ 0.
- Pod `/root/r1_data/`:
  - `teacher_refs_shortz.jsonl` (791) copied from H5c
  - `high_reason_za.jsonl` **1403** rows (deduped by turn_id); reason mean **0.062**, max **0.587**
- Next: harvest `r1_decision.json`; on REFUTE train on GPUs 6–7 from `high_reason_za.jsonl`.

## p1854 — n80 progressing; HF export fix
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,686.
- Sim pid **20566** (watcher 17015): after tokenizer warm-up, progress **challenger 5/80, king 7/80** @16:38Z; teacher GPUs 0–1 saturated.
- Root cause of unauth HF warn: `mine.env` had `HF_TOKEN=…` **without export** → absent from sim environ. Fixed pod `mine.env` exports + `set -a` in `launch_when_ready.sh` (left running sim alone).
- H64 symlink OK (`4ebe104…`, 3 safetensors). Next: harvest `r1_decision.json`.

## p1853 — watcher dead → relaunch → n80 running
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,686.
- Found `launch_when_ready` pid3045 **dead** (log stuck at iter=60 / 16:27Z); no process.
- Relaunched → pid **17015**. Engines hit **200/200/200** @ 16:33:28Z (`warm_stack_ready.done=READY`).
- n80 H64 vs Tok started: `run_reason_sim.py` pid **20566**, `block_hash=cff36ecb8d89050f…`, corpus epoch 7.
- Outputs: `/root/affine_data/r1_reason_sim.json` → `r1_decision.json`. Poll progress / decision next pass.

## p1852 — unstick restore → engines loading
- Teacher DL finished; first restore crashed: `syntax error near **kw` (running script was edited mid-pass).
- Killed pid1305; `mv` `.new`→`restore_warm_stack.sh`; relaunched pid **9697** (skips all HF stamps).
- Pre-linked `/tmp/h64_merged`; B300 patch + Tok preprocessor OK on relaunch.
- vLLM serve started: teacher:8000 / king:8001 / chall:8002 (pids 9910/9923/9936) — weight load in progress, not 200 yet.
- Watcher pid3045 still armed for n80 → `r1_decision.json`. Local `experiments/warm-stack/restore_warm_stack.sh` synced.

## p1851 — pre-serve B300 + Tok hygiene
- Contract `weight_version_key=3`; king Tok af10; fleet=1 mine-crown-1 @$64/h.
- King + H64 downloads done; teacher GLM still ~52G / 55 files mid-flight.
- **Tok:** visual tensors live in language shards (333/333 resolved); derived missing `preprocessor_config.json` from `processor_config.json`.
- **B300:** applied `flash_fwd_sm100` upper-bound patch (`sm_110f`→`sm_121f`); stamped `/root/logs/b300_flash_patch.done`.
- Staged `/root/restore_warm_stack.sh.new` (patch+Tok bake-in); did **not** overwrite running restore pid1305.
- Watcher pid3045 still waiting for 200/200/200 → n80 → `r1_decision.json`.

## p1850 — unblock schema-v2 sim deps
- Contract still `weight_version_key=3`; king Tok af10 unchanged.
- HF DL healthy: `/root/hf` ~78→103G in ~2m (~550MB/s); restore pid1305 + watcher pid3045 alive.
- **Bug found:** venv had pyarrow but **no pandas** → `CorpusSync` / n80 would fail after engines up.
- Installed `pandas==3.0.5` (+ python-dateutil); corpus smoke OK (40335 index rows, epoch 7).
- Stamped `/root/logs/deps_pandas.done`. Patched `restore_warm_stack.sh` + `launch_when_ready.sh` to require pandas/pyarrow.
- No `r1_decision.json` yet (still downloading weights).

## p1849 — Reason harness + corpus + auto n80
- Contract confirmed `weight_version_key=3`.
- Uploaded `/root/mining_src/{affine_pkg,r1-reason-distill,s3-duel-sim}` (read-only score path).
- Corpus sync OK: epoch **7** schema v2 manifest `167085451ab6…` → stamped `corpus.done`.
- Fixed `sync_corpus.sh` for v2 (was failing on missing `turns.jsonl` before stamp).
- `launch_when_ready.sh` pid **3045**: waits PROMPTABLE then runs H64 vs Tok n80 Reason sim → `r1_decision.json`.
- Restore still DL (~44G HF); poll `warm_stack_ready.done` / `r1_decision.json`.

## p1848 — crown bootstrap launched
- Pod: `mine-crown-1` / lunar-orbit-50 / `ssh root@86.38.182.50 -p 40300`
- Uploaded Triton tar + `restore_warm_stack.sh` + `/root/mine.env`
- `nohup` restore pid **1305** @ 2026-08-10T16:14:32Z
