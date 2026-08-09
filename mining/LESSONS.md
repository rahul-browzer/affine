# LESSONS — durable findings
Hard-won knowledge, one line each. **Cap 150 lines.** Detail → `experiments/`.
Overflow: `archive/LESSONS-overflow-2026-08-08-p374.md`.
Format: `- <finding> — <the number or error that proves it>`
## Method search — read before spending a slot
- **95 experiments = 2 families, not 95 ideas.** All were weight-merge or
  SFT-on-harvested-traces, 100% LoRA, ~always init from the incumbent king.
  Family mean vs live king **−0.004**. Cells cannot fix a negative mean; only a
  structurally different family can. Unit of parallelism is the **family**.
- **Best-of-N is a mirage: max of 95 draws at SE 0.0084 = +0.021 of pure luck.**
  H64 proved it — family mean +0.015, screen +0.0251, three replicates −0.009,
  −0.011, +0.0005. **An unreplicated result is a rumour.** Rank by mean of k=4,
  never by max of one. SCREEN → CONFIRM(k=4) → SWEEP; never skip the middle.
- **The bar is low; the basin is the problem.** Genesis beats the king field by
  **+0.16 = 6× the crowning bar** on the honest panel. The field is bunched only
  because everyone ships the same distill. Leave the basin, don't out-sweep it.
- Λ2 has more honest spread than clip-L1 (0.0072 vs 0.0045) and is a **base-model
  property** — a low-rank adapter on the king structurally cannot move it. That
  is the mechanical reason 95 LoRA-on-king runs all landed at ~0.
## Scoring / what actually moves S
- All `lp*` are echo+logprob **forced** scores normalized per byte (`lp_per_byte`).
- `S` is only comparable **within one duel** (slice = reveal-block seed). Never
  cross-duel compare absolute S or absolute clip-L1; use within-slice Δ.
- Crown needs margin > max(3·SE, 0.02) ≈ **0.025** at SE≈0.0084. We lose on
  margin, not gates.
- **0.04 is our SUBMIT gate, NOT the crowning bar (~0.025) and NOT a kill
  threshold.** A cell in 0.015–0.04 is a shortlist to replicate, never dead.
- **SE≈0.0084 ⇒ one n80 cannot separate cells <0.017 apart.** The same family
  gave +0.0135/+0.0098/+0.0042/+0.0183/+0.0161 with no order — 1% lr steps are
  noise, not a response curve. Replicate the best cell; never step sideways.
- Clip-L1 correlates with duel outcome (H3: Spearman 0.936 vs Λ2 0.711) **among
  our own LoRA-on-king runs** — where Λ2 is frozen by construction, so it cannot
  correlate. This does **not** mean Λ2 is the smaller lever: on the honest panel
  Λ2 has the larger spread (0.0072 vs 0.0045). H3 is conditional on the dead
  family; do not cite it to veto a Λ2-targeting family (F2/F3).
- r ∈ [0.3, 4.0] (not our invented [0.70,0.85]); baseline band chall ≤1.25× king.
  Low r is a faithful-distill symptom, never a training target.
- **α-merge refuted as a class** — n=9 mean **−0.00143** sd 0.00809 best +0.00970,
  never half the bar (3.1σ out). Odds worsened with data. The mean is the problem,
  not the draw count; more partners B cannot help. Never spend a slot on α.
  Band was never the blocker either (H21 α0.75 cleared at ×1.001, still −0.00682).
- **Selection has never moved the mean — only shaping can.** Best clip-L1 parent
  m7 (+0.0435) → H25 +0.00662; plmk +0.0389 → H16 +0.0097. Parent rank ≠ duel
  margin (H20). Do not requeue plmk/m7/kkk or shop for candidates.
- Clip-L1 shaping data ≠ teacher_refs: harvest challenger `z_A` with
  pair clipL1≥0.04 from high-c_clipL1 duels (+ crown), y=teacher y_C,
  z≤300 → 406 ex mean clipL1 0.089 (`s4-h27-clip-l1-shape`).
