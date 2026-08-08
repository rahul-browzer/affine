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
- SFT/LoRA near-zero + α-merges dead (H1–H26): see archive. No plain distill-on-refs; stop α lottery / leary / plmk / m7-as-B / kkk.

## Serving / VLM
- King is multimodal Qwen3.5-MoE. `AutoModelForCausalLM.save_pretrained` drops `model.visual.*` → vLLM TypeError/ValueError. Restore wrapper `config.json` + preprocessor + visual safetensors (333–352 keys). **Tok ships `processor_config.json` not `preprocessor_config.json`** — derive from `image_processor` or chall dies at MultiModalBudget (H79 p307).
- **Tok phantom visual index:** CausalLM can leave 333 `model.visual.*` keys in `model.safetensors.index.json` pointing at language shards with **0** visual tensors — index count≠disk. `merge_lora` must verify keys exist in claimed shards and extract `model-visual-restored.safetensors` (H79/H80 p310: 852 MiB → GPUs 4,5 36 GiB).
- Weight-identity: sample head/mid/tail shards. first_1MiB alone is false (embeds). `merge_linear.py` must track `max_abs_delta` over **all** keys (H12: first8 Δ=0 but shard08 max‖A−O‖=0.215).

## Training ops
- Under `nohup`, scrape `trainer_state.json` (tqdm.write never hits the log). Always venv python; salvage mid-ckpts (best loss ≠ last).
- LoRA r16/α32 ≈1h45m/110 steps on 2 GPUs. HF private uploads hard-fail — keep merges public. Never kill live HF DL for slower peer-rsync (p370: HF≪rsync).
- GPU `merge_lora --device-map auto` save can hang mid-shard on gocryptfs (`WCHAN=request_wait_answer`, wchar flat, GPU util 0%) — kill merge+post_train by PID, `--device-map cpu`, resume post_train `SKIP_MERGE=1` (H95 p352; H100/F4 p376 tmp=49.7 GiB stuck).

## Shell / pod ops
- Never `lium exec -e HF_TOKEN=...` (prints secret). `/root/mine.env` +
  `set -a; source; set +a` (bare `source` does not export — cost a bootstrap).
- Never edit a running shell script (bash offset → `ted: command not found` / H70 `--out`).
- Prefer SSH+nohup over `lium exec`. Teardown fail-open on train markers. Never completions-probe during recover settle (H85 p326: CUDA illegal-access → EngineDead).
- Independent hyps on separate `mine-*` pods; after REFUTE kill idle :8002
  workers (orphan EngineCore holds ~117 GiB → relaunch OOM). Chall util **0.72**.
- Nested decisions only: `write_merge_decision.py` (flat `margin` false-REFUTEs).
  Sidecar `watch_fix_decision.sh` / `watch_n80_retry.sh`; never edit live start_*.
- Teacher timeouts: need outer 3× retry even at 480s×5 (H9@60/80).
- Parent HF often 404/gated. Mirrors: m7→`Radiant28/5eqdtdzqle-ckpt1000-m7`@f766293; plmk→`bluecolor777/plmk`@b2cc7b9f; kkk→`bluecolor777/kkk-af`@7426296b. Pin duel SHA.
- Lium catalog lies: after rent `nvidia-smi -L|wc -l`=8; reject $/h<28. Prefer `lium up --gpu H200 -c 8`.
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
- Ghost dentry: `ls` lists but `open`→ENOENT — `rm` + re-scp; `test -x`.
- After engine relaunch: reset `start_*_n80` wait; recover-wait exits if king
  APIServer dies; kill only `$0 ~ /\/start_…\.sh/` (never embed in `bash -c`).
- Form/retry watchers: poll `awk '/[w]atch_form_decision\.sh/ && / hN /'`;
  relaunch if 0. King/chall mid-n80: reap `VLLM::Worker` ppid=1 (H55 p248).
- Thought-LoRA `max_len=8192` + long prefixes → `supervised_tokens=0` — fit-
  filter msg_chars≤max_len×2.5 + sort short-first (`train_lora.py`).
- Do not idle free `mine-*` slots (GOAL 2026-08-07); fill non-α variants.
  Rent by UUID $/h≥28 + `nvidia-smi -L|=8` (catalog lies; $11.6/h can be 4 GPUs).
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
- H66 king
  mid-pipeline Triton ENOENT hung :8001 — reap GPU 2/3, wipe `cache/king`,
  `serve_three` (p271); don't wait for post_train abort.
- mid304 exits on `sim gone` — rearm via file `arm_mid304_hN.sh` when n80
  relaunches after king recover (H90 p342: prior exit@17:08 → rearm@17:19).
- Teacher Triton ENOENT mid-inductor (`triton_poi_fused_*.json` ghost) → wipe
  teacher* + unique TCACHE re-fire (H89 p334). Orphan `VLLM::Worker` with
  open fds on nvidia0–3 (0 MiB) — kill carefully; concurrent reap coincided
  with chall EngineDead on GPUs 4,5 → recover264 immediately.
- `watch_n80_retry` can launch before venv exists — retry must wait for
  `/root/venv/bin/activate` ≤10m (H60/H61/H62).
