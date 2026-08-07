# NOTES — append-only journal

Newest entries at the bottom.

---

## 2026-08-06T22:47Z — pass 1: bootstrap + Stage 0 scoring writeup

### Machine reconcile

`lium ps`: 2 pods, both validator-owned (`affine-eval` 8×B300 $64/h, `affine-bench` 8×H200 $5.80/h). No `mine-*`. Inventory empty. Lium balance **$34,715.32** (≥ $28k floor). Miner wallet free **τ10.000**. Burn cost ~**τ0.692**. Cumulative mining spend $0.

### Live king / contract

- King: `kevin954/Affine-5dfqbbh8ev-sft` rev `6a5815fad8f4e34c983b1933c1fae5762fe25220`, S≈**0.03956**, reign 2.
- Prior reign: `pandora-box/Affine-5eqdtdzqle-ckpt300-m4` rev `5218b138…`.
- Knobs match `affine.toml` / `api/v1/contract`: n_turns=80, τ=0.02, γ=0.30, γ_bank=0.08, r∈[0.3,4], baseline_band=1.25, l1_clip=0.1, min_margin=0.02, min_se=0.005, k_sigma=3.
- Eval stack: vllm 0.22.1 / transformers 5.14.1 / torch 2.11.0.
- `min_submission_block=8767079` (reveals at/below ignored).
- Public evals index: 38 duel gzips; kevin's chal-00224 and pandora's chal-00203 appear with index `margin=0` / `challenger_wins=false` — consistent with retroactive crowning after r_lo 1.0→0.3 (no re-eval). Stage 1 should recompute from stored logprobs under current knobs.

### Stage 0 gate — every term and gate in S* v2

Source of truth read (read-only): `affine/affine/score.py`, `affine/affine.toml` `[duel]`, `affine/affine/priors.py`, `affine/evalsrv/{terms,chat,dueling}.py`, plus `https://affine.io/llms.txt` + `/api/v1/{snapshot,contract}`.

#### Rollout objects (what gets scored)

- Turn prefix `x` from corpus D (SWE-style coding trajectories).
- Model completes inside `<think>…`. `split_rollout` (`chat.py`):
  - **z** = reasoning channel = latent text before `</think>` plus any visible `THOUGHT:` body before the action (label stripped).
  - **y** = **last closed** ` ```bash … ``` ` block. No closed bash ⇒ empty y ⇒ pair dropped.
- Teacher C samples refs `(z_C, y_C)`; miner A samples `(z_A, y_A)`. n=4 samples each; pairs on the diagonal (`terms.py`).
- Thought injection for forcing: assistant body planted as `</think>\nTHOUGHT: {z}\n\n{y}` (`inject_prompt` / `force_text`).
- All `lp*` are **echo+logprobs** forced scores, normalized **per byte** (`lp_per_byte`), never sampling logprobs.

#### Per-pair components used by the ranking term

| symbol | field | meaning |
|---|---|---|
| lpC(y_C\|z_A) | `lpC_yc_za` | teacher logprob of teacher action given miner thought |
| lpC(y_C\|∅) | `lpC_yc_e` | teacher logprob of teacher action given empty thought |
| lpA(y_C\|z_A) | `lpA_yc_za` | miner logprob of teacher action given miner thought |
| lpA(y_C\|∅) | `lpA_yc_e` | miner logprob of teacher action given empty thought |
| lpA(y_A\|z_A) | `lpA_ya_za` | miner logprob of own action given own thought |
| lpA(y_A\|∅) | `lpA_ya_e` | miner logprob of own action given empty thought |

(Other fields in the pair record — e.g. `lpA_yc_zc`, `lpC_ya_*` — are instrumented for audit/ablation but **not** in the frozen ranking term.)

#### Ranking term (what you maximize once gates pass)

```
Λ2     = lpC_yc_za − lpC_yc_e
L1lift = lpA_yc_za − lpA_yc_e
rank   = Λ2 + 1.0 · clip(L1lift, ±0.1)
S      = mean(rank) over pairs
```