## Recipes already tried (do not repeat)
- SFT/LoRA near-zero + α-merges dead (H1–H26): archive. No plain distill-on-refs; stop α/leary/plmk/m7-as-B/kkk.
- **F1+F8 REINFORCE-L1 + F37 teacher-Λ2 LoRA REFUTED:** Tok-self-L1 H98 m=+0.00229; Genesis-L1 H103 m=**−0.0483**; **F37 Tok×teacher-Λ2 H132 m=−0.00047** λ2_c≈king (−0.0049 vs −0.0055). LoRA RL cannot move Λ2 regardless of reward.
- **F6 ultrashort≤80 REFUTED (H101):** m=−0.00453; mean_λ2_c≈king. Format≠Λ2 under Tok-LoRA.
- **F4+F7 Genesis REFUTED:** high-Λ2 H100 p423 m=**−0.0549** z=−5.9 mean_λ2_c −0.0189; teacher-zC H102 m=−0.0519. Genesis-init LoRA worsens Λ2 vs Tok. No Genesis×SFT cells.
- **F9–F16 earner×high-Λ2 REFUTED (class closed):** kevin−0.014; golden−0.059; pandora−0.034; TalentPigs−0.031; Bittob−0.058; everest−0.083; diane−0.073; **af-k1 F16 m=−0.07623** z=−7.28 λ2_c=−0.019 (p459). Every earner×Λ2 LoRA ≤0. Do not rent more of this class.
- **Raw past-king/genesis CLOSED:** F19−0.006…F23−0.084 + **F22 everest m=−0.06273** z=−7.07 (p499). **Full-FT×Λ2 CLOSED:** Tok/Genesis/Bittob/refs/kevin/pandora/everest/golden/diane/TalentPigs F32−0.026 + **af-k1 F36 m=−0.06667** z=−7.97 λ2_c=−0.017 (p504) all ≤0 — do not rent this class.
- **shm_broadcast / bare-king:** seed king n_so≥16 util=0.72 (p448). Bare king EngineDead with incomplete n_so → **seed-from-chall king478**, not cold p332 (F32 p486: bare n_so=15 failed; chall n_so=22 → PROMPTABLE+n80).

## Serving / VLM
- King is multimodal Qwen3.5-MoE. `AutoModelForCausalLM.save_pretrained` drops `model.visual.*` → vLLM TypeError/ValueError. Restore wrapper `config.json` + preprocessor + visual safetensors (333–352 keys). **Tok ships `processor_config.json` not `preprocessor_config.json`** — derive from `image_processor` or chall dies at MultiModalBudget (H79 p307).
- **Tok phantom visual index:** CausalLM can leave 333 `model.visual.*` keys in `model.safetensors.index.json` pointing at language shards with **0** visual tensors — index count≠disk. `merge_lora` must verify keys exist in claimed shards and extract `model-visual-restored.safetensors` (H79/H80 p310: 852 MiB → GPUs 4,5 36 GiB).
- Weight-identity: sample head/mid/tail shards. first_1MiB alone is false (embeds). `merge_linear.py` must track `max_abs_delta` over **all** keys (H12: first8 Δ=0 but shard08 max‖A−O‖=0.215).

## Training ops
- Under `nohup`, scrape `trainer_state.json` (tqdm.write never hits the log). Always venv python; salvage mid-ckpts (best loss ≠ last). **`tf32=True` only** — family sed `tf33`…`tf36` kills TrainingArguments (F33–F35 p474; **F36 p487** `tf36` → TypeError, idle GPUs until fix+relaunch).
- LoRA r16/α32 ≈1h45m/110 steps on 2 GPUs. HF private uploads hard-fail — keep merges public. Never kill live HF DL for slower peer-rsync (p370: HF≪rsync).
- Merge/finalize **and** Trainer mid-ckpt/`copytree` on gocryptfs `/root` hang (`WCHAN=request_wait_answer`; p472–**p493**). AdamW `optimizer.pt` @step50 for ~35B ≈200GB+ on `/lium-cipher` (F36 p493). Fix: `save_strategy=no`; final save `/tmp/*_full_ft_save` + symlink; `MERGED=/tmp/*_merged`. **p481/p493:** copy tokenizer via `cp -L` (HF symlinks break under `/tmp`). Contig-clone + `max_shard_size=5GB`.

