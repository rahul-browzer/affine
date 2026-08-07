# LESSONS — durable findings

Hard-won knowledge, one line each. **Cap 120 lines.** Detail → `experiments/`.

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
- **α-merge is a ~1-in-260 lottery** (10 n80; H25 best-B m=+0.00662 still
  ≪0.02). α0.90 clears band but margin≈0. Stop α search / do not requeue m7.
- **Select B by TP-era clip-L1, not parent margin** (`s2-clip-l1-rank`): m7
  c_clipL1=+0.0435 → H25 m=+0.00662 (REFUTE); plmk +0.0389 but H16 m=+0.0097 —
  do not requeue; kkk +0.0288 pre-TP mid-pack. Clip-L1 rank ≠ duel margin.
- Clip-L1 shaping data ≠ teacher_refs: harvest challenger `z_A` with
  pair clipL1≥0.04 from high-c_clipL1 duels (+ crown), y=teacher y_C,
  z≤300 → 406 ex mean clipL1 0.089 (`s4-h27-clip-l1-shape`).

## Recipes already tried (do not repeat)

- SFT/LoRA near-zero: H1 -0.01994, H1v2 -0.00030, H5b +0.00322, H5c -0.01640
  (clipL1 0.017 << king 0.028), H6 +0.00330. No plain distill-on-refs retry.
- Merges: H2 kevin×pandora α0.5/−0.010 α0.65/+0.007; H5 kevin-dom×TP band/unpromptable
  (A must be king); H7–H15+H18 α0.75 band-fail; H16/H17/H19 α0.90 band-clear
  weak (+0.0097/−0.0037/+0.0035); H20 leary −0.01168; H21 sft2 α0.75 −0.00682;
  H22 kevin α0.90 −0.01179; H25 m7 α0.90 +0.00662 — stop α lottery / leary / m7.

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
- Triton cache races across concurrent vLLM — per-role dirs + wipe + stagger.
  ImportError/`__triton_launcher.so` or missing `fused_moe_kernel.ttir` → kill
  orphans on those GPUs (`kill -9` compute PIDs **by GPU index**, never
  `pkill -f "vllm serve …"` — that string is in the SSH remote cmdline and
  kills your session). Unique `TRITON_CACHE_DIR` per attempt
  (`role_$(date +%s)_$$`), then relaunch. Health≠alive (APIServer can hang).
- Post-relaunch wait: MoE load+compile needs **≥120×15s** (H25 50×15s would
  have failed mid-compile; extended wait then kicked n80 at i=12).
- Health=200 can mask hung EngineCore (`shm_broadcast` 60s + Triton
  `__triton_launcher.so` missing). After chall relaunch, require a real
  `/v1/completions` probe before starting n80 (H24 pass168). Bake the
  probe into `start_*_n80.sh` before first n80 too (H23 pass169) — not
  only into recover sidecars.
- `pgrep -f "run_sim_duel.py .*local-hN"` false-matches SSH/bash cmdlines that
  contain the pattern — use `ps -eo pid,cmd | awk '/[r]un_sim_duel.py/ && /local-hN/'`.
- Parent-duel base× ≠ merge base× (H12: 1.000→2.017). Null-margin REFUTE: check
  `rejection_reason` first — ConnectError/unpromptable/probe_force = **false probe**
  (H20/H24); quarantine decision, relaunch engine, do **not** `lium rm`.
- After a false-probe null-margin decision, `watch_form_decision`/`watch_n80_retry`
  exit ("decision present") and never rewrite — quarantine the decision **and**
  relaunch both sidecars before the real n80 finishes (H25 pass171 @61/80).
- Keep `experiments/s4-h2-merge/watch_form_decision.sh` in git; pods have shown
  ghost dentries (`ls` lists file, `open`→ENOENT) — re-scp from local if missing.
- After launch, `test -x` **both** form+retry sidecars and `pgrep` them — H26 had
  retry running but form script absent (upload listed it; runtime missing; pass173).
- B300: FA sm_103 patch ≠ done. Engines can still die on flashinfer sampling JIT
  under concurrent launch — clear half-written `cached_ops/sampling`, relaunch
  with `SERVE_STAGGER_S≥45` (H23 pass171).
- After engine relaunch, **reset `start_*_n80.sh` wait** — orphan `wait_ready`
  keeps the old elapsed clock (H23: 18m burned on dead engines; TIMEOUT_S=2400
  would have fired mid-compile). Kill start+wait by PID, relaunch start.

## Money / platform

- No API to re-add cancelled TTL → host deadman. Floor $10k shared with validator.
- Burn drifts τ0.81→τ0.676 — re-check before register. Keyfiles: no `cryptoType`.
