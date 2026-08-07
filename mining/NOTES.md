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

---

## 2026-08-07T00:11Z — pass 14: H2 sim advancing (20/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $30.53; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE; engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 13 (not stuck):
   - 00:07Z: king 15/80, chall 15/80
   - 00:10:30Z: chall **20/80**
   - 00:11Z: king **20/80**, chall **20/80**
3. Teacher still the bottleneck (GPUs 0–1 ~96–100%; ~3–8 running / ~14–19
   waiting on capacity). Brief quiet stretch after 15/80 was just inter-batch
   latency, not a hang — process stayed in epoll wait with teacher busy.
4. Throughput ≈ 5 turns / 3–4 min per side → sampling ETA ~00:40–00:50Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.

### Money

Lium $34,586.26; floor OK. Mining spend ≈ $30.53. No new rental. TTL still
2026-08-07T04:53:17Z (~4.7h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:13Z — pass 15: H2 sim advancing (25/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $31.62; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE; engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 14 (not stuck):
   - 00:11Z: king 20/80, chall 20/80
   - 00:13Z: king **25/80**, chall **25/80**
3. Teacher still the bottleneck (GPUs 0–1 ~100%; ~4 running / ~19 waiting
   on capacity). King/chall engines loaded, idle util between sample batches.
4. Throughput ≈ 5 turns / 2–3 min per side → sampling ETA ~00:35–00:45Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.

### Money

Lium $34,586.26; floor OK. Mining spend ≈ $31.62. No new rental. TTL still
2026-08-07T04:53:17Z (~4.6h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:16Z — pass 16: H2 sim advancing (30/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $32.88; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE; engines 8000/8001/8002 health 200.
2. Initial log still at 25/80 (same as pass 15); waited 90s and rechecked:
   - before wait: king 25/80, chall 25/80
   - after wait: king **30/80**, chall **30/80** → advancing, not stuck.
3. GPU util: teacher 0–1 ~95 percent, king 2–3 ~97 percent, chall 4–5 ~95
   percent during sample batches; GPUs 6–7 idle. Throughput still ~5 turns /
   2–3 min/side.
4. Sampling ETA ~00:40–00:50Z then force-echo; finish inside TTL 04:53Z.
   Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956.

### Money

Lium $34,578.48; floor OK. Mining spend ≈ $32.88. No new rental. TTL still
2026-08-07T04:53:17Z (~4.6h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:20Z — pass 17: H2 sim advancing (35/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $34.10; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE (epoll wait); engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 16 (not stuck):
   - before wait: king 30/80, chall 30/80
   - after 120s: king **35/80**, chall **35/80**
3. Teacher still the bottleneck (GPUs 0–1 ~97%; king/chall 2–5 idle between
   sample batches with weights loaded; GPUs 6–7 free).
4. Throughput ≈ 5 turns / 2–3 min per side → sampling ETA ~00:40–00:50Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956;
   `min_submission_block`=8767079.

### Money

Lium $34,578.48; floor OK. Mining spend ≈ $34.10. No new rental. TTL still
2026-08-07T04:53:17Z (~4.5h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:23Z — pass 18: H2 sim advancing (40/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $35.53; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE (Rl); engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 17 (not stuck):
   - before wait (00:21Z): king 35/80, chall 35/80
   - after 150s (00:23Z): king **40/80**, chall **40/80**
3. Teacher still bottleneck (GPUs 0–1 100%); king GPUs 2–3 hit 100% during
   sample batch; chall 4–5 idle between; GPUs 6–7 free.
4. Throughput ≈ 5 turns / ~2.5 min per side → sampling ETA ~00:40–00:50Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956;
   `min_submission_block`=8767079. Lium balance $34,570.67 (floor OK).

### Money

Lium $34,570.67; floor OK. Mining spend ≈ $35.53. No new rental. TTL still
2026-08-07T04:53:17Z (~4.5h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:30Z — pass 19: H2 sim advancing (50/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $38.01; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE (Rl→Sl); engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 18 (not stuck):
   - before wait (00:25Z): king 45/80, chall 45/80
   - after 240s (00:29Z): king **50/80**, chall **50/80**
3. Teacher still bottleneck (GPUs 0–1 ~97–98%); king/chall GPUs 2–5 idle
   between sample batches with weights loaded; GPUs 6–7 free.
4. Throughput ≈ 5 turns / ~2.5 min per side → sampling ETA ~00:45–00:55Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956;
   `min_submission_block`=8767079 (toml); Lium balance $34,555.04 (floor OK).

### Money

Lium $34,555.04; floor OK. Mining spend ≈ $38.01. No new rental. TTL still
2026-08-07T04:53:17Z (~4.4h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:34Z — pass 20: H2 sim advancing (65/80 both sides)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $39.84; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled sim pid **68843** — ALIVE (Rl→Sl); engines 8000/8001/8002 health 200.
2. Confirmed real progress since pass 19 (not stuck):
   - before wait (00:31Z): king 55/80, chall 55/80
   - after 180s (00:34Z): king **65/80**, chall **65/80**
3. Teacher still bottleneck (GPUs 0–1 100%); king/chall 2–5 idle between
   sample batches (weights loaded); GPUs 6–7 free.
4. Throughput ≈ 5 turns / ~2.5–3 min per side → sampling ETA ~00:42–00:50Z,
   then force-echo; finish well inside TTL 04:53Z. Did not relaunch or rent.
5. Live snapshot unchanged: king=`kevin954/Affine-5dfqbbh8ev-sft` S≈0.03956;
   `min_submission_block`=8767079 (contract); Lium balance $34,555.04 (floor OK).

### Money

Lium $34,555.04; floor OK. Mining spend ≈ $39.84. No new rental. TTL still
2026-08-07T04:53:17Z (~4.3h left).

### Next

Collect `h2_sim_result.json` margin vs kevin; apply plan.md decision rule.
No submit until margin > 0.04 + H4.

---

## 2026-08-07T00:43Z — pass 21: H2 α=0.5 LOST (−0.010); α=0.65 merge launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $43.18; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled H2 sim — completed @ ~00:39Z. Result:
   - margin **−0.009955**, z=−1.30, se=0.00767
   - king S=0.02888 / chall S=0.01892; both valid
   - H4 OK: r=0.822, base×=0.837
   - mean_λ2: king +0.00359 vs chall **−0.00166** (dilution, not gate fail)
2. SCP'd result+artifact → `experiments/s4-h2-merge/results/`; wrote `result.md`.
3. Per plan.md decision rule (margin < 0.02): launched α=0.65 merge on same
   pod (parents cached). pid 71425 / py 71431 → `/root/merges/h2-kp65`.
   Log `/root/logs/h2_kp65_merge.log`. Shard 1/2 writing at launch.
4. Live king unchanged kevin S≈0.03956. No submit. No new rental.

### Money

Lium $34,539.54; floor OK. Mining spend ≈ $43.18. TTL 04:53Z (~4.1h left).

### Next

When `h2_kp65_merge.done`: re-serve chall=h2-kp65, run 80-turn sim. If margin
still < 0.02 → refute H2 for kevin×pandora; pivot H1 SFT.

---

## 2026-08-07T00:50Z — pass 22: α=0.65 merge DONE; re-serve→sim launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $45.83; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled α=0.65 merge — completed @ 00:48:53Z (333s):
   - 1026 keys merged, 19 copied from kevin (MTP); first_1MiB ≠ kevin
   - meta → `experiments/s4-h2-merge/results/h2_kp65_merge_meta.json`
2. Launched nohup pipeline pid **71925** (`/root/logs/h2_kp65_pipeline.sh`):
   - `MERGE=/root/merges/h2-kp65 restart_for_h2.sh` (teacher kept)
   - king+chall started @ 00:49:47Z; wait_ready in progress at poll
   - then auto `run_sim_duel.py --chall-repo /root/merges/h2-kp65`
     → `/root/affine_data/h2_kp65_sim_result.json`
3. Live king unchanged kevin S≈0.03956. No submit. No new rental.

### Money

Lium $34,531.75; floor OK. Mining spend ≈ $45.83. TTL 04:53Z (~4.0h left).

### Next

Collect `h2_kp65_sim_result.json`; apply plan.md decision rule. Margin <0.02
→ refute H2 kevin×pandora → pivot H1 SFT. No submit until >0.04 + H4.

---

## 2026-08-07T00:56Z — pass 23: α=0.65 serve READY; sim sampling

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $48.04; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled α=0.65 pipeline — king/chall still loading at 00:51Z; waited.
2. Serve READY @ **00:55:19Z** (teacher:8000 king:8001 chall:8002 all 200).
3. Pipeline auto-launched sim @ 00:55:19Z:
   - `run_sim_duel.py --chall-repo /root/merges/h2-kp65` pid **77251**
   - log `/root/logs/h2_kp65_sim.nohup`
   - out `/root/affine_data/h2_kp65_sim_result.json`
4. @ 00:56:15Z GPUs 0–5 busy (teacher+king+chall); sim still early (no
   turn progress lines yet). Did not relaunch. No submit. No new rental.
5. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079.

### Money

Lium $34,516.22; floor OK. Mining spend ≈ $48.04. TTL 04:53Z (~3.9h left).

### Next

Collect `h2_kp65_sim_result.json`; apply plan.md decision rule. Margin <0.02
→ refute H2 kevin×pandora → pivot H1 SFT. No submit until >0.04 + H4.

---

## 2026-08-07T01:00Z — pass 24: α=0.65 sim advancing at 5/80

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $50.07; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled α=0.65 sim pid 77251 — still alive; engines 8000/8001/8002 health 200.
2. 120s recheck confirmed progress: log shows `[sim] king 5/80` +
   `[sim] challenger 5/80`; teacher log +436 lines; teacher ~2 running /
   ~20 waiting (capacity bottleneck). No `h2_kp65_sim_result.json` yet.
3. Live king unchanged kevin S≈0.03956. No submit. No relaunch. No new rental.

### Money

Lium $34,516.22; floor OK. Mining spend ≈ $50.07. TTL 04:53Z (~3.9h left).

### Next

Collect `h2_kp65_sim_result.json` (~01:35Z ETA); apply plan.md decision rule.
Margin <0.02 → refute H2 kevin×pandora → pivot H1 SFT. No submit until >0.04 + H4.

---

## 2026-08-07T01:43Z — pass 25: H2 α=0.65 DONE; H2 REFUTED

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $66.86; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Polled α=0.65 sim through 10→20→45→80/80 (pid 77251); engines stayed 200×3.
2. Result @ **01:37Z**: margin **+0.00725** (z=+0.92, se=0.00792);
   chall S=0.0260 vs king S=0.0187; both valid; r=0.806 base×=0.879 (H4 OK);
   mean_λ2 chal +0.00105. wins=false.
3. SCP'd `h2_kp65_sim_result.json` + artifact → `experiments/s4-h2-merge/results/`.
4. Applied plan.md: α0.5 (−0.010) and α0.65 (+0.007) both < 0.02 → **H2
   refuted** for kevin×pandora linear merges. Wrote `result.md`; updated
   `HYPOTHESES.md` (kept refuted entry).
5. Drafted `experiments/s4-h1-sft/plan.md`. Kept engines hot; no submit; no
   new rental. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079.

### Money

Lium $34,446.14; floor OK. Mining spend ≈ $66.86. TTL 04:53Z (~3.1h left).

### Next

Execute H1 on `mine-sim-1` per `experiments/s4-h1-sft/plan.md` (harvest
teacher_refs → SFT from kevin → re-sim). No submit until margin > 0.04 + H4.

---

## 2026-08-07T01:54Z — pass 26: H1 harvest + LoRA train launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $71.31; plus validator
`affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,430.56 (floor OK). TTL still 04:53Z (no extend API — only
   `schedules rm`, which would drop the dead-man switch; left alone).
2. Built `experiments/s4-h1-sft/{harvest_refs,train_lora,merge_lora,start_h1,
   upload_and_start}.py/sh`. Uploaded 16 duel gz + scripts to pod.
3. Harvest: **440** examples (unique turn_ids, max lp_own), **0** missing
   from corpus. Canonical completion `</think>\nTHOUGHT: {z}\n\n{y}`.
4. Installed peft 0.20.0 + accelerate 1.14.0 via `/root/.local/bin/uv`.
5. Launched LoRA SFT on GPUs **6,7** (engines 0–5 untouched, health 200×3):
   kevin init, r=16 α=32, lr=1e-4, 2 epochs, 110 steps, pid **82057**.
   Step 1 ~63s → ETA ~03:50Z. trainable 8.36M / 34.7B.
6. No submit. No new rental.

### Money

Lium $34,430.56; floor OK. Mining spend ≈ $71.31. TTL 04:53Z (~3h left).

### Next

Wait for `/root/h1/train/train.done` → merge_lora → re-serve chall →
`run_sim_duel.py`. No submit until margin > 0.04 + H4.

---

## 2026-08-07T01:56Z — pass 27: H1 post-train pipeline armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $72.08; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,422.81 (floor OK).
2. Polled H1 train pid 82057: alive, step **3/110** @ ~60s/it, engines 200×3.
   ETA ~03:45Z; TTL 04:53Z leaves ~1h for merge+serve+sim — tight.
3. Wrote + uploaded `experiments/s4-h1-sft/post_train_pipeline.sh`; launched
   nohup pid **83194** waiting on `train.done` → merge `/root/h1/merged` →
   re-serve chall → `run_sim_duel.py` → `/root/affine_data/h1_sim_result.json`.
   Covers Ralph pass gap so handoff cannot miss TTL.
4. No submit. No new rental.

### Money

Lium $34,422.81; floor OK. Mining spend ≈ $72.08. TTL 04:53Z (~3h left).

### Next

Collect `h1_sim_result.json` when pipeline finishes; apply plan.md decision
rule. No submit until margin > 0.04 + H4.

---

## 2026-08-07T01:58Z — pass 28: H1 adapter HF salvage armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $72.77; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,422.81 (floor OK). TTL still 04:53Z.
2. Polled H1: train pid 82057 alive at step **5/110** @ ~55s/it
   (ETA ~03:40Z); engines 200×3; pipeline was waiting (old pid 83194).
3. Risk: sim finish ~04:35Z vs TTL 04:53Z is tight; a kill would erase the
   adapter with no off-pod copy. Wrote `salvage_adapter.py` and patched
   `post_train_pipeline.sh` to push adapter-only to private
   `unconst/Affine-5czsc2fc98-h1-lora` immediately after `train.done`,
   before merge/sim. Not a submission candidate.
4. Uploaded scripts; killed waiting pipeline 83194; relaunched pid
   **83414**. Train untouched. HF_TOKEN sources from `/root/mine.env`.
5. No submit. No new rental.

### Money

Lium $34,422.81; floor OK. Mining spend ≈ $72.77. TTL 04:53Z (~2.9h left).

### Next

Collect `h1_sim_result.json` (+ confirm `adapter_salvage.json`); apply
plan.md decision rule. No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:01Z — pass 29: H1 TTL insurance hardened

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $74.05; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,414.67 (floor OK). TTL still 04:53Z (~2.9h). Note: `lium
   schedules rm` can cancel termination but there is **no re-add API** —
   do not cancel (would drop the deadman).
2. Polled H1: train pid 82057 alive at step **8/110** @ ~63s/it
   (ETA ~03:48Z); engines 200×3; pipeline 83414 waiting; HF_TOKEN present
   via `/root/mine.env` + venv `huggingface_hub` 1.26.1.
3. Pre-created private HF salvage repo `unconst/Affine-5czsc2fc98-h1-lora`
   (CREATE_OK) so final upload cannot fail on create.
4. Armed mid-checkpoint salvage watcher pid **83669** (uploads
   `checkpoint-50` etc under HF path `checkpoint-N/` via patched
   `salvage_adapter.py --path-in-repo`).
5. Armed host-side JSON harvester pid **1375476**
   (`experiments/s4-h1-sft/host_harvest_results.sh`) to SCP
   sim/salvage/train results into `experiments/s4-h1-sft/results/` before
   TTL — no weights on host.
6. No submit. No new rental.

### Money

Lium $34,414.67; floor OK. Mining spend ≈ $74.05. TTL 04:53Z (~2.9h left).

### Next

Collect `h1_sim_result.json` (pod or local results/); apply plan.md
decision rule. No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:04Z — pass 30: H1 post-train merge → GPUs 6,7

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $75.13; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,414.67 (floor OK). TTL
   still 04:53Z (~2.8h). No TTL extend API (`lium update` is jupyter-only;
   `schedules rm` drops deadman with no re-add).
2. Polled H1: train pid 82057 at step **10/110** @ ~61s/it (ETA ~03:45Z);
   engines 200×3; pipeline 83414 waiting; mid-salvage 83669 watching
   `/root/h1/train/checkpoints` (path matches `train_lora.py` output_dir).
3. Risk: CPU merge of 35B after train was the slow post-train step under a
   tight TTL. Patched `merge_lora.py` (`--device-map`) and
   `post_train_pipeline.sh` to merge on **CUDA 6,7** after train exits
   (engines stay on 0–5). Uploaded; killed waiting pipeline 83414;
   relaunched pid **84156**. Train + mid-salvage untouched.
4. No submit. No new rental.

### Money

Lium $34,414.67; floor OK. Mining spend ≈ $75.13. TTL 04:53Z (~2.8h left).

### Next

Collect `h1_sim_result.json` (pod or local results/); apply plan.md
decision rule. No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:09Z — pass 31: H1 post-train TTL — chall-only serve

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $77.11; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,407.24 (floor OK). TTL still 04:53Z (~2.7h). Prior 80-turn sim
   wall-clock ≈ **2515s (~42 min)**.
2. Polled H1: train pid 82057 at step **16/110** @ ~50s/it (ETA ~03:28Z);
   engines 200×3; pipeline was 84156 waiting; mid-salvage 83669 watching.
3. TTL risk after train ≈78–85 min for salvage+merge+serve+sim. King reload
   on every `restart_for_h2.sh` was wasted (king already kevin). Patched:
   - `restart_for_h2.sh`: default **chall-only** stop (`RESTART_KING=0`);
     teacher+king stay hot via `serve_three.sh` pid skip.
   - `post_train_pipeline.sh`: reclaim h2-kp50 before merge; chall-only
     serve; reclaim h2-kp65 after H1 chall up; sim
     `--progress-out /root/affine_data/h1_sim_progress.json`.
   - `run_sim_duel.py`: `--n-turns` + `--progress-out` for TTL watch.
   - host harvest: also SCPs progress + mid metas each poll.
4. Freed dead weights now: `/root/merges/h2-kp50` + genesis HF cache
   (~136G); hub now 174G / merges 68G (kp65 until H1 serve).
5. Killed waiting pipeline 84156 → relaunched pid **84834**. Train +
   mid-salvage untouched. Host harvest relaunched pid **1388880**.
6. No submit. No new rental.

### Money

Lium $34,407.24; floor OK. Mining spend ≈ $77.11. TTL 04:53Z (~2.7h left).

### Next

Collect `h1_sim_result.json` (pod or local results/); apply plan.md
decision rule. No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:12Z — pass 32: H1 dual-phase sim (n40→n80) + adapter bk

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $78.50; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,399.46 (floor OK). TTL still 04:53Z (~2.7h). Train step
   **20/110** @ ~51s/it (ETA ~03:30Z); engines 200×3; mid-salvage 83669.
2. TTL risk: if train slips, full 80-turn sim (~42 min) can miss 04:53Z.
   Patched `post_train_pipeline.sh` to run **n=40 first** (~21 min) then
   n=80 only if ≥50 min remain before soft deadline 04:50Z; otherwise
   exit with n40-only marker. Host harvest now SCPs n40 + progress_n40
   and accepts n40-only pipeline.done.
3. Uploaded; killed waiting pipeline 84834 → relaunched pid **85424**.
   Train + mid-salvage untouched.
4. `lium bk set mine-sim-1 --path /root/h1/train --every 1h --keep 1d`
   (adapter/ckpt-only; complements HF salvage). Host harvest relaunched
   pid **1393267**.
5. No submit. No new rental. Schedule left intact (no re-add API).

### Money

Lium $34,399.46; floor OK. Mining spend ≈ $78.50. TTL 04:53Z (~2.7h left).

### Next

Collect `h1_sim_result.json` (or n40); apply plan.md decision rule.
Prefer n80 for submit gate; n40 is triage only. No submit until margin
> 0.04 + H4.

---

## 2026-08-07T02:18Z — pass 33: cancel Lium TTL so H1 n=80 can finish

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $80.83; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.

### What I did

1. Live king unchanged kevin S≈0.03956; `min_submission_block`=8767079;
   Lium $34,391.63 (floor OK). Train step **26/110** @ ~55s/it
   (ETA ~03:35Z); engines 200×3; mid-salvage 83669; first Trainer ckpt
   still at save_steps=50.
2. Budget math: train+merge+serve → n40 done ~04:11Z → only ~39 min to
   old soft 04:50Z (<50 min gate) ⇒ pipeline would **skip n=80** under
   prior dual-phase logic; n80 wall ~42 min lands on the knife-edge of
   the old 04:53Z Lium Removal.
3. Verified schedule index 1 = `swift-shark-52` / `mine-sim-1`, then
   `lium schedules rm 1`. Describe shows no Removal at; schedules list
   empty. No re-add API, so armed host deadman
   `experiments/s4-h1-sft/host_ttl_deadman.sh` (pid **1405846**) to
   `lium rm mine-sim-1` at **07:00Z** after Name=mine-sim-1 check.
   First deadman attempt grepped wrapped `lium ps` and false-exited;
   fixed to use `lium describe`.
4. Patched pipeline soft deadline **06:50Z** + host harvest to 06:55Z;
   uploaded; relaunched pipeline pid **86845** (train/mid untouched).
5. No submit. No new rental. Extra burn vs old TTL ≤ ~$50 if deadman
   fires at 07:00Z; next pass should kill earlier once sim lands.

### Money

Lium $34,391.63; floor OK. Mining spend ≈ $80.83. Host deadman 07:00Z.

### Next

Collect `h1_sim_result.json` (or n40); apply plan.md decision rule.
Prefer n80 for submit gate; n40 is triage only. Kill mine-sim-1 as soon
as sim done (name-check). No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:21Z — pass 34: H1 poll + HF salvage verify + train_progress harvest

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $82.07; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,383.87 (floor OK).
   Train step **30/110** @ ~59s/it (ETA ~03:41Z); engines 200×3;
   pipeline 86845 waiting; mid-salvage 83669; no sim artifacts yet;
   no Trainer checkpoint-* yet (first at save_steps=50 ~02:42Z).
2. Verified HF salvage path end-to-end on pod: repo
   `unconst/Affine-5czsc2fc98-h1-lora` private; upload+delete probe OK.
   `lium bk show mine-sim-1` = `/root/h1/train` every 1h keep 1d (no
   logs yet — empty until mid-ckpt).
3. Patched `host_harvest_results.sh` to emit/SCP
   `h1_train_progress.json` each poll (step/engines/ckpts) so next passes
   can triage without SSH. Relaunched harvest pid **1414858** (was
   1405460). Local file now at
   `experiments/s4-h1-sft/results/h1_train_progress.json`.
4. No submit. No new rental. Train/pipeline/mid-salvage/deadman untouched.

### Money

Lium $34,383.87; floor OK. Mining spend ≈ $82.07. Host deadman 07:00Z.

### Next

Poll `results/h1_train_progress.json` / sim artifacts; apply plan.md
decision rule when n40/n80 land. Kill mine-sim-1 as soon as sim done
(name-check). No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:26Z — pass 35: H1 poll + loss visibility fix

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $83.67; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,376.09 (floor OK).
   Train step **34/110** @ ~56s/it (ETA ~03:37Z); engines 200×3;
   pipeline 86845 waiting; mid-salvage 83669; GPU7 util 40% / ~82GB
   (train live); no ckpt-* yet; no sim artifacts.
2. Found **stdout loss gap**: transformers 5.14 uses ProgressCallback
   `tqdm.write` when tqdm enabled; under nohup the loss dicts never hit
   `h1_train.nohup` (clear/`\r` only). `log_history` still lands in
   `trainer_state.json` at save_steps=50 — first loss numbers ~02:42Z.
3. Patched host harvest to scrape `trainer_state.json` →
   `results/h1_train_{progress,loss}.json` + staged
   `h1_trainer_state.json`; relaunched harvest pid **1421187**.
   Verified new fields (`n_loss_logs=0` until ckpt-50).
4. Added `PrintLossCallback` to `train_lora.py` and uploaded to pod
   (current train pid 82057 still old code — helps only on restart).
5. No submit. No new rental. Train/pipeline/mid-salvage/deadman untouched.

### Money

Lium $34,376.09; floor OK. Mining spend ≈ $83.67. Host deadman 07:00Z.

### Next

Poll progress/loss JSON; at step 50 confirm ckpt + non-null loss +
mid-salvage HF push. Then train.done → n40/n80. Kill mine-sim-1 as soon
as sim done (name-check). No submit until margin > 0.04 + H4.

---

## 2026-08-07T02:43Z — pass 36: ckpt-50 loss + HF salvage fix

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $90.47; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 + harvest 1421187 still alive. King unchanged kevin
S≈0.03956. Lium $34,352.70 (floor OK).

### What I did

1. Polled H1 train to **checkpoint-50** (step 51–53/110). Engines 200×3;
   pipeline 86845 waiting; GPU7 train live.
2. First loss numbers from `trainer_state.json` (stdout still tqdm-swallowed):
   step5 **0.283** → step50 **0.329**; min **0.215** @ step35. Flat/noisy
   on already-SFT kevin base — not a kill signal by itself; sim decides.
3. Mid-salvage **failed** first: PEFT README `base_model` was the local
   hub snapshot path; HF YAML validation rejected upload. Same bug would
   have broken final `post_train_pipeline` salvage.
4. Fixed `salvage_adapter.py`: stage adapter-only files, rewrite
   `base_model` / `base_model_name_or_path` to Hub id
   `kevin954/Affine-5dfqbbh8ev-sft`, skip optimizer/rng bulk. Uploaded to
   pod; salvage OK → private
   `unconst/Affine-5czsc2fc98-h1-lora/checkpoint-50` commit `6b2b7315…`
   (also watcher OK at 02:42:46Z). Local copies:
   `results/mid_checkpoint-50_salvage.json`,
   `results/h1_trainer_state_ckpt50.json`.
5. No submit. No new rental. Train/pipeline/deadman untouched.

### Money

Lium $34,352.70; mining spend ≈ $90.47. Host deadman 07:00Z.

### Next

Poll for `train_done` (~03:33Z) → adapter salvage → n40→n80. Kill
mine-sim-1 as soon as sim done (name-check). No submit until margin > 0.04 + H4.


---

## 2026-08-07T02:49:48Z — pass 37: epoch-1 milestone + harvest stdout-loss scrape

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $92.72; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,344.92 (floor OK).
   Train step **59/110** (epoch 1 done @ step55); engines 200×3;
   pipeline 86845 waiting; mid-salvage 83669; GPU6/7 train live;
   no sim artifacts yet. ETA train.done ~**03:35Z**.
2. Verified post-train path still healthy: `salvage_adapter.py` Hub-base
   fix on pod; `mine.env` has HF_TOKEN; adapter_config base path exists
   for merge; only `/root/merges/h2-kp65` left to reclaim after serve.
3. Captured epoch-1 loss **0.251** (stdout Trainer dump). Flat/noisy vs
   ckpt50 last 0.329 / min 0.215 — expected on already-SFT kevin; sim decides.
4. Fixed host harvest: inline Python heredoc broke on single-quoted loss
   dicts (killed harvest briefly). Extracted
   `experiments/s4-h1-sft/emit_train_progress.py`; restarted harvest pid
   **1447863**. Progress JSON now reports `last_loss=0.251`,
   `n_stdout_losses=11`.
5. No submit. No new rental. Train/pipeline/mid-salvage/deadman untouched.

### Money

Lium $34,344.92; mining spend ≈ $92.72. Host deadman 07:00Z.

### Next

Poll for `train_done` (~03:35Z) → adapter salvage → n40→n80. Kill
mine-sim-1 as soon as sim done (name-check). No submit until margin > 0.04 + H4.


---

## 2026-08-07T02:51:41Z — pass 38: H1 step62 + host early-teardown armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $93.77; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,337.16 (floor OK).
   Train step **62/110** (epoch 2); engines 200×3; pipeline 86845 waiting;
   mid-salvage 83669; GPU6/7 train live; no sim artifacts yet. ETA
   train.done ~**03:35Z**.
2. Confirmed post-train path still healthy (adapter salvage Hub-base fix on
   pod; train.done → merge → chall-only → n40→n80). Disk 5.7T free;
   ckpt-50 adapter ~33MB on disk + HF.
3. **Useful increment:** patched `host_harvest_results.sh` so when
   sim+salvage+train artifacts are all local, it name-checks
   `lium describe mine-sim-1` then `lium rm mine-sim-1 -y`. Stops $23.60/h
   burn as soon as the decision signal lands instead of waiting for the
   07:00Z deadman (could save ~1–2h / $24–47 if sim finishes ~05:00Z).
   Restarted harvest pid **1454856**. Deadman remains as backstop.
4. Wrote `results/h1_epoch2_mid.json`. No submit. No new rental.
   Train/pipeline/mid-salvage/deadman untouched.

### Money

Lium $34,337.16; mining spend ≈ $93.77. Host deadman 07:00Z + early teardown.

### Next

Poll for `train_done` (~03:35Z) → adapter salvage → n40→n80. Confirm
harvest early-rm (or name-check kill). No submit until margin > 0.04 + H4.


---

## 2026-08-07T02:54:19Z — pass 39: H1 step65 + sim triage wired into harvest

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $94.80; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,337.16 (floor OK).
   Train step **65/110** (epoch 2); engines 200×3; pipeline 86845 waiting
   (soft deadline **06:50Z** confirmed on pod copy of post_train_pipeline.sh);
   mid-salvage 83669; GPU6/7 train live; no sim artifacts yet. ETA
   train.done ~**03:35Z** (~45 steps × ~54s).
2. Confirmed early-teardown cannot kill mid-n80: `got_sim` needs
   `h1_sim_result.json` or (n40 + `h1_pipeline.done`); pipeline.done only
   after n80 or n40-only skip.
3. **Useful increment:** added `experiments/s4-h1-sft/triage_sim.py`
   (plan.md decision rule → `results/h1_decision.json`; n40-only never
   `toward_submit`, only `confirm_n80`). Wired into
   `host_harvest_results.sh`; restarted harvest pid **1459477**. Smoke on
   H2 α0.65 JSON → action `revise_recipe` margin +0.007 (as expected).
4. Wrote `results/h1_epoch2_step_poll.json`. No submit. No new rental.
   Train/pipeline/mid-salvage/deadman untouched.

### Money

Lium $34,337.16; mining spend ≈ $94.80. Host deadman 07:00Z + early teardown.

### Next

Poll for `train_done` (~03:35Z) → adapter salvage → n40→n80. Read
`results/h1_decision.json` when present. Kill mine-sim-1 as soon as sim
done (name-check). No submit until action=`toward_submit`.


---

## 2026-08-07T02:58:34Z — pass 40: fail-closed mid-ckpt promote + n80 budget verified

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $96.48; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z; harvest 1459477 alive.

### What I did

1. Live king unchanged kevin S≈0.03956; Lium $34,329.39 (floor OK).
   Train step **69/110** (epoch 2); engines 200×3; mid-salvage 83669;
   GPU6/7 train live; no sim artifacts yet. ETA train.done ~**03:36Z**.
2. Verified soft deadline parse on pod: `date -u -d 2026-08-07T06:50:00Z`
   → epoch 1786085400; remain ~13965s; WOULD_RUN_N80. Time budget
   (`results/h1_time_budget.json`): n80 done ~05:02Z, slack soft ~108 min.
3. **Useful increment:** patched `post_train_pipeline.sh` so if train dies
   before `train.done`, it **promotes the latest mid-checkpoint** into
   `/root/h1/train/adapter` and continues salvage→merge→n40→n80 (writes
   `/root/h1/train_fallback.json`) instead of exiting. SCP'd to pod;
   restarted waiting pipeline **86845 → 102073**. Train 82057 untouched.
4. Wrote `results/h1_time_budget.json` + refreshed step poll. No submit.
   No new rental.

### Money

Lium $34,329.39; mining spend ≈ $96.48. Host deadman 07:00Z + early teardown.

### Next

Poll for `train_done` (~03:36Z) → adapter salvage → n40→n80. Read
`results/h1_decision.json` when present. If train died, check
`train_fallback.json`. Kill mine-sim-1 as soon as sim done (name-check).
No submit until action=`toward_submit`.


---

## 2026-08-07T03:02:02Z — pass 41: merge first_1MiB≠kevin refuse gate

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $97.83; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z; harvest restarted **1471795**.

### What I did

1. Live king unchanged kevin S≈0.03956; min_submission_block **8767079**;
   Lium $34,321.27 (floor OK). Train step **73/110** (epoch 2); engines
   200×3; mid-salvage 83669; pipe 102073 waiting; ETA train.done ~**03:35Z**.
2. Observed this run has **0** `[train-log]` lines despite PrintLossCallback
   (likely non-float log values → json.dumps throw swallowed by Trainer).
   Staged float coercion in `train_lora.py` for future runs (train process
   already in memory — not restarted). Epoch-2 losses still arrive at
   checkpoint-100 via trainer_state.
3. **Useful increment:** `merge_lora.py` now computes first_1MiB sha of
   merged vs kevin base and **refuses** (SystemExit) if identical — same
   hygiene H2 merge had — so we never burn ~66 min n40+n80 on a no-op.
   Writes `/root/affine_data/h1_merge_meta.json`. Smoke on pod: kevin shard
   sha **c551c752…** matches H2 meta. Host harvest SCPs merge meta.
4. Wrote `results/h1_epoch2_step_poll.json`. No submit. No new rental.
   Train/pipeline/mid-salvage/deadman untouched (only SCP'd merge+train
   scripts; merge runs after train.done).

### Money

Lium $34,321.27; mining spend ≈ $97.83. Host deadman 07:00Z + early teardown.

### Next

Poll for `train_done` (~03:35Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → n40→n80. Read `results/h1_decision.json`
when present. Kill mine-sim-1 as soon as sim done (name-check). No submit
until action=`toward_submit`.

---

## 2026-08-07T03:05:27Z — pass 42: arm background HF push of merged weights

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $99.00; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z; harvest restarted **1478941**.

### What I did

1. Live king unchanged kevin S≈0.03956; min_submission_block **8767079**;
   Lium $34,313.83 (floor OK). Train step **76/110** (epoch 2); engines
   200×3; mid-salvage 83669; ETA train.done ~**03:37Z**. No sim artifacts.
2. Gap: only the LoRA adapter was HF-salvaged. A sim win + 07:00Z deadman
   would erase the only vLLM-ready merged tree and force another rental to
   re-merge before Stage-5 submit.
3. **Useful increment:**
   - Pre-created private HF repo `unconst/Affine-5czsc2fc98-h1-merged`.
   - Added `push_merged.py` (size/hygiene gates; pod-only upload).
   - Patched `post_train_pipeline.sh` to **nohup** the push right after
     merge (parallel with chall re-serve + n40/n80) and wait for it before
     pipeline exit (n40-only and n80 paths).
   - Host harvest SCPs `h1_merged_salvage.json` and **defers early-teardown**
     while push pid is alive (≤20 min grace).
   - SCP'd scripts; restarted waiting pipeline **102073 → 105148**. Train
     82057 untouched.
4. Wrote `results/h1_epoch2_step_poll.json`. No submit. No new rental.

### Money

Lium $34,313.83; mining spend ≈ $99.00. Host deadman 07:00Z + early teardown
with merged-push grace.

### Next

Poll for `train_done` (~03:37Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → merged_salvage → n40→n80. Read
`results/h1_decision.json` when present. Kill mine-sim-1 only after push
meta or grace (name-check). No submit until action=`toward_submit`.

---

## 2026-08-07T03:08:17Z — pass 43: fix early-teardown gate for fail-closed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $100.29; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host deadman 1405846 still armed for 07:00Z; harvest restarted **1486917**.

### What I did

1. Live king unchanged kevin S≈0.03956; min_submission_block **8767079**;
   Lium $34,313.83 (floor OK). Train step **79/110** (epoch 2); engines
   200×3; mid-salvage 83669; pipe 105148 waiting; ETA train.done ~**03:37Z**.
   Disk `/root` 5.7T free; `mine.env` HF_TOKEN present. No sim artifacts yet.
2. Live eval **chal-00274** `adambell/Affine-5dvha3y7cd-ckpt450-H6` in
   scoring (watch for king change before any submit). reg_cost_tao ≈ **0.676**.
3. **Bug:** host early-teardown required `train_result.json` +
   `adapter_salvage.json`. Fail-closed promote writes `train_fallback.json` +
   `train.done` only → teardown would never fire → burn until 07:00Z deadman.
   Same if final adapter HF salvage flakes despite mid-ckpt already on HF.
4. **Useful increment:** patched `host_harvest_results.sh`:
   - `got_train` ← train_result **or** train_fallback **or** train.done
   - `got_salvage` ← adapter_salvage **or** mid_*_salvage **or** merged_salvage
   - Restarted harvest **1478941 → 1486917**. Train/pipeline/deadman untouched.
5. Wrote `results/h1_epoch2_step_poll.json`. No submit. No new rental.

### Money

Lium $34,313.83; mining spend ≈ $100.29. Host deadman 07:00Z + early teardown
with train_fallback path + merged-push grace.

### Next

Poll for `train_done` (~03:37Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → merged_salvage → n40→n80. Re-check snapshot
king (chal-00274). Read `results/h1_decision.json` when present. No submit
until action=`toward_submit`.

---

## 2026-08-07T03:11:56Z — pass 44: triage live-king guard (H6 mid-duel)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $101.74; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive.

### What I did

1. Live king still kevin S≈0.03956. Train step **84/110** (GPU6 80%); engines
   200×3; pipe 105148 waiting; mid-salvage 83669; ETA train.done ~**03:36Z**.
   Lium $34,306.02 (floor OK). No sim artifacts yet.
2. **Risk:** chal-00274 `adambell/…ckpt450-H6` scoring king **70/80** — can
   crown before/during our n40→n80. A kevin-margin `toward_submit` would burn
   a slot against the wrong king.
3. **Useful increment:**
   - `triage_sim.py`: fetch snapshot with User-Agent; if sim king ≠ live king
     and action is crownward → `re_sim_new_king`; if fetch fails on crownward
     → `confirm_live_king` (fail closed, `submit=false`). Smoke: match→
     `toward_submit`; stale→`re_sim_new_king`.
   - `run_sim_duel.py`: persist `king_rev` in result JSON; SCP'd to pod
     (pipeline has not started sim yet).
   - Wrote `results/h1_live_king_watch.json` + refreshed time budget / step poll.
4. No submit. No new rental. Train/pipeline/deadman untouched.

### Money

Lium $34,306.02; mining spend ≈ $101.74. Host deadman 07:00Z + early teardown
with push grace.

### Next

Poll for `train_done` (~03:36Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → merged_salvage → n40→n80. Read
`results/h1_decision.json` when present (live-king guard). Watch H6 crown.
No submit until action=`toward_submit`.

---

## 2026-08-07T03:15:18Z — pass 45: H6 verdict captured; kevin still king

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $102.97; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive. Train step **87/110**;
engines 200×3; pipe 105148 waiting; ETA train.done ~**03:36Z**.

### What I did

1. Polled `api/v1/snapshot` through end of chal-00274. H6 finished scoring
   ~03:14Z; current_eval cleared; **king unchanged** kevin @ S≈0.03956.
2. Fetched `https://affine.io/api/v1/duels/chal-00274` and wrote:
   - `results/chal-00274_verdict.json` (full)
   - `results/chal-00274_h6_summary.json` (decision fields)
   - refreshed `h1_live_king_watch.json` / time budget / step poll
3. **H6 numbers that matter:**
   - margin **+0.02287** (clears δ=0.02) but z=**2.371** &lt; 3
   - SE=0.00965 → 3·SE=**0.02894** (binding bar this slice)
   - chall S=+0.0170 vs king-slice S=**−0.0060** (huge slice swing vs
     published king S 0.0396)
   - r=0.757, base×=0.975 (H4 envelope OK); mean Λ2 still negative both sides
   - `challenger_wins=false`, `accepted=false`
4. Lesson for Stage 5: clearing min_margin alone is a common near-miss; need
   margin ≳ 3·SE. Our submit gate **0.04** would correctly refuse H6.
   H1 sim-vs-kevin remains the right target. Queue head: chal-00275.
5. No submit. No new rental. Train/pipeline/deadman untouched.

### Money

Lium $34,306.02; mining spend ≈ $102.97. Floor OK. Host deadman 07:00Z.

### Next

Poll for `train_done` (~03:36Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → merged_salvage → n40→n80. Read
`results/h1_decision.json` when present. Watch queue (chal-00275+). No
submit until action=`toward_submit`.

---

## 2026-08-07T03:28:31Z — pass 46: checkpoint-100 on HF; emit prefers numeric ckpt

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $108.12; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive. Train step **101/110**;
engines 200×3; pipe 105148 waiting; ETA train.done ~**03:37Z**.

### What I did

1. Polled train through **checkpoint-100** (appeared ~03:27Z). Mid-salvage
   pid 83669 pushed adapter-only to private
   `unconst/Affine-5czsc2fc98-h1-lora/checkpoint-100` commit
   `d68c0a3b…` at 03:27:30Z. Meta:
   `results/mid_checkpoint-100_salvage.json`,
   `results/h1_trainer_state_ckpt100.json`,
   `results/h1_epoch2_ckpt100.json`.
2. **Loss path that matters:** epoch1 **0.251** @55 → ckpt100 last **0.207**
   @100 (epoch 1.818). Min so far **0.175** @80. Transient spike **1.86** @70 /
   0.93 @75 then recovered — not a train death.
3. Found host progress stuck on ckpt-50 loss (0.329): `emit_train_progress.py`
   used lexical `sorted(...)` so `checkpoint-100` < `checkpoint-50` and
   `candidates[-1]` picked 50. Fixed to numeric step sort; SCP'd to pod;
   progress now reports last_loss **0.207** from ckpt-100.
4. Live: kevin still king; **chal-00275** Tok331102/…-af6 **scoring**
   (king 15/80 @ 03:27Z). Watch for crown before/during our n40→n80.
5. No submit. No new rental. Train/pipeline/deadman untouched.

### Money

Lium $34,282.69; mining spend ≈ $108.12. Floor OK. Host deadman 07:00Z.

### Next

Poll for `train_done` (~03:37Z) → adapter salvage → merge_meta
(`first_1MiB_identical: false`) → merged_salvage → n40→n80. Read
`results/h1_decision.json` when present. Watch chal-00275. No submit until
action=`toward_submit`.

---

## 2026-08-07T03:56:51Z — pass 47: H1 train DONE; first_1MiB gate false-positive; resume sim

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $119.34; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive.

### What I did

1. Polled train through **DONE** at **03:35:57Z** (110/110). Final loss
   **0.2367** @ epoch 2.0; min still **0.175** @80. Adapter salvaged to
   private `unconst/Affine-5czsc2fc98-h1-lora` commit `4fe72892…` at 03:36:25Z.
2. Pipeline merged on CUDA 6,7 (~356s) then **refused sim** because
   `first_1MiB_identical: true` vs kevin (`c551c752…`). Pipe exited.
3. Diagnosed false-positive:
   - Both shards: head=mid=equal, **tail ≠**
   - Tensors: embed/lm_head equal (expected); **q/k/v/o_proj** and
     `shared_expert.gate_proj` **differ** from kevin
   - Adapter norms healthy (mean ~1.21, 320 tensors) — LoRA applied
   - Root cause: first_1MiB of shard-1 is embed-leading; LoRA never touches it
4. Fixed `merge_lora.py` identity check → head/mid/tail on
   `model-*-of-*.safetensors`; refuse only if all windows match.
5. Launched `resume_after_false_identical.sh` pid **127103** (no re-merge):
   rewrite meta (`weight_identical: false`,
   `false_positive_first_1MiB_gate: true`) → bg `push_merged` **127187** →
   chall-only re-serve `/root/h1/merged` (loading @ 03:56Z) → n40→n80.
6. Live: kevin still king; chal-00275 cleared; **chal-00276** scoring
   (king 42/80). Artifacts under `experiments/s4-h1-sft/results/`
   (`h1_train_done.json`, `h1_false_identical_gate.json`, updated
   `h1_merge_meta.json`).

### Money

Lium $34,235.98; mining spend ≈ $119.34. Floor OK. No new rental. No submit.

### Next

Poll chall health → n40 → n80 / `h1_decision.json` / merged HF salvage.
No submit until action=`toward_submit`.

## 2026-08-07T04:11:12Z — pass 48: CausalLM merge serve bugs → chall READY + n40 sim

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $125.06; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive.

### What I did

1. Polled pass-47 resume: teacher+king 200; chall **dead**. Log showed
   `TypeError: Expected Qwen3_5MoeConfig, found Qwen3_5MoeTextConfig`.
2. Root cause: `merge_lora.py` used `AutoModelForCausalLM.save_pretrained`,
   which wrote `model_type=qwen3_5_moe_text` /
   `Qwen3_5MoeForCausalLM` instead of the king's multimodal wrapper
   (`qwen3_5_moe` / `Qwen3_5MoeForConditionalGeneration`) and omitted
   preprocessor sidecars.
3. Restored wrapper `config.json` + preprocessor configs from kevin base;
   patched HF salvage (commit later superseded). First re-serve then failed
   on missing vision weights:
   `ValueError: Following weights were not initialized … visual.*`
   — CausalLM save also dropped `model-visual-extra.safetensors`
   (352 `model.visual.*` keys, 2.58 GB). Copied shard + merged weight_map
   into index (1045/1045 keys).
4. Updated `merge_lora.py` and `resume_after_config_fix.sh` to restore
   wrapper config + visual shard after every merge. HF salvage now at
   `unconst/Affine-5czsc2fc98-h1-merged` commit `3364892cefcc…`.
5. Chall /health **200** at **04:10:15Z**; n40 sim pid **137799** launched.
   kevin still king; live eval moved to **chal-00279** (load_challenger).

### Money

Lium $34,212.62; mining spend ≈ $125.06. Floor OK. No new rental. No submit.

### Next

Poll n40 → n80 / `h1_decision.json`. No submit until `toward_submit`.

## 2026-08-07T04:29:15Z — pass 49: H1 n40 DONE margin −0.00241 → revise_recipe; n80 launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $131.54; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive.

### What I did

1. Polled n40 after pass-48 chall READY. Sim advanced ~2–3 turns/min
   (teacher GPUs 0–1 hot). Finished **04:27:07Z**.
2. **n40 result vs kevin:** margin **−0.00241** (z=−0.18, SE=0.0132);
   chall S=−0.03548 vs king S=−0.03263; both gate-valid; **H4 FAIL**
   (r=**1.135**∉[0.70,0.85], base×=0.817 OK).
3. Decomposition: chall mean_Λ2 **better** than king (−0.0345 vs −0.0380)
   but implied clip-L1 collapsed (−0.0009 vs king +0.0054). Recipe hurt
   the L1/calib envelope that crowns under H3/H4.
4. Triage → `revise_recipe` / `submit: false`
   (`experiments/s4-h1-sft/results/h1_decision.json` + `result.md`).
   Live-king guard: still kevin (chal-00279 scoring ~57/80).
5. Pipeline already launched **n80** at 04:27:07Z (pid 143331, ~8573s to
   soft 06:50Z). Left running for SE confirmation — do not submit this ckpt.

### Money

Lium $34,189.24; mining spend ≈ $131.54. Floor OK. No new rental. No submit.

### Next

Poll n80 → re-triage (expect confirm revise). Then H1v2 / H5 — fix r back
into ~0.72–0.85 and recover clip-L1. No slot burn on this merge.

## 2026-08-07T04:33:35Z — pass 50: n80 advancing; H1v2 plan (thought-only)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $133.70; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive.

### What I did

1. Polled H1 n80 (pid 143331): engines 200×3; progress king **11**/80 /
   chall **10**/80 @ 04:33Z (~2.5 turns/min; ETA ~05:00Z). Result file not
   yet written. Soft 06:50Z / deadman 07:00Z still OK.
2. Snapshot: kevin still king @ S=0.03956. chal-00279 finished; live eval
   moved to **chal-00280** (Tok331102/…-af8) dispatching.
3. Used idle pass time for the next recipe: wrote
   `experiments/s4-h1v2-sft/plan.md` + HYPOTHESES **H1v2**. Pre-registered
   fix for H1's envelope failure: mask loss to teacher **z_C only** (stop
   before bash fence), lr **2e-5**, **1 epoch**. Prediction: margin ≥ +0.04
   with r∈[0.70,0.85] and clip-L1 ≥ +0.015. Do not submit H1 merge.

### Money

Lium $34,181.35; mining spend ≈ $133.70. Floor OK. No new rental. No submit.

### Next

Poll n80 → re-triage → implement/launch H1v2 on same pod before 07:00Z if
possible. No slot burn on H1.

## 2026-08-07T04:37:27Z — pass 51: H1v2 thought-only train launched (parallel w/ n80)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $135.36; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive. Lium $34,173.73 (floor OK).

### What I did

1. Polled H1 n80 (pid 143331): engines 200×3; progress king **16**/80 /
   chall **16**/80 @ 04:36Z. Result not ready. kevin still king; chal-00280
   in `load_challenger`.
2. Noticed GPUs **6,7 idle** while n80 burns 0–5 — no reason to wait for n80
   before H1v2 train (merge/serve still waits for train.done + chall restart).
3. Implemented `experiments/s4-h1v2-sft/`: `thought_mask.py` (cut at
   `\n\n```bash`), `train_lora.py --loss-on thought` (offset_mapping label
   mask), `verify_thought_mask.py`, `start_h1v2.sh`. Sample verify pass;
   full 440/440 fence OK on pod (mean thought 291 chars / action 370).
4. SCP'd to pod; launched train pid **147209** @ 04:36:23Z — kevin base
   loading on 6,7 (~33 GB/GPU). lr=2e-5, 1 epoch, LoRA r16. Prediction
   unchanged: n80 sim margin ≥ +0.04 with r∈[0.70,0.85] and clip-L1 ≥ +0.015.
5. Do **not** submit H1 merge. Soft 06:50Z / deadman 07:00Z still bind.

### Money

Lium $34,173.73; mining spend ≈ $135.36. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done + H1 n80 result → merge/serve H1v2 → n40 triage.

## 2026-08-07T04:41:30Z — pass 52: n80 ReadTimeout recovery + H1v2 post-train armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $136.96; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Host harvest 1486917 + deadman 1405846 still alive. Lium $34,165.93 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** alive — base loaded, step **3**/55 @
   ~59s/it (ETA ~05:32Z). Engines 200×3.
2. Found H1 n80 **dead**: pid 143331 gone; progress stuck king/chall **16**/80
   @ 04:36:26Z. Log ends in `httpx.ReadTimeout` on sample after 180s×3 retries.
3. Patched pod-local `vllm_client` → timeout **360s**, retries **5**. Restarted
   n80 pid **149213** via `experiments/s4-h1-sft/restart_n80.sh`. Evidence:
   `results/h1_n80_restart.json`.
4. Armed H1v2 `post_train_pipeline.sh` pid **149216**: wait `train.done` →
   merge_lora (reuse CausalLM+visual fixes) → chall-only serve → n40 triage
   to `/root/affine_data/h1v2_sim_result_n40.json`. Waits for n80 before
   chall restart; kills sim if <45m to soft 06:50Z.
5. kevin still king; chal-00280 still `load_challenger`. Do **not** submit H1.

### Money

Lium $34,165.93; mining spend ≈ $136.96. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done / pipe n40 + H1 n80 result. Prefer H1v2 path for submit
gate. Soft 06:50Z / deadman 07:00Z.
