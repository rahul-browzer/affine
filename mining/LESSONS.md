# LESSONS — durable findings

Hard-won knowledge, one line each. Read every pass. **Never let this exceed
120 lines** — if it grows, merge or drop the ones that stopped mattering.
Narrative belongs in `experiments/<id>/result.md`, not here.

Format: `- <finding> — <the number or error that proves it>`

## Scoring / what actually moves S

- All `lp*` are echo+logprob **forced** scores normalized per byte
  (`lp_per_byte`), never sampling logprobs.
- `S` is only comparable **within one duel**. Each duel draws its own slice
  seeded by the reveal block hash — a king scoring 0.0396 on its own slice
  scored ~0.0035 on the slice where it lost. Never compare S across duels.
- Crowning is a paired test on one slice: need margin > 3·SE **and** > 0.02.
  Recent winners clear it narrowly (TalentPigs: +0.0280, z=3.22, SE=0.0087).
- Clip-L1 is the cheap lever once Λ2 is near the king (H3, supported):
  Spearman 0.936 with outcome vs 0.711 for Λ2.
- **The r gate is [0.3, 4.0], not [0.70, 0.85].** The tight band was our own
  invention (old H4) and is refuted. r=0.670/0.897/0.904 were all gate-valid
  (`h1v2_decision_n80.json`: `chall_valid: true` at r=0.904) — those runs lost
  on **margin**, never on calibration. Our only positive margin (H5b +0.00322)
  had r=0.670, outside the invented band. Treat r as a diagnostic, never a
  training target; low r is a symptom of a faithful distill, not its cause.
- The calibration limits that actually exist: r ∈ [0.3, 4.0], and challenger
  empty-baseline ≤ 1.25× the king's on the same slice (gate 3b).
- What actually binds us is the crowning rule: margin > max(3·SE, 0.02). With
  SE ≈ 0.008 the real bar is ≈0.024, and the whole field sits within ±0.014 of
  the king. We lose on margin, not on gates.
- The field is bunched at the king's level: last six challengers ranged
  −0.0028 to +0.0139. Wins are rare excursions, not large edges.

## Recipes already tried (do not repeat without a reason)

- **H1** full (z,y) SFT on teacher_refs — REFUTED, n80 margin −0.01994 z=−2.42.
- **H1v2** thought-only SFT — REFUTED, n80 −0.00030 (dead even), r=0.904.
- **H2** kevin×pandora weight merge — REFUTED, α0.5 −0.010 / α0.65 +0.007.
- **H5** kevin-dominant×TP (A=kevin) — REFUTED α0.65 base×4.43 / α0.50 unpromptable; TP-dominant flip is H10 (open).
- **H5b** TalentPigs-init thought LoRA lr=1e-5 — REFUTED, n80 +0.00322 z=0.55.

## Serving the king's checkpoint (VLM landmines)

- The king is a **multimodal** Qwen3.5-MoE. `AutoModelForCausalLM.save_pretrained`
  writes a *text-only* config (`qwen3_5_moe_text` /`Qwen3_5MoeForCausalLM`) and
  **omits `model.visual.*`**. vLLM then dies with
  `TypeError: Expected Qwen3_5MoeConfig, found Qwen3_5MoeTextConfig`, or
  `ValueError: weights not initialized … visual.*`.
- Fix: restore the king's wrapper `config.json` + preprocessor sidecars, and
  write the missing visual keys back out (333–352 keys →
  `model-visual-restored.safetensors`).
- Weight-identity check must sample **head/mid/tail** of the shards. The
  first 1 MiB of shard 1 is embedding-leading and LoRA never touches it, so a
  first-1MiB-only check gives a false "identical to king" and aborts a good run.

## Training ops

- transformers 5.14 `ProgressCallback` uses `tqdm.write`; under `nohup` the
  loss dicts never reach the log. Scrape `trainer_state.json` instead
  (`log_history` lands at every `save_steps`).
- Always run python from the venv — bare python gives `ModuleNotFoundError`.
- Save mid-checkpoints and salvage each one. Lowest loss is often not the last
  step (H1: best 0.175 @80, final 0.237 @110; H5c: 0.419@50 then 0.568@55).
- LoRA r=16 / alpha=32 on 2 GPUs takes ~1h45m for 110 steps at 440 examples.
- Free GPUs 4,5 can merge+n40 a mid-ckpt while train holds 6,7; yield chall
  when final `h5c_merge.done` appears so the post-train pipe is not blocked.