- **Λ2**: does the miner's thought raise the *teacher's* probability of the teacher's own action vs empty? This is the teacher-anchored signal — "your z helps C predict y_C".
- **L1lift**: does the miner's thought raise the *miner's* probability of y_C vs empty? Self-consistency / distill fidelity. Clipped ±0.1 so one overconfident turn cannot mint unbounded S (RT-3).
- Clip bound ⇒ per-turn L1 contribution ∈ [−0.1, +0.1]; mean L1 part of S is at most 0.1 in absolute value.

#### Gate 1 — causality + leakage (per pair → miner aggregate)

- **Leakage**: fuzzy z⊃y. Exact cmd substring in z, or ≥60% of cmd tokens (len≥3) appear in z (`leakage()`, fuzzy=0.6). Closes action-stuffing into thought.
- **Causality**: `lpA_ya_za − lpA_ya_e ≥ τ` with τ=0.02. Thought must help the miner predict its *own* action vs empty. Closes silent/no-op thoughts.
- Pair passes iff ¬leakage ∧ causality.
- Miner INVALID if pass_rate < γ=0.30 → S = −∞ for ranking.

#### Gate 2 — prior-bank positivity (miner aggregate)

- For each pair: `Λ2_bank = lpC(y_C|z_A) − max_k lpC(y_C|prior_k)` over published `PRIOR_BANK` = {empty, ls, cat, grep, find, test, para_ls} (`priors.py`).
- `frac_bank` = share of pairs with Λ2_bank > 0.
- INVALID if frac_bank < γ_bank=0.08.
- Closes paraphrase / generic-SWE thought stuffing that looks causal but is prior-dominated (RT-2c).

#### Gate 3 — calibration ratio r (miner aggregate)

- `r = mean|lpA_yc_za| / mean|lpA_yc_e|`.
- INVALID if r ∉ [0.3, 4.0] (or denominator ≤ 0).
- r_lo was 1.0 at launch; lowered 2026-08-06 to 0.3 because r<1 ⇔ mean L1lift>0, the signature of a faithful distill (live distills ~0.72–0.81; teacher-self ~0.35). r_hi=4 still blocks pathological overconfidence numerators.

#### Gate 3b — empty-baseline band (duel-level, challenger only)

- Let `baseline_abs = mean|lpA_yc_e|`.
- Challenger INVALID if `baseline_abs_c > 1.25 × baseline_abs_k` on the same paired slice.
- Closes free L1lift via sabotaging the empty baseline (RT-3d) after r_lo dropped below 1. Honest fleet max observed ~1.14×.

#### Duel crowning rule

Challenger wins iff **all**:

1. Both sides `score_miner` valid (gates 1–3) and challenger passes gate 3b.
2. Paired turns: for each shared `turn_id`, mean rank_term over that turn's pairs; `diffs = S_c(turn) − S_k(turn)`.
3. `mean(diffs) > 3 · SE` with `SE = max(stdev(diffs)/√n, min_se=0.005)`.
4. `mean(diffs) > min_margin=0.02` (noise floor, not effect floor — covers RT-4 copy null ≈0.0195, sharpening residual ≤0.012, and 3·min_se=0.015).

If n_paired < 2 or either side invalid → no win, margin reported 0 / SE inf.

#### Upstream of scoring (burns slot even if S would win)

- **Hygiene** (`model_store`): safetensors only, no `*.py`, no `auto_map`, ≤90 GB weights / ≤100 GB repo, naming+identity token, not weight-identical to current king (unless our HF commit provably earlier).
- **Injectability probe** (`probe_injectable`): must emit parsable bash action and return finite forced logprobs under stock `vllm serve` (TP=2, max-model-len 32768, no `--trust-remote-code`).
- **Slice seeding**: `blake2b(reveal_block_hash ‖ hotkey)` → `sample_slice` with seed-shuffled strata (RT-6 fix). Fresh teacher y_C per duel (RefCache scoped to one duel).
- **One hotkey / one eval slot forever** — burned at enqueue.
- Reveals at block ≤ `min_submission_block` → `skipped_min_block`, no duel.

