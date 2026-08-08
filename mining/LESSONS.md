# LESSONS — durable findings
Hard-won knowledge, one line each. **Cap 150 lines.** Detail → `experiments/`.
Format: `- <finding> — <the number or error that proves it>`

## Scoring / what actually moves S
- All `lp*` are echo+logprob **forced** scores normalized per byte (`lp_per_byte`).
- `S` is only comparable **within one duel** (slice = reveal-block seed). Never
  cross-duel compare absolute S or absolute clip-L1; use within-slice Δ.
- Crown needs margin > max(3·SE, 0.02). Field bunched ±0.014 of king; we lose
  on margin, not gates. Real bar ≈0.024 at SE≈0.008.
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
- SFT/LoRA near-zero: H1 -0.01994, H1v2 -0.00030, H5b +0.00322, H5c -0.01640
  (clipL1 0.017 << king 0.028), H6 +0.00330. No plain distill-on-refs retry.
- Merges: H2 kevin×pandora α0.5/−0.010 α0.65/+0.007; H5 kevin-dom×TP band/unpromptable
  (A must be king); H7–H15+H18 α0.75 band-fail; H16/H17/H19 α0.90 band-clear
  weak (+0.0097/−0.0037/+0.0035); H20 leary −0.01168; H21 sft2 α0.75 −0.00682;
  H22 kevin α0.90 −0.01179; H25 m7 α0.90 +0.00662; H26 kkk α0.90 +0.00592
  — stop α lottery / leary / m7 / kkk.

## Serving / VLM
- King is multimodal Qwen3.5-MoE. `AutoModelForCausalLM.save_pretrained` drops
  `model.visual.*` → vLLM TypeError/ValueError. Restore wrapper `config.json` +
  preprocessor + visual safetensors (333–352 keys).
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
- Never edit a running shell script (bash offset → `ted: command not found`).
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
- Catalog 8×H200 @$23.20/h can 400 "GPU splitting"; fallback 8×B200 @$40/h
  (SM10.0; pass188). `$11.6/h` can be **4 GPUs** — always `nvidia-smi -L|=8`.
- `sync_corpus` flocks + adopts existing `turns.jsonl` (rename race H29/H30).
- H27 TP-init+same 406ex m=−0.00792 — do not retry TalentPigs-init shaping.
- Winner-zA LoRA m7-init: H28 +0.01095; **H42@5e-6 +0.01613 best**; H52@6e-6
  +0.01280; H57@5.25e-6 +0.01537; H50@7.5e-6 +0.00322; H53@4e-6 **−0.00885**;
  H46@2.5e-6 +0.00802; H45@r8 +0.00819; H47@α8 +0.00463; H49@α4 +0.01174;
  H48@1e-6 **band×1.269**; H55@5.5e-6 **band×1.256** (INVALID). lr **5e-6 >
  5.25e-6 > 6e-6 > 7.5e-6 > 4e-6(neg)**; α16=+0.00855. Dead: TP/m7×ks/union /
  lr≤2.5e-6∨=4e-6∨=5.25e-6∨=5.5e-6∨=6e-6∨=7.5e-6∨≥3e-5 / ep≥2 / r≤8∨≥32 /
  α≤8∨=16∨≥64 / clip≥0.08. Open: H58@5.1 H60@5.3 H59@5.75 H54@8 H56@r24.
- `lium up --gpu H200 -c 8` can pick **$14.5/h** labeled 8×H200 with
  nvidia-smi COUNT=**5** (golden-comet-7a p254) — always rent by UUID from
  `lium ls --count 8` with **$/h≥28**, then verify COUNT=8 before upload.
- p253 diverse writable warmups→freeze: H56+H58 both reached triple-promptable
  and n80 start (n_so 16→22); prefer over short-only post-w1 freeze.
- B300 flashinfer sampling JIT: clear `cached_ops/sampling`, `SERVE_STAGGER_S≥45`.
- Clone hyp scripts: replace full EXP dirname **before** `h46→hN` sed.
- Catalog `8×H200` @$11.6/h can be **4 GPUs** (eager-lion-11 pass199) — always
  `nvidia-smi -L|wc -l`=8 after rent; reject <$20/h (was 2-GPU@$5.66; now 4 too).
- `lium up` prompts confirm — always pass `-y` (bare `yes|` floods the post-up
  SSH shell with `y: command not found`).
- `wait_ready` `/v1/models` alone ≠ promptable (H30 pass192): chall health=200
  → n80 → `__triton_launcher.so` → ConnectError false REFUTE in ~6m; quarantine
  + GPU-index chall relaunch + completions probe before retry.
- Teacher sample `400` when prompt_tokens+max_tokens(1792) > 32768 (H32:
  30977+1792) kills whole n80; rotate `--block-hash` across retry attempts.
- `start_*.sh` JSON `note` must be a closed string; unterminated → SyntaxError
  after train nohup → bootstrap `set -e` skips extra_dl/post_train (H36 pass198).
- Engine recover: wipe `role`+`role_*` Triton caches **before** creating the
  new `TCACHE`, then ≥20s settle (H35/H36/H37/H41; H40 p210 teacher hung
  health=000 with workers holding VRAM after `cuda_utils.so` ImportError —
  reap by GPU index first). Concurrent prewarm still races — recover dead role.
- Default `block_hash=0*64` n80 dies teacher **400** @~40/80 (H32/H34). Rotate
  a203/b203/c203 on every retry. Bare post_train **races** retry (H42/H43) —
  skip if retry armed. Soft-deadline: cloned SOFT/DEADMAN=`04:30Z`/`05:30Z`
  aborts once past (`<60m to soft`); H53–H56 hit this — export **and** patch
  script `:-` defaults to ≥TTL−1h (env alone dies on restart; pass245);
  relaunch post_train, never tear down. `watch_n80_retry` must **not** `exec`
  retry (pass203); retry must **wait** engines; sim-alive needs `python` in argv.