## Shell / pod ops
- Never `lium exec -e HF_TOKEN=...` (prints secret). `/root/mine.env` +
  `set -a; source; set +a` (bare `source` does not export — cost a bootstrap).
- Never edit a running shell script (bash offset → `ted: command not found` / H70 `--out`).
- Prefer SSH+nohup over `lium exec`. Teardown fail-open on train markers. Never completions-probe during recover settle (H85 p326: CUDA illegal-access → EngineDead).
- Independent hyps on separate `mine-*` pods; after REFUTE kill idle :8002
  workers (orphan EngineCore holds ~117 GiB → relaunch OOM). Chall util **0.72**.
- Nested decisions only: `write_merge_decision.py` (flat `margin` false-REFUTEs).
  Sidecar `watch_form_decision.sh` / `watch_n80_retry.sh`; never edit live start_*.
  Match `retry_${hyp}_n80*` not only `…_n80.sh` — `_longwait`/`_b203first` invisible → 30s respawn (F4 p392; F7 p396 dual c203+b203). **SCP watcher to pods** — local fix ≠ live.
- Teacher timeouts: need outer 3× retry even at 480s×5 (H9@60/80).
- Parent HF gated: m7→Radiant28/…-m7@f766293; plmk/kkk mirrors; pin duel SHA.
- **B300 SM10.3 + vllm 0.22.1:** cutlass aliases `Arch.sm_110f→sm_101f`, so
  `flash_fwd_sm100` assert `≤sm_110f` rejects sm_103 → all engines die at
  profile_run (`Only SM 10.x and 11.x are supported`). Patch upper bound to
  `sm_121f` via `s3-duel-sim/patch_b300_sm103_flash_attn.sh` after venv install
  (H23 pass170). H200 unaffected.
- Triton races: isolate `TRITON_CACHE_DIR` + wipe + stagger; never bare
  `/root/.triton/cache/chall` for n80. Prefreeze-before-w1 DEAD (H56 p247).
  Short-only post-w1 freeze clears w1–w3 then n80 ENOENT hash `OV4T43AL…`
  (H56 p251→FALSE_PROBE; H58 same hash). **p253: diverse writable warmups
  then freeze.** Completions 200×2; outer×3; orphans=`VLLM::Worker` ppid=1;
  `FALSE_PROBE_*`≠REFUTE; never `lium rm`.
- `pgrep -f` false-matches SSH/watcher argv — use
  `ps|awk '/[r]un_sim_duel.py/ && /local-hN/'`; never `pgrep -f retry_*.sh`
  from `watch_n80_retry` (self-deadlock H32 pass198).
- Parent-duel base× ≠ merge base× (H12: 1.000→2.017). Null-margin: check
  `rejection_reason` first — false probe → quarantine + relaunch engines/
  form+retry sidecars, never `lium rm` (H25@61/80, H37 pass204).
- After engine relaunch: reset `start_*_n80` wait; recover-wait exits if king
  APIServer dies; kill only `$0 ~ /\/start_…\.sh/` (never embed in `bash -c`).
- Form/retry watchers: poll `awk '/[w]atch_form_decision\.sh/ && / hN /'`;
  relaunch if 0. King/chall mid-n80: reap `VLLM::Worker` ppid=1 (H55 p248).
- Thought-LoRA `max_len=8192` + long prefixes → `supervised_tokens=0` — fit-
  filter msg_chars≤max_len×2.5 + sort short-first (`train_lora.py`).
- `sync_corpus` flocks + adopts existing `turns.jsonl` (rename race H29/H30).
  H27 TP-init shaping m=−0.00792 — do not retry.