#### Emissions (why crowns matter)

Rolling last `king_chain_size=5` **distinct** kings share emissions equally; only **registered** hotkeys get weight. Snapshot showed ~$6448/day per earning reign seat at current market (~τ33.5/day · ~$192/τ). Objective: get crowned repeatedly and stay registered.

#### Exploitable slack (observations only — Stage 2 will quantify)

1. **Teacher refs are public** in every duel gz — free (z_C, y_C) on scored turns; distill/SFT target handed out.
2. **Clip(0.1) caps L1** — once Λ2 is competitive, pushing mean L1lift toward +0.1 without breaking r / baseline_band is the remaining headroom (≤ +0.1 on S from L1 alone).
3. **Bank gate is loose at 0.08** — only need >8% of pairs to beat all priors; mid kings historically knife-edged here.
4. **δ=0.02 is a noise floor** — any statistically-above-king challenger crowns; our submit gate (sim margin >0.04) is 2× that for slice variance.
5. **Exact weight copy rejected** — merges/SFT clear this; verify before submit.
6. **Retroactive r_lo change** crowned distill-shaped kings that had failed under r_lo=1.0 — confirms the winning shape is teacher-faithful thoughts, not baseline sabotage.

### Stage 0 gate status

**MET.** Every frozen term (Λ2, L1lift, clip, S) and gate (1 leakage/causality, 2 bank, 3 r, 3b baseline band) plus duel decision and slot-burn preconditions are written above with the live knob values.

### Next

Stage 1 offline replay of `chal-00224` (and `chal-00203`) from stored logprobs — no GPU.

---

## 2026-08-06T22:49Z — pass 2: Stage 1 offline replay (gate MET)

### Machine reconcile

`lium ps`: still only `affine-eval` + `affine-bench`. No `mine-*`. No inventory change. No spend.

### What I did

Downloaded `chal-00224.json.gz` (kevin954 sft vs genesis) and `chal-00203.json.gz`
(pandora ckpt300-m4 vs genesis) into `experiments/s1-replay-chal00224/`.
Recomputed with read-only `affine.affine.score.duel` (`replay.py`).

### Numbers

| duel | knobs | wins | margin | z | chall S / r |
|---|---|---|---|---|---|
| chal-00224 | old r_lo=1.0 | False | 0 | 0 | INVALID (r=0.716) |
| chal-00224 | current | **True** | **+0.070000** | **6.3107** | S=0.039558 / r=0.716 |
| chal-00203 | old r_lo=1.0 | False | 0 | 0 | INVALID (r=0.763) |
| chal-00203 | current | **True** | **+0.060845** | **5.6472** | S=0.018731 / r=0.763 |

Matches AGENTS.md retroactive claims (+0.070/z≈6.3, +0.061/z≈5.7). Published
index margin=0 reproduced under old knobs. Clipped mean_mix bit-matches
published summaries; kevin's mix equals live king S. Baseline ratios 1.06× /
1.08× (inside 1.25 band).

### Stage 1 gate

**MET.** Next: Stage 2 — mine public duel records for ranked hypotheses
(expected α per dollar), no GPU yet.

---

## 2026-08-06T22:51Z — pass 4: Stage 2 closed (ranked hypotheses)

### Machine reconcile

`lium ps`: only `affine-eval` + `affine-bench`. No `mine-*`. No orphans.
Lium balance $34,709.52 (was $34,715.32 — validator burn, not mining spend).

### What I did

Pass 3 left the Stage 2 sample + `analyze.py` / `summary.json` / `table.txt`
but did not write the gate artifacts. This pass closed the gate:

- Wrote `experiments/s2-public-duel-mine/{plan.md,result.md}`.
- Ranked H1 > H2 > H3 in `HYPOTHESES.md` with numeric predicted ΔS.
- Marked H3 **supported** (Spearman Δmix↔ΔclipL1 = 0.936 > Δmix↔ΔΛ2 = 0.711;
  n=15 valid).

### Numbers that drive the ranking