- Rent by UUID from `lium ls --count 8` $/h≥28 + verify COUNT=8 on the pod
  (`nvidia-smi -L|wc -l`; catalog can lie — COUNT=5@$14.5 or COUNT=7@$31.92
  H99 p355). Always `-y` (bare `yes|` floods SSH with `y: command not found`).
- `wait_ready` `/v1/models` alone ≠ promptable (H30 pass192): chall health=200
  → n80 → `__triton_launcher.so` → ConnectError false REFUTE in ~6m; quarantine
  + GPU-index chall relaunch + completions probe before retry.
- Teacher sample `400` when prompt_tokens+max_tokens(1792) > 32768 (H32:
  30977+1792) kills whole n80; rotate `--block-hash` across retry attempts.
- `start_*.sh` JSON `note` must be a closed string; unterminated → SyntaxError
  after train nohup → bootstrap `set -e` skips extra_dl/post_train (H36 pass198).
- Engine recover: wipe `role`+`role_*` Triton caches before new `TCACHE`, ≥20s settle (H35–H41; H40 cuda_utils ImportError → reap by GPU). Concurrent prewarm races — recover dead role.
- Default `block_hash=0*64` n80 dies teacher **400** @~40/80 — rotate a203/b203/c203. Bare post_train races retry — skip if retry armed. Soft-deadline: patch script `:-` ≥TTL−1h (H53–H56); never tear down. `watch_n80_retry` must not `exec` retry; sim-alive needs `python` in argv.
- Arm watch_preempt_bare_tcache before post_train chall serve; recover after chall_serve.done or :8002=200 (H61/H62 bare-cache race).
- p264 preempt validated H64: bare cache/chall → recover264 seed+warm+freeze; rearms form+n80 (pass265). Mid-n80 bare → fire recover264 immediately (H61@21/80).
- recover264 salvage after writable-w1 ghost ENOENT: n_so grew → prefreeze same TCACHE + relaunch (H66 16→22; p274).
- Never `pkill -f` over SSH (p274); kill by PID. recover264 owns chall (GPUs 4,5) → king-only relaunch (H67 p275).
- Preempt 240×~10s≈40m: late merge→serve poll≳200 → **rearm preempt by PID** before TIMEOUT (H69 p277@216).
- Live king can flip mid-flight (p279 TalentPigs→Tok331102 S=0.04456); mid-n80 vs old king is ranking-only — retarget before n80; submit needs margin vs **current** king.
- Script-path self-match in SSH argv → match `$0` via `/proc/*/cmdline`. Substring `/retry_hN_n80.sh` also hits **watcher argv** — kill only the retry `$0`. Mid-n80 king EngineDead (Triton ENOENT / TimeoutError / CUDA-OOM) → king-only recover (H76/H77/H94 p349); leave chall alone. Load-time Triton ENOENT → wipe+isolated re-fire; early-abort launcher.so ImportError. **King util=0.80 OOM** (H80 7.58/6.23; H94 p349 7.57/6.69 on bare `cache/king` mid-n80) → isolated TCACHE **util=0.72**.
- **Never sed-patch a running `post_train_pipeline.sh`** (H70 p282: retarget@09:59Z while merge ran → bash offset `line 134: --out: command not found` rc=127 after merge DONE; no merge.done). Patch only idle copies / env; if merge artifacts exist, write `merge.done` + `relaunch_chall` (do not re-merge).
- **watch_preempt must not relaunch on isolated writable TCACHE** (H70 p283: chall health=200 @10:14:48Z settle→w1; preempt saw mode=755 n_so=16 “not frozen” → 2nd recover reaped healthy chall @10:14:49Z). Isolated path = leave alone; skip if `relaunch_chall` already alive; only bare `/root/.triton/cache/chall` launches recover.
- Bare post_train chall can hit :8002=200 with mid-load Triton ghost WARNING then still finish; preempt264→recover264 is correct (H71 p287). Stale `retry_h*_n80` wait started before chall existed burns the 120×15s budget — recover kills+rearms; if no recover, kill retry PID near poll≳100 so watcher refreshes wait.
- recover264 DONE rearms form+watch_n80 only — **not** preempt/mid304. Arm mid304 when n80 starts; mid304 exits on `sim gone` → re-arm after recover. Detect live scripts via `/proc/*/cmdline` `$0` (SSH/`bash -c` argv is a false positive — H82/H93 p349: mid304 `recover_alive` skipped while check script argv held `relaunch_chall_pass264.sh`).
- Chall recover must seed from **live king isolated TCACHE** (`:8001` `TRITON_CACHE_DIR`), not bare `/root/.triton/cache/king` — H91 p344: "no king TCACHE" → cold JIT → NODUTTS4 ImportError; seed king n_so=16 fixed path. Early-abort wait_health on launcher ImportError (don't burn 120×10s).
- Clone recover: wrong hyp dirname in rearm path (H94 p348) → `test -x` before DONE; symlink correct EXP. King cold-JIT ENOENT → seed **live peer king** TCACHE (H95 n_so=23 → p366 OK).