- **Winner-zA LoRA family: CLOSED, n=30+ cells, mean −0.004 vs live king.**
  Swept r9–r31 and lr 4.95–8e-6 on m7- and Tok-init; every cell vs Tok landed in
  −0.022…+0.009. The two 'best' (H64 r18 +0.02509, H67 r19 +0.01835) were vs the
  *dead* TalentPigs king and their r18 replicates came back −0.009/−0.011/+0.0005.
  H96 r9=+0.00913 (p373); H95 r10=+0.0015; H94 r11=−0.0137; H91 r12=−0.0056;
  H93 r15=−0.007. Do not resume.
- **F2 high-Λ2 z_A remix REFUTED (H99 p371):** Tok-LoRA on 1059 Λ2≥0.02 ex →
  m=−0.001994; mean_λ2_c −0.00154 ≈ king −0.00095. Selecting teacher-Λ2 winners
  as SFT data does not move Λ2 under king-init LoRA — same frozen-Λ2 failure mode
  as clip-L1 winner-zA. Need non-king base (F4) or non-SFT recipe (F1), not more
  data filters.
- **F3 r=256 LoRA ceiling REFUTED (H97 p374):** Tok-init r256/α512 winner-zA →
  m=−0.01506 z=−1.84; mean_λ2_c −0.00013 vs king +0.00120. Rank≠base — LoRA
  at r=256 still cannot move Λ2. Do not retry higher rank / full-FT-as-LoRA.
- Teacher Triton ENOENT mid-inductor → wipe teacher* + unique TCACHE (H89). Orphan `VLLM::Worker` ppid=1 on nvidia0–3 — kill carefully; concurrent reap can kill chall → recover264.
- Mid-n80 king NCCL → orphans on GPUs2,3; king332 (F9 p399). Cold empty isolated TCACHE also ENOENT mid-load (F11 p434 n_so=10 CQWZC55M) → seed from frozen chall n_so≥16 then util=0.72 (p435); leave chall.
- `watch_n80_retry` can launch before venv exists — retry must wait for
  `/root/venv/bin/activate` ≤10m (H60/H61/H62).
- Rent by UUID + **post-rent COUNT=8** (catalog+API `gpu_count` lie). p441
  zesty-fox-fc=4; p442 zesty-hawk=2; p443 B200@$40=8; p444 calm-shark hung;
  **p471** lunar-lion 8→4; **p506** dd87f25e/golden-wolf-48 API 8→nvidia-smi=3
  (rm before upload). SSH COUNT before upload.
- `wait_ready` `/v1/models` alone ≠ promptable (H30 pass192): chall health=200
  → n80 → `__triton_launcher.so` → ConnectError false REFUTE in ~6m; quarantine
  + GPU-index chall relaunch + completions probe before retry.
- Inject/teacher `400` (H32 30977+1792) → rotate `--block-hash`. **p431:** `run_sim_duel`
  nests `rejection_reason` under `verdict` — top-level `_is_false_probe_sim` wrote
  `N80_DONE` on FP → watcher restarted d203 forever (F11). Read nested verdict.
- `start_*.sh` JSON `note` must be a closed string; unterminated → SyntaxError
  after train nohup → bootstrap `set -e` skips extra_dl/post_train (H36 pass198).