Winners (recompute current knobs): kevin +0.070 / pandora-m4 +0.061 /
hf99jack-cali +0.041 — all r≈0.72–0.76, base×≈1.06–1.08, mean clipL1
+0.026–0.031, margins mostly from ΔclipL1 (57–82%). Baseline-band kills
saboteurs (base× 1.86 / 3.06). King still has ~+0.069 mean clipL1 headroom
to the +0.1 cap. Teacher refs = 80/duel on every sample.

### Stage 2 gate

**MET.** Next: Stage 3 — rent `mine-sim-1` and reproduce a known duel in a
local simulator before any SFT/merge.

---

## 2026-08-06T22:57Z — pass 5: Stage 3 start — rented mine-sim-1 + bootstrap

### Machine reconcile

`lium ps` before rent: only `affine-eval` + `affine-bench`. No `mine-*` orphans.
After rent: `mine-sim-1` (`swift-shark-52`) RUNNING; validator pods untouched.

### Money check (before rent)

- Lium balance $34,709.52 ≫ $28,000 floor.
- Cheapest suitable node: 8×H200 @ **$23.60/h** (vs 8×B300 ~$64/h).
- 6h TTL max exposure ≈ $141.60 ≪ $4,000 first-crown cap.
- Command: `lium ls --gpu H200 --count 8 --sort price_per_hour` then
  `lium up 1 --name mine-sim-1 --ttl 6h --no-ssh -y`.
- `removal_scheduled_at` = **2026-08-07T04:53:17Z**.

### What I did

1. Created `experiments/s3-duel-sim/{plan.md,bootstrap.sh}`.
2. Seeded `/root/mine.env` (0600) on the pod; uploaded bootstrap.
3. Started single `nohup bash /root/bootstrap.sh` via SSH (lium exec backgrounding
   with `&` returned exit -1 and was unreliable).
4. Verified on pod: **torch 2.11.0 / transformers 5.14.1 / vllm 0.22.1**.
5. Teacher download in flight (`zai-org/GLM-4.5-Air-FP8`); `/root/hf` ≈ 60G at
   ~51% of 55 files. Kevin + genesis queued after.

### Ops lesson (no secrets)

`lium exec -e KEY=...` **prints the env value** in its "Environment:" line.
Do not pass HF_TOKEN that way again — write `/root/mine.env` once and
`source` it inside scripts. Prefer direct SSH + nohup for long jobs.

### Next

Wait for `/root/logs/bootstrap.done`, then serve three slots and run the
chal-00224-shaped Stage 3 gate. Extend TTL if needed before 04:53Z.

---

## 2026-08-06T23:00Z — pass 6: harness uploaded while bootstrap downloads

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $2.66; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

Bootstrap not done yet (teacher 106G done; kevin ~46G in flight; genesis
queued). Used the wait to land Stage 3 launch assets on the pod:

1. Wrote `experiments/s3-duel-sim/{serve_three,wait_ready,upload_harness}.sh`.
2. Ran `upload_harness.sh` → `/root/mining_src/affine_pkg` (affine + evalsrv +
   toml), `/root/mining_src/s3-duel-sim/`, `/root/affine_data/chal-00224.json.gz`.
3. Serve defaults intentionally **chal-00224 shape**: genesis on king:8001,
   kevin on chall:8002 (not live-king layout). Eval knobs mirrored:
   TP=2, max-model-len 32768, util 0.80, batched 8192, FLASH_ATTN, moe triton.

### Money

Lium $34,703.01; floor OK. No new rental. Mining spend ≈ $2.66 accruing.

### Next

On `bootstrap.done`: `serve_three.sh` → `wait_ready.sh` → Stage 3 gate score.
Do not train/submit. Extend TTL before 04:53Z if needed.

---

## 2026-08-06T23:32Z — pass 7: serve up + Stage 3 gate scoring in flight

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $15.29; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Bootstrap finished (teacher + kevin + genesis all on pod HF cache).
2. Synced public corpus → `/root/affine_data/turns.jsonl` (9000 turns,
   manifest `515df523…` matches chal-00224 slice stamp).
