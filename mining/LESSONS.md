# LESSONS — durable findings
Hard-won knowledge, one line each. **Cap 150 lines.** Detail → `experiments/`.
Format: `- <finding> — <the number or error that proves it>`

## Scoring / what actually moves S
- All `lp*` are echo+logprob **forced** scores normalized per byte (`lp_per_byte`).
- `S` is only comparable **within one duel** (slice = reveal-block seed). Never
  cross-duel compare absolute S or absolute clip-L1; use within-slice Δ.
- Crown needs margin > max(3·SE, 0.02) ≈ **0.025** at SE≈0.0084. We lose on
  margin, not gates.
- **0.04 is our SUBMIT gate (slice-variance headroom), NOT the crowning bar and
  NOT a kill threshold.** Conflating them nearly binned our best work: H64 r=18
  m=+0.02509 z=2.993 missed 3·SE=0.02515 by **0.000059 (0.23%)** and was written
  into the dead list. A cell in 0.015–0.04 is a **shortlist to replicate**.
- **SE≈0.0084 ⇒ one n80 cannot separate cells <0.017 apart.** Sweeping lr at 1%
  steps (5.01/5.02/5.05e-6) and blacklisting each on one draw is fitting noise:
  the same family gave +0.0135, +0.0098, +0.0042, +0.0183, +0.0161 with no
  order. **Replicate the best cell instead of stepping 1% sideways** — a re-draw
  is a fresh shot at 3·SE; a neighbour cell is a coin flip already flipped.
- Clip-L1 is the lever (H3): Spearman 0.936 vs outcome; Λ2 only 0.711.
- r ∈ [0.3, 4.0] (not our invented [0.70,0.85]); baseline band chall ≤1.25× king.
  Low r is a faithful-distill symptom, never a training target.
- **α-merge is refuted as a class: ~1 in 1,200** — n=9 merges mean **−0.00143**
  sd 0.00809 best +0.00970, never half the bar; +0.024 is 3.1σ out. Odds got
  *worse* with data (was 1-in-260 at n=4). More partners B cannot help: the mean
  is the problem, not the draw count. Never spend a slot on an α sweep.
- **The band was never the blocker.** H21 ran α0.75 and *cleared* it at
  base×**1.001** (vs ×1.85–2.21 for H7–H15/H18) and still lost −0.00682. So
  "α squeezed between band-fail and king-similarity" is wrong — merges miss on
  margin wherever α sits.
- **Selecting B by clip-L1 fails too — only shaping works.** Best available
  clip-L1 parent m7 (+0.0435) → H25 m=+0.00662; plmk +0.0389 → H16 +0.0097;
  kkk +0.0288 mid-pack. Clip-L1 rank ≠ duel margin, exactly as parent margin
  ≠ duel margin (H20). **Selection has never moved the mean; train for clip-L1
  instead of shopping for it.** Do not requeue plmk/m7/kkk.
- Clip-L1 shaping data ≠ teacher_refs: harvest challenger `z_A` with
  pair clipL1≥0.04 from high-c_clipL1 duels (+ crown), y=teacher y_C,
  z≤300 → 406 ex mean clipL1 0.089 (`s4-h27-clip-l1-shape`).

## Recipes already tried (do not repeat)
- SFT/LoRA near-zero + α-merges dead (H1–H26): see HYPOTHESES/archive. No plain
  distill-on-refs; stop α lottery / leary / plmk / m7-as-B / kkk.

## Serving / VLM
- King is multimodal Qwen3.5-MoE. `AutoModelForCausalLM.save_pretrained` drops
  `model.visual.*` → vLLM TypeError/ValueError. Restore wrapper `config.json` +
  preprocessor + visual safetensors (333–352 keys). **Tok ships
  `processor_config.json` not `preprocessor_config.json`** — derive the latter
  from `image_processor` or chall dies at MultiModalBudget (H79 p307).
- **Tok phantom visual index:** CausalLM can leave 333 `model.visual.*` keys in
  `model.safetensors.index.json` pointing at language shards with **0** visual
  tensors — index count≠disk. `merge_lora` must verify keys exist in claimed
  shards and extract `model-visual-restored.safetensors` (H79/H80 p310: 852 MiB,
  then GPUs 4,5 → 36 GiB; prior: ValueError uninit visual.*).
- Weight-identity: sample head/mid/tail shards. first_1MiB alone is false (embeds).
- `merge_linear.py` must track `max_abs_delta` over **all** keys (H12: first8 Δ=0
  but shard08 max‖A−O‖=0.215).

## Training ops
- Under `nohup`, scrape `trainer_state.json` (tqdm.write never hits the log).
- Always venv python. Salvage mid-ckpts — best loss ≠ last step.
- LoRA r=16/α32 on 2 GPUs ≈1h45m / 110 steps / 440 ex. Free GPUs 4–5 can
  merge+n40 while 6–7 train; yield chall when final merge.done lands.
- HF private storage can hard-fail uploads — keep candidate merges public.

## Shell / pod ops
- Never `lium exec -e HF_TOKEN=...` (prints secret). `/root/mine.env` +
  `set -a; source; set +a` (bare `source` does not export — cost a bootstrap).
- Never edit a running shell script (bash offset → `ted: command not found` / H70 `--out`).
- Prefer SSH+nohup over `lium exec`. Teardown fail-open on train markers.
- Independent hyps on separate `mine-*` pods; after REFUTE kill idle :8002
  workers (orphan EngineCore holds ~117 GiB → relaunch OOM). Chall util **0.72**.