- Engine recover: wipe `role`+`role_*` Triton caches before new `TCACHE`, ≥20s settle (H35–H41; H40 cuda_utils ImportError → reap by GPU). Concurrent prewarm races — recover dead role.
- Default/`longwait` start **a203** (known H32) — after king ready, kill+rearm `d203first` (F11 p437). Drop a203+c203; MAX=6. Mid-n80: scp **new name** + re-point; never edit live retry. FALSE_PROBE≠N80_DONE. Soft-deadline ≥TTL−1h.
- Arm watch_preempt_bare_tcache before post_train chall serve; recover after chall_serve.done or :8002=200 (H61/H62 bare-cache race).
- p264 preempt validated H64: bare cache/chall → recover264 seed+warm+freeze; rearms form+n80 (pass265). Mid-n80 bare → fire recover264 immediately (H61@21/80).
- recover264 salvage after writable-w1 ghost ENOENT: n_so grew → prefreeze same TCACHE + relaunch (H66 16→22; p274).
- Never `pkill -f` over SSH (p274); kill by PID. recover264 owns chall (GPUs 4,5) → king-only relaunch (H67 p275).
- Preempt 240×~10s≈40m: late merge→serve poll≳200 → **rearm preempt by PID** before TIMEOUT (H69 p277@216).
- Live king can flip mid-flight (p279 TalentPigs→Tok331102 S=0.04456); mid-n80 vs old king is ranking-only — retarget before n80; submit needs margin vs **current** king.
- Script-path self-match in SSH argv → match `$0` via `/proc/*/cmdline`. Substring `/retry_hN_n80.sh` also hits **watcher argv** — kill only the retry `$0`. Mid-n80 king EngineDead (Triton ENOENT / TimeoutError / CUDA-OOM) → king-only recover (H76/H77/H94 p349); leave chall alone. Load-time Triton ENOENT → wipe+isolated re-fire; early-abort launcher.so ImportError. **King util=0.80 OOM** (H80 7.58/6.23; H94 p349 7.57/6.69 on bare `cache/king` mid-n80) → isolated TCACHE **util=0.72**.
- **Never edit a running `post_train_pipeline.sh`** (H70 p282 merge-offset `--out`; **p484** F32 mid-wait edit → at train.done `line 90: syntax error near )` rc=2, idle GPUs). Kill+relaunch waiter; never sed live. Preemptively restart F33–F35 waiters after any pipe patch.
- **watch_preempt must not relaunch on isolated writable TCACHE** (H70 p283: chall health=200 @10:14:48Z settle→w1; preempt saw mode=755 n_so=16 “not frozen” → 2nd recover reaped healthy chall @10:14:49Z). Isolated path = leave alone; skip if `relaunch_chall` already alive; only bare `/root/.triton/cache/chall` launches recover.
- Bare chall :8002=200 can still die mid-load (H71) — preempt264→recover264; stale n80 wait→rearm. recover264 DONE rearms bare `retry_*_n80.sh` (**a203**) — re-point `*_d203first` (F10/F15). Seed chall from `*_king_tcache_pass332.path` first, never bare `cache/king`. clone: `test -x` rearm (H94).
- **huggingface_hub≥1.27 never resumes** `.incomplete`: unique `{etag}.{uuid}.incomplete` opened `"wb"`, deleted on fail (PR#4228). Orphan large incompletes need HTTP `Range` resume (H100/F4 p383). **post_train/n80 120×15s races Range/king+chall load** — kill waiter + arm tok.done→king→chall; n80 needs `retry_*_longwait` ≥360×15s (F4 p388/p391; F8 p398 poll108/120 with `:8001/:8002=000`).
- **king_recover_pass332** must serve live Tok on :8001 (F8 p397 had Genesis). Post-freeze chall death + missing turns.jsonl (F4 p397): frozen-TCACHE relaunch + `sync_corpus` before n80; avoid recover264 wipe that reaps healthy chall.
- **B300 cu13** = CUDA_HOME+CCCL+libcudart symlink (p397–p405); detail `archive/LESSONS-overflow-2026-08-08-p374.md`.
- **King repo af11≠af10**; `--chall-repo`=`/v1/models` id; preempt EXP=real dir. Teacher-Λ2 RL needs :8000 (F37 p492). SOFT=TTL−1h; **DEADMAN=TTL−30m must match this rent** — F37 p508 default `06:36Z` (stale) → `aborted_no_n80_budget` at chall-ready; retry still saved n80. Family-clone `sed` breaks `"\\n"` in `python <<'PY'` → use python rewrite (F38 p502).
- **RL `mean_r=0`**: (1) dead teacher — F40 p507 refuse / **F41 p510 bare-TCACHE ENOENT on 1st score → 140× mean_r=0** (abort on first `teacher score fail`, kill+wipe+recover332); (2) kevin/albedo `</think>\nTHOUGHT:` collapses z→"" (p508; fix leading-close+```bash → mean_r 0.016/0.022/0.005). Offline-decode once before blaming teacher.