3. Wrote/uploaded `run_gate.py`, `sync_corpus.sh`, `start_gate.sh`.
4. First serve attempt failed:
   - `DeepGEMM backend not available` → set `VLLM_USE_DEEP_GEMM=0`.
   - Qwen3.6 GDN first request: missing `CUDA_HOME` → point at pip
     `site-packages/nvidia/cu13` (nvcc + headers).
   - Then FlashInfer `gdn_prefill_sm90` ninja JIT:
     `CUDA compiler and CUDA toolkit headers are incompatible` → add
     `--additional-config '{"gdn_prefill_backend": "triton"}'` (same as
     evalsrv bench role on Hopper).
5. Relaunch: all three `/v1/models` OK. Gate smoke:
   `chall lp_per_byte=-0.160177 n_tok=15`. Rescore at ~20/80 both sides
   when pass ended (`/root/logs/gate.log`).

### Money

Lium $34,648.42; floor OK. Mining spend ≈ $15.29 accruing. No new rental.
TTL still 2026-08-07T04:53:17Z.

### Next

Collect `s3_gate_result.json`. Stage 3 MET if kevin wins with margin ≥0.04
or within ~0.02 of published +0.070. Then Stage 4. Do not submit.

---

## 2026-08-06T23:37Z — pass 8: Stage 3 gate MET (+0.0689)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $17.39; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled gate: engines healthy, GPUs busy; finished in ~426s.
2. Collected `/root/affine_data/s3_gate_result.json` →
   `experiments/s3-duel-sim/s3_gate_result.json` + `result.md`.
3. Live force-echo chal-00224 (kevin vs genesis, current knobs):
   - kevin valid S=0.03843 r=0.724 gate=0.884
   - genesis valid S=-0.03108 r=1.142 gate=0.581
   - duel: wins=True margin=+0.06890 se=0.01093 z=6.302 n=80
   - Stage-1 offline target was +0.07000 → |Δ|≈0.001
4. Artifact `verdict` still shows wins=False/margin=0 because the live
   duel was scored under old knobs (kevin INVALID at r_lo=1.0);
   `mean_mix` already 0.03956. Retro crown + our live rescore agree.
5. **STAGE3_GATE=MET**. Advanced STATE to Stage 4; next=H2 merge on
   same pod (kevin→king slot). No submit.

### Money

Lium $34,640.74; floor OK. Mining spend ≈ $17.39 accruing. No new rental.
TTL still 2026-08-07T04:53:17Z — reuse pod for H2.

### Next

H2 merge on mine-sim-1; score vs kevin; do not submit until margin>0.04.

---

## 2026-08-06T23:42Z — pass 9: Stage 4 H2 pipeline started (download→merge)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $19.17; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Confirmed Stage 3 engines still healthy (teacher/genesis/kevin).
2. Created `experiments/s4-h2-merge/`:
   - `plan.md` — H2 α=0.5 kevin×pandora-m4; pred margin >0.02 / target >0.04
   - `download_parents.sh`, `merge_linear.py`, `start_h2.sh`
   - `restart_for_h2.sh` (king←kevin, chall←merge), `run_sim_duel.py`
3. Uploaded to pod `/root/mining_src/s4-h2-merge/`.
4. Started `nohup bash start_h2.sh` (PID in `/root/logs/h2_pipeline.pid`).
   At pass end: kevin snapshot refresh in flight; pandora not yet on disk;
   wait markers `/root/logs/h2_download.done` then `/root/logs/h2_merge.done`.
5. Config check: both parents `qwen3_5_moe` / same text_config shape — merge
   by tensor name is viable despite 2 vs 16 shard layouts.

### Money

Lium $34,632.93; floor OK. Mining spend ≈ $19.17. No new rental. TTL still
2026-08-07T04:53:17Z.

### Next

On `h2_merge.done`: restart_for_h2 → run_sim_duel → record margin. No submit.

---