- Nested decisions only: `write_merge_decision.py` (flat `margin` false-REFUTEs).
  Sidecar `watch_fix_decision.sh` / `watch_n80_retry.sh`; never edit live start_*.
- Teacher timeouts: need outer 3× retry even at 480s×5 (H9@60/80).
- Parent HF: origin often 404/gated. Mirrors: m7→`Radiant28/5eqdtdzqle-ckpt1000-m7`
  @f766293ee878; plmk→`bluecolor777/plmk`@b2cc7b9f; kkk→`bluecolor777/kkk-af`
  @7426296b. Pin duel SHA. Tok*/alskdjf/qpoewir gated=manual; adambell/marsplan 404.
- Lium `$5.66/h` "8×H200" can be 2 GPUs — after rent `nvidia-smi -L|wc -l`=8;
  reject <$20/h. Prefer `lium up --gpu H200 -c 8` ≥$28/h.
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
- Winner-zA LoRA m7-init: **H64@r18 +0.02509 best vs TalentPigs** (z=2.993);
  **H65@5.02e-6 +0.01829**; **H67@r19 +0.01835** (→H73); H42@5e-6 +0.01613;
  H57@5.25 +0.01537; H58@5.1 +0.01466; H54@8 +0.01380; H60@5.3 +0.01350;
  H66@5.08 +0.00976; H63@5.05 +0.00424; H61@5.15 band×1.262; H62@r20
  band×1.273; **H68@4.95 band×1.257**; H69@r17 +0.01641 vs TalentPigs
  (→H77 Tok / H80 Tok-init); **H70@5.01 −0.000525 vs Tok dead**; **H71@r16
  −0.01366 vs Tok dead**; **H72/H74/H75@r18 vs Tok** m=−0.009/−0.011/+0.00055
  (**H76@r18 −0.01974** closes m7×r18); **H73@r19 −0.00581 dead**;
  **H78@r21 −0.00741 dead**; **H77@r17 −0.02176 dead** (closes m7×r17);
  **H79 Tok-init@r18 −0.00784 dead**; **H80 Tok-init@r17 −0.000821 dead**
  (near-null, gates OK). Open: **H81–H85 Tok-init** (r22/23/25/26/27).
- H66 king mid-pipeline Triton ENOENT hung :8001 — reap GPU 2/3, wipe
  `cache/king`, `serve_three` (p271); don't wait for post_train abort.
- `watch_n80_retry` can launch before venv exists — retry must wait for
  `/root/venv/bin/activate` ≤10m (H60/H61/H62).
- Rent by UUID from `lium ls --count 8` $/h≥28 + verify COUNT=8 (`lium up
  --gpu H200 -c 8` can yield COUNT=5 @$14.5/h). Always `-y` (bare `yes|`
  floods SSH with `y: command not found`).
- p253/p260 diverse writable warmups→freeze beats short-only post-w1 freeze.
- B300 flashinfer JIT: clear `cached_ops/sampling`, `SERVE_STAGGER_S≥45`.
- Clone hyp scripts: replace full EXP dirname **before** `h46→hN` sed.
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
- Script-path self-match in SSH argv → match `$0` via `/proc/*/cmdline`. Substring `/retry_hN_n80.sh` also hits **watcher argv** — kill only the retry `$0`. Mid-n80 king EngineDead (Triton ENOENT **or** `sample_tokens` TimeoutError) → king-only recover (H76 p300/p302; H77 p302/p306); leave chall alone. Stuck orphan TP1+APIServer gone → kill recover PID, reap, re-fire. Load-time Triton ENOENT (health stays 000) → kill+wipe+**isolated** TCACHE re-fire (bare `cache/king` ENOENT again H80 p312→p314 NODUTTS4); early-abort on launcher.so ImportError. **King util=0.80 can CUDA-OOM on first n80 turn after PROMPTABLE** (H80 p314: 7.58 GiB need / 6.23 free) → re-fire isolated at **util=0.72**.
- **Never sed-patch a running `post_train_pipeline.sh`** (H70 p282: retarget@09:59Z while merge ran → bash offset `line 134: --out: command not found` rc=127 after merge DONE; no merge.done). Patch only idle copies / env; if merge artifacts exist, write `merge.done` + `relaunch_chall` (do not re-merge).
- **watch_preempt must not relaunch on isolated writable TCACHE** (H70 p283: chall health=200 @10:14:48Z settle→w1; preempt saw mode=755 n_so=16 “not frozen” → 2nd recover reaped healthy chall @10:14:49Z). Isolated path = leave alone; skip if `relaunch_chall` already alive; only bare `/root/.triton/cache/chall` launches recover.
- Bare post_train chall can hit :8002=200 with mid-load Triton ghost WARNING then still finish; preempt264→recover264 is correct (H71 p287). Stale `retry_h*_n80` wait started before chall existed burns the 120×15s budget — recover kills+rearms; if no recover, kill retry PID near poll≳100 so watcher refreshes wait.
- recover264 DONE rearms form+watch_n80 only — **not** preempt/mid304. One-shot preempt **exits** on isolated chall (p303). Arm mid304 when n80 starts; detect via `/proc/*/cmdline` `$0` — SSH `bash -lc` argv containing the script path is a false positive (H82 p321).
