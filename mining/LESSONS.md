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
- H5c kevin-init shortz LoRA REFUTED n80 −0.01640 (clipL1 0.017≪king 0.028); mid50 n40 −0.019 — clip-L1 miss, not calibration.
- H6 TalentPigs-init mild shortz LoRA REFUTED n80 **+0.00330** z=0.54 (r=0.730 base×0.957 valid; clipL1≈0.030≈king) — same near-zero as H5b; do not retry.
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
- After REFUTE, kill idle chall on :8002 before reuse (H5c held GPUs 4–5); also
  H6 post_train `restart_for_h2` kills `vllm_chall.pid` at merge-end — SIGSTOP the
  pipe until mid50 lands (`gate_mid50_before_final.sh`); never edit the live pipe.
- `run_sim_duel.py` nests margin/z under `verdict` and valid/S under
  `verdict.challenger` — flat `d.get("margin")` is always None and false-REFUTEs
  winners. Use `s4-h2-merge/write_merge_decision.py` (H5b proof: nested 0.00322
  vs flat None). Sidecar `watch_fix_decision.sh` if start_*.sh already running.
- Reusing a pod for a new hyp does not inherit `s4-h2-merge/` helpers — mine-h5c-1
  lacked `write_merge_decision.py`/`watch_fix_decision.sh` until pass128 scp'd them
  for H6 mid50/final. Mid50 decisions use `SIGNAL_*` + `signal_only:true` (never
  tear down the train pod on a mid-ckpt n40).
- H7–H15+**H18** α0.75 all **INVALID** band (×2.21…1.997). **H16/H17/H19 α0.90 CLEARS band** (×1.146/1.133/1.121) but margins +0.0097/−0.0037/+0.0035 — no crown; stop α-sweeps on these B's. No α0.85.
- Parent-duel base× ≠ merge base× (H12: live×1.000 → α0.75×2.017). Never tear down on null-margin REFUTE — check `rejection_reason` first (H20 false probe ConnectError/OOM while chall down; archived `*.FALSE_PROBE.json`).
- Dual-side n40/n80 teacher `httpx.ReadTimeout`: 180s×3 dies (H6@29/40); 480s×5 still dies (H9@60/80) — outer 3× retry required; H9/H12 inline; H6/H13/H14 use `watch_n80_retry.sh`→`retry_*_n80.sh` (do not edit live start_*.sh).
- Near-miss HF parents vanish or gate: origin kkk/kkkk/marsplan/adambell often 404/gated; Tok*/alskdjf `gated=manual`→403. Before rent: `model_info` + download + **exact duel rev** via `api/v1/duels/{cid}`. Mirrors: **ckpt1000-m7→`Radiant28/5eqdtdzqle-ckpt1000-m7`@f766293ee878** (chal-00331 +0.018 base×1.242; greyAll/adambell gated); plmk→`bluecolor777/plmk`@b2cc7b9f; **kkk→`bluecolor777/kkk-af`@7426296b**; kkkk→`vincentwarrior/…-kkkk`@3ca1ebe6.
- Accessible +margin B: **kkk→`bluecolor777/kkk-af@7426296b` (+0.024 base×0.918)** staged H26; Radiant28/m7@f766293ee878 (+0.018) H25; plmk→`bluecolor777/plmk@b2cc7b9f` (+0.014); sft2 (+0.011) H21; longertime hk9@8be58079 (+0.008 ungated); Talucampe (+0.007) H23; 0ronoCris (+0.002) H24. Pin duel SHA — kkk-af tip `b38917f9` ≠ duel rev. Origin adambell/Tok*/qpoewir/affine-god gated; kkk/kkkkk/plmk/pandora-distil 404.
- Lium `$5.66/h` "8×H200" can expose **2** GPUs while API still says `gpu_count:8` (zesty-hawk-bc; golden-fox-c0 ls$22.64→rent$5.66). After every rent: `nvidia-smi -L | wc -l` must be 8; reject <$20/h. Prefer `lium up --gpu H200 -c 8` landing ≥$28; $23 listings often "GPU splitting" 400.
- `merge_linear.py` must track `max_abs_delta` over **all** keys — sampling first 8 false-refuses when early embeds match (H12: first8 Δ=0 + first_1MiB match, but shard08 max\|A−O\|=0.215). first_1MiB match alone is never refuse.
- Concurrent vLLM races `~/.triton/cache` (H14/H15/H16/H21) — per-role dirs+stagger still race on first compile (`__triton_launcher.so` missing); wipe that role's cache/pid, relaunch staggered, arm engines→n80 watchdog if wait_ready may timeout.
- Chall at `gpu_memory_utilization=0.80` can OOM on first prompt-logprobs (`log_softmax` needs ~7.2 GiB free; H20 twice). Relaunch chall at **0.72** (leave teacher/king at 0.80).
- H20 TP×leary α0.90 band-clear (×1.118) but m=**−0.01168** — stop leary α-sweeps; +margin parent duel ≠ merge win.

## Money / platform

- Lium has no API to re-add a TTL after cancelling it, hence the host-side
  deadman script. Extending it is a deliberate act — do not extend by reflex.
- Registration burn drifts: seen τ0.81 → τ0.676. Re-check before registering.
- Keyfiles must not carry `cryptoType`; Lium's wallet reader cannot parse it
  and `lium fund -w miner` fails.