## 2026-08-06T23:51Z — pass 10: H2 merge done (cache-path fix); re-serve loading

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $22.59; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Parents download finished (~70GB pandora in ~79s after kevin). First merge
   attempt **failed**: `merge_linear.resolve_snapshot` looked under
   `$HF_HOME/hub/models--*` but `download_parents.sh` had passed
   `cache_dir=$HF_HOME`, landing files at `$HF_HOME/models--*`.
2. Fixed `merge_linear.py` to accept both layouts; fixed download to rely on
   `HF_HOME` (no `cache_dir`) for future runs.
3. Re-ran merge-only. Result `/root/merges/h2-kp50` (~68G):
   - common keys **1026**, only_A **19** (MTP copied from kevin), only_B 0
   - `max_abs_delta_sample=0.000549`, first_1MiB sha ≠ kevin → **OK_NON_IDENTICAL**
   - meta copied to `experiments/s4-h2-merge/merge_meta.json`
4. First `restart_for_h2` put `--revision <kevin sha>` on the **local** merge
   path because `CHALL_REV=${CHALL_REV:-kevin…}` treats empty as default.
   Fixed `serve_three.sh` to clear revision when `repo` is a directory;
   killed bad king/chall; relaunched. Chall cmdline now has **no** `--revision`.
5. Teacher stayed healthy. Wait_ready in flight (`/root/logs/h2_restart.pid`).

### Money

Lium $34,617.36; floor OK. Mining spend ≈ $22.59. No new rental. TTL still
2026-08-07T04:53:17Z.

### Next

On READY: `run_sim_duel.py` vs kevin; record margin. No submit until >0.04.

---

## 2026-08-06T23:59Z — pass 11: H2 serve READY; sim duel launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $25.38; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled king:8001 + chall:8002 until health 200 (~5.5 min after pass-10
   relaunch). Marker: `/root/logs/h2_restart.nohup` → `READY` at 23:57:20Z.
2. Confirmed chall serves local `/root/merges/h2-kp50` with no `--revision`.
3. Live snapshot still king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.
4. Launched nohup sim:
   `PYTHONPATH=/root/mining_src/affine_pkg python …/run_sim_duel.py --save-artifact`
   → pid **68843**, log `/root/logs/h2_sim.nohup`, out
   `/root/affine_data/h2_sim_result.json`. GPUs 0–5 busy; process ALIVE at
   ~2 min (no turn progress lines yet — sampling duel slower than Stage3
   force-echo).

### Money

Lium $34,609.61; floor OK. Mining spend ≈ $25.38. No new rental. TTL still
2026-08-07T04:53:17Z.

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:02Z — pass 12: H2 sim healthy, sampling in progress

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $26.35; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE; all three engines `/health` 200.
2. Early log was silent (only HF_TRANSFER FutureWarning); after ~5 min of
   wall time the progress lines appeared:
   - `[sim] king 5/80`
   - `[sim] challenger 5/80`
   - `[sim] challenger 10/80`
3. Teacher GPUs 0–1 at ~96–100% util with requests running/waiting; king and
   chall engines loaded (mem full) but idle util between sample batches.
   Confirmed sim is past bootstrap and into the real sampling duel — not stuck.
4. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.
5. No `h2_sim_result.json` yet. Did not rent, kill, or relaunch.

### Money

Lium $34,601.46; floor OK. Mining spend ≈ $26.35. No new rental. TTL still
2026-08-07T04:53:17Z (~4.8h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:07Z — pass 13: H2 sim advancing (15/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $29.09; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE; engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 12 (not stuck):
   - 00:02Z: king 5/80, chall 10/80
   - 00:04:57Z: king 10/80
   - 00:07Z: king **15/80**, chall **15/80**
3. Teacher is the bottleneck (GPUs 0–1 ~100%; ~7–9 running / ~14–20 waiting
   on capacity). King/chall engines loaded, idle util between sample batches —
   expected while `run_duel` waits on teacher refs / force-echo work.
4. Throughput ≈ 5 turns / 2–2.5 min per side → sampling ETA ~00:30–00:40Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.

### Money

Lium $34,594.06; floor OK. Mining spend ≈ $29.09. No new rental. TTL still
2026-08-07T04:53:17Z (~4.75h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.