- H5c mid50 (kevin-init thought LoRA, best loss 0.419@50) n40 margin **−0.019**
  vs TalentPigs; gate-valid at r=0.897, lost because clip-L1 0.015 ≪ king 0.028.
  A clip-L1 miss, not a calibration miss.
- H5c final n80 **REFUTED**: margin −0.01640 z=−2.25; r=0.883 base×1.058 valid;
  clipL1 0.0168≪king 0.0280 and Λ2 −0.0028 vs +0.0024 — kevin-init expanded
  shortz distill does not close L1 or Λ2 vs TalentPigs (do not retry same recipe).
- HF **private** repo storage can hard-fail uploads (`Private repository storage
  limit reached`); keep candidate merges public or prune old private repos.

## Shell / pod ops

- **`lium exec -e KEY=...` prints the value** in its "Environment:" line. Never
  pass `HF_TOKEN` that way. Write `/root/mine.env` once and source it.
- `source`ing an env file does **not** export to child processes. Use
  `set -a; source /root/mine.env; set +a`. This cost a whole bootstrap
  (`KeyError: 'HF_TOKEN'` inside `snapshot_download`).
- **Never edit a shell script that is currently executing.** bash reads by file
  offset; a live script resumes mid-word and dies with nonsense like
  `line 74: ted: command not found` / rc=127. Write a new file and switch.
- Teardown conditions must be fail-open: gate on
  `train_result OR train_fallback OR train.done`, or a fail-closed promote
  leaves the pod burning until the deadman.
- Prefer direct SSH + `nohup` for long jobs over `lium exec`.
- On an 8× sim pod, GPUs 6,7 stay free while teacher/king/chall hold 0–5 —
  launch the next LoRA there instead of renting (H6 pid 46680 beside H5c n80).
- Independent merge hypotheses go on separate `mine-*` pods while train/sim
  occupy others — do not serialize (H7+H8 beside mine-h5c-1; 3 live mine-*).
- Reign earners with null published S (e.g. golden-crown, diane613) are still
  valid merge parents — they hold weight_bps; H8/H9 cover those two vs TalentPigs.
- Launching train without uploading its post_train waiter leaves a dead-end when
  train.done lands — H6 train ran with only `start_h6.sh` on pod until pass121
  scp'd `post_train_pipeline.sh` (pid 53727).
- After a REFUTE n80, kill the idle chall vLLM on :8002 before reuse — leftover
  H5c chall held GPUs 4,5 (~143 GiB each) until H6 mid50 waiter explicitly freed them.
- `run_sim_duel.py` nests margin/z under `verdict` and valid/S under
  `verdict.challenger` — flat `d.get("margin")` is always None and false-REFUTEs
  winners. Use `s4-h2-merge/write_merge_decision.py` (H5b proof: nested 0.00322
  vs flat None). Sidecar `watch_fix_decision.sh` if start_*.sh already running.
- Reusing a pod for a new hyp does not inherit `s4-h2-merge/` helpers — mine-h5c-1
  lacked `write_merge_decision.py`/`watch_fix_decision.sh` until pass128 scp'd them
  for H6 mid50/final. Mid50 decisions use `SIGNAL_*` + `signal_only:true` (never
  tear down the train pod on a mid-ckpt n40).
- H7/H8 TP×{pandora,golden-crown} α0.75 both **INVALID** band (base×2.21 / **1.97**); null-S
  reign earners at 25% sabotage empty-baseline — do not retry those B / no α0.85 on gate-fail.
- Dual-side n40/n80 can `httpx.ReadTimeout` on teacher sample at default 180s×3 (H6 mid50 died @29/40); pod `vllm_client` now 480s×5; `retry_mid50_n40.sh` + post_train already retries n80×3.
- Near-miss HF parents often vanish: adambell/kkk(+0.0244)/marsplan(+0.0143) all 404; check `api/models/<repo>` w/ token before rent — use mirror or next live (alskdjf +0.0139 = H12; adambell→`0pentensor/…ckpt450-H6`).

## Money / platform

- Lium has no API to re-add a TTL after cancelling it, hence the host-side
  deadman script. Extending it is a deliberate act — do not extend by reflex.
- Registration burn drifts: seen τ0.81 → τ0.676. Re-check before registering.
- Keyfiles must not carry `cryptoType`; Lium's wallet reader cannot parse it
  and `lium fund -w miner` fails.
