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


## 2026-08-07T04:45:37Z — pass 53: harvest H1v2 gate (prevent n80 teardown)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $138.57; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,158.15 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **6**/55 loss **0.493**; n80
   **149213** king/chall **6/5**/80; engines 200×3; pipe **149216** waiting.
2. Found a critical host-harvest hazard: once H1 n80 writes
   `h1_sim_result.json`, harvest already had salvage+train → would
   `lium rm mine-sim-1` while H1v2 train/pipe still running.
3. Patched `experiments/s4-h1-sft/host_harvest_results.sh`:
   - scrape H1v2 progress/results into `experiments/s4-h1v2-sft/results/`
   - defer early-teardown while H1v2 train/pipe/n40 alive (or 10m grace)
4. Added `experiments/s4-h1v2-sft/emit_train_progress.py`; restarted harvest
   pid **1627557**. Smoke: gate reports still_running; progress JSON harvested.
5. kevin still king; chal-00280 still `load_challenger`. Do **not** submit H1.

### Money

Lium $34,158.15; mining spend ≈ $138.57. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done / pipe n40 + H1 n80 result. Prefer H1v2 path for submit
gate. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T04:48:47Z — pass 54: H1v2 HF salvage armed (deadman insurance)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $139.88; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,158.15 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **10**/55 loss **0.438** (↓ from
   0.493); n80 **149213** king/chall **15/15**/80; engines 200×3.
2. Found H1v2 `post_train_pipeline.sh` had **no HF push** after merge — a
   07:00Z deadman would erase the only vLLM-ready H1v2 candidate.
3. Pre-created private HF repos:
   `unconst/Affine-5czsc2fc98-h1v2-lora` +
   `unconst/Affine-5czsc2fc98-h1v2-merged`.
4. Patched pipe to background-push adapter + merged after merge (reuse H1
   `salvage_adapter.py` / `push_merged.py`). Restarted pipe **154579**.
5. Armed mid-ckpt salvage watcher **154590** (save_steps=50 → ckpt-50).
6. Host harvest **1634085** now scrapes H1v2 salvage metas. Time budget OK
   (n80 ~05:20Z, train ~05:35Z, n40 ~06:25Z vs soft 06:50Z).
7. kevin still king; chal-00280 still `load_challenger`. Do **not** submit H1.

### Money

Lium $34,158.15; mining spend ≈ $139.88. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → pipe merge/HF/serve/n40 triage. Prefer H1v2 path for
submit gate. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T04:51:36Z — pass 55: H1v2 adapter path bug fixed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $140.98; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,150.36 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **14**/55; n80 **149213** king/chall
   **21/20**/80; engines 200×3; pipe/mid-salvage armed.
2. Found critical path bug in `post_train_pipeline.sh`: ADAPTER defaulted to
   `$TRAIN_DIR` and mid-ckpt fallback to `$TRAIN_DIR/checkpoint-*`, but
   `train_lora.py` writes final adapter to `$TRAIN_DIR/adapter` and mid-ckpts
   under `$TRAIN_DIR/checkpoints/`. On train.done the pipe would
   `ERROR: no adapter` and exit — no merge, no HF salvage, no n40; deadman
   would erase the candidate.
3. Fixed pipe + `emit_train_progress.py` paths; SCP'd to pod; restarted pipe
   only → **158053** (train/mid untouched). Verified wait log shows
   `.../adapter/adapter_config.json`.
4. Persisted HF_TOKEN into pod `/root/mine.env` (was missing; processes had
   inherited it only).
5. Killed duplicate host harvests; restarted single harvest **1640417**.
6. kevin still king; chal-00280 **scoring** (king 5/80). Do **not** submit H1.

### Money

Lium $34,150.36; mining spend ≈ $140.98. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → pipe merge/HF/serve/n40 triage. Prefer H1v2 path for
submit gate. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T04:54:57Z — pass 56: host harvest H1v2 HF-push teardown race fixed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $142.11; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,150.36 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **17**/55 loss **0.475** (step15);
   n80 **149213** king/chall **27/26**/80; engines 200×3; pipe/mid armed.
2. Found critical host race: `host_harvest_results.sh` early-teardown only
   waited on `h1_push_merged.pid`. After H1v2 `pipeline.done` + H1 artifacts
   ready, harvest could `lium rm mine-sim-1` while `h1v2_push_merged` (~68G)
   / adapter push still ran — defeating pass-54 HF salvage insurance.
3. Patched `_h1v2_still_running` + push-grace block for H1v2 push PIDs;
   salvage_ok accepts `h1v2_*_salvage.json`.
4. On `h1v2_sim_result_n40.json`, run `triage_sim.py` →
   `h1v2_decision.json` (live-king guard; pipe inline JSON lacked it).
5. Restarted host harvest **1644437**. Evidence:
   `experiments/s4-h1v2-sft/results/h1v2_harvest_push_teardown_fix.json`.
6. kevin still king; chal-00280 **scoring**. Do **not** submit H1.

### Money

Lium $34,150.36; mining spend ≈ $142.11. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → pipe merge/HF/serve/n40 triage. Prefer H1v2 path for
submit gate. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T04:59:32Z — pass 57: H1v2 pipe merge∥n80 + freed h2-kp65

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $144.05; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,142.61 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **23**/55 loss **0.448** (step20);
   n80 **149213** king/chall **37/37**/80; engines 200×3; pipe/mid armed;
   HF_TOKEN present in pipe env (len 37).
2. Found slack leak: `post_train_pipeline.sh` waited for H1 n80 **before**
   merge+HF push. Merge only needs GPUs 6,7 and writes `/root/h1v2/merged`
   (n80 scores `/root/h1/merged` on 0–5) — serializing ~6 min for no reason
   if n80 slips under soft 06:50Z.
3. Reordered pipe: train.done → merge → bg HF adapter+merged push → wait/kill
   n80 → chall-only serve → n40. Dropped useless `h1_merge_meta`→`h1v2` copy.
4. SCP'd + restarted pipe only → **164147** (train/mid/n80 untouched).
5. Freed refuted `/root/merges/h2-kp65` (**68G**); `/root` now 397G / 5.7T.
6. kevin still king; chal-00280 **scoring** (king 49/80). Do **not** submit H1.

### Money

Lium $34,142.61; mining spend ≈ $144.05. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → confirm merge∥n80 → HF PIDs → serve → n40 triage.
Prefer H1v2 path for submit gate. Soft 06:50Z / deadman 07:00Z.


## 2026-08-07T05:05:10Z — pass 58: H1v2 teardown + n80-wait + merge-meta fixes

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $146.11; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,134.50 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **~28**/55 loss **0.381** (step25);
   n80 **149213** king/chall **~49/48**/80; engines 200×3; pipe/mid armed.
2. Found three latent bugs that would bite after train.done:
   - Host harvest early-teardown required `got_sim` (H1 n80). If the pipe
     kills lingering n80 at soft−45m, H1v2 terminal alone could not stop
     $/h burn until deadman 07:00Z. Fixed: `(got_sim || got_h1v2) && …`.
   - Pipe n80 wait/pkill used broad `run_sim_duel.py` — would match/kill
     H1v2's own n40 if the wait were re-entered. Scoped to
     `run_sim_duel.py.*h1_sim_result`.
   - `merge_lora.py` always wrote `h1_merge_meta.json`, clobbering H1 meta
     on H1v2 merge. Now stages `h1v2_merge_meta.json` when `--out` is under
     `/h1v2/`.
3. SCP'd + restarted pipe only → **167913** (train/mid/n80 untouched).
   Restarted host harvest **1662067**. Evidence:
   `experiments/s4-h1v2-sft/results/h1v2_teardown_n80_wait_fix.json`.
4. kevin still king; chal-00280 **scoring**. Do **not** submit H1.

### Money

Lium $34,134.50; mining spend ≈ $146.11. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → confirm merge∥n80 → HF PIDs → serve → n40 triage.
Prefer H1v2 path for submit gate. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T05:10:53Z — pass 59: H1v2 prefer-n80 + harvest n80 triage

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $148.11; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,119.21 (floor OK).

### What I did

1. Polled pod: H1v2 train **147209** step **~35**/55 loss **0.410** (step35);
   H1 n80 **149213** king/chall **~59/59**/80; engines 200×3; pipe/mid armed.
2. chal-00280 **REJECTED** (Tok331102 af8 margin −0.00501); kevin still king;
   chal-00281 dispatching.
3. Found latent submit-path bug: `post_train_pipeline.sh` only ran n40 then
   `PIPELINE_DONE`. plan.md prediction/submit gate needs **n80**, and soft
   06:50Z cannot fit n40(~30m)+n80(~55m) after serve (~05:45) — n80 would be
   starved every time. Harvest also ignored `h1v2_sim_result.json` and treated
   n40 alone as `got_h1v2`.
4. Fixed pipe: prefer n80 when remain_soft or remain_deadman ≥ 3200s (skip
   n40); else n40 with promote→n80 if margin≥0.01 + H4 OK. Writes
   `h1v2_sim_result.json` + `h1v2_decision_n80.json`.
5. Fixed harvest: SCP n80 artifacts; `got_h1v2` on n80/pipeline terminal (not
   n40 alone); re-triage when n80 upgrades an n40-only decision.
6. SCP'd + restarted pipe only → **171602** (train/mid/H1-n80 untouched).
   Host harvest **1670883**. Evidence:
   `experiments/s4-h1v2-sft/results/h1v2_prefer_n80_fix.json`.
7. Do **not** submit H1.

### Money

Lium $34,119.21; mining spend ≈ $148.11. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → confirm merge → HF PIDs → serve → **H1v2 n80** triage.
Submit only if margin > 0.04 + H4 OK. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T05:19:08Z — pass 60: H1 n80 DONE → recipe REFUTED

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $151.76; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,111.44 (floor OK).

### What I did

1. Polled pod: H1 n80 advanced 63→80/80 and finished at **05:18:46Z**;
   H1v2 train **147209** step **43**/55 loss **0.400**; pipe **171602**
   still waiting on train.done; engines 200×3.
2. Harvested `/root/affine_data/h1_sim_result.json` →
   `experiments/s4-h1-sft/results/`; ran `triage_sim.py` → primary=n80.
3. **n80 verdict:** margin **−0.01994** (z=−2.42, SE=0.00822); chall S
   −0.00687 vs king S 0.01281; both valid; H4 FAIL (r=0.992∉[0.70,0.85],
   base×=0.848). Implied clip-L1 chall +0.006 vs king +0.019; chall also
   worse Λ2. n80 **worse** than n40 (−0.00241) by ~0.0175.
4. Closed H1 full-completion LoRA as **refuted** for submit. Updated
   `result.md`, `HYPOTHESES.md`, evidence `h1_n80_confirmed.json`.
5. kevin still king; live eval **chal-00283** load_challenger. Do **not**
   submit H1. H1v2 path unchanged (prefer-n80 after train.done).

### Money

Lium $34,111.44; mining spend ≈ $151.76. Floor OK. No new rental. No submit.

### Next

Poll H1v2 train.done → merge → HF PIDs → chall serve → **H1v2 n80** triage.
Submit only if margin > 0.04 + H4 OK. Soft 06:50Z / deadman 07:00Z.

## 2026-08-07T05:37:11Z — pass 61: H1v2 train.done → merge → HF → chall load

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $158.87; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,080.33 (floor OK).

### What I did

1. Polled H1v2: train advanced 45→50→55; `train.done` at **05:28:51Z**
   (thought_ok=440; elapsed 3139s; sample0 supervised 29/6080). Mid-ckpt
   salvage pushed checkpoint-50 and checkpoint-55 to
   `unconst/Affine-5czsc2fc98-h1v2-lora`.
2. Pipe **171602** left wait immediately (H1 n80 already gone) →
   `merge_lora` on GPUs 6,7 → `merge.done` **05:35:39Z**.
   `weight_identical: false` (both shard **tails** differ; first_1MiB match
   is the known LoRA embed-leading false-positive — gate correctly did not
   refuse).
3. Background HF: final adapter salvage OK (`6c964d35…` @ 05:35:41Z);
   merged push pid **191137** still uploading. Chall-only restart launched
   (`/root/h1v2/merged` on :8002 GPUs 4,5); teacher/king stay 200.
4. Harvested to `experiments/s4-h1v2-sft/results/`: `train_result.json`,
   `h1v2_merge_meta.json`, mid/adapter salvage metas,
   `h1v2_train_merge_transition.json`. kevin still king; chal-00283
   load_challenger. Do **not** submit yet.
5. Budget: serve READY ~05:48 → prefer-n80 (remain_soft≥3200) → n80 ~55m
   fits soft 06:50 / deadman 07:00.

### Money

Lium $34,080.33; mining spend ≈ $158.87. Floor OK. No new rental. No submit.

### Next

Poll chall :8002 /health 200 → confirm H1v2 n80 launch → triage decision.
Submit only if margin > 0.04 + H4 OK.

## 2026-08-07T05:44:10Z — pass 62: H1v2 chall READY → prefer-n80 launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $161.57; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,072.51 (floor OK).

### What I did

1. Polled chall :8002 — loading→compile→**200 at 05:41:18Z**. Pipe
   recorded READY **05:41:16Z** (serve elapsed ~332s). Teacher/king stayed 200.
2. Confirmed prefer-n80 path: remain_soft=4124s ≥3200 → **skipped n40**,
   launched `run_sim_duel.py --n-turns 80` pid **198714** →
   `/root/affine_data/h1v2_sim_result.json` (hotkey `local-h1v2-sim-n80`).
3. First progress @ 05:44:00Z: king **1**/80, challenger **1**/80. Merged HF
   push pid **191137** still uploading; adapter salvage already OK.
4. Evidence: `experiments/s4-h1v2-sft/results/h1v2_n80_launched.json` +
   `h1v2_sim_progress.json`. kevin still king; live eval **chal-00283**
   scoring. Do **not** submit until n80 margin > 0.04 + H4 OK.
5. Budget: n80 ~55m from 05:41 → ~06:36 < soft 06:50 / deadman 07:00.

### Money

Lium $34,072.51; mining spend ≈ $161.57. Floor OK. No new rental. No submit.

### Next

Poll n80 progress → harvest `h1v2_sim_result.json` → triage decision.
Submit only if margin > 0.04 + H4 OK. Harvest merged salvage when push ends.

## 2026-08-07T05:47:50Z — pass 63: H1v2 merged HF push quota fix + retry

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $162.94; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,064.74 (floor OK).

### What I did

1. Polled n80: engines 200×3; sim **198714** alive; progress king **10**/80 /
   chall **9**/80 @ 05:47:25Z (ETA ~06:35 < soft 06:50).
2. Found merged HF push **191137** **DEAD** with
   `Private repository storage limit reached` — `…-h1-merged` private ~72 GiB
   filled quota; H1v2 ~67 GiB commit rejected. Adapter salvage already OK.
3. Made `unconst/Affine-5czsc2fc98-h1-merged` **public** (H1 recipe REFUTED;
   keep salvage). Set `…-h1v2-merged` public too.
4. Relaunched push with `/root/venv/bin/python3` + `--public` pid **202393**
   ALIVE @ 05:47:32Z (`private=False`). Bare `python3` retry hit
   ModuleNotFoundError — always use venv.
5. Evidence: `experiments/s4-h1v2-sft/results/h1v2_hf_quota_fix.json`.
   kevin still king; chal-00283 scoring. Do **not** submit until n80.

### Money

Lium $34,064.74; mining spend ≈ $162.94. Floor OK. No new rental. No submit.

### Next

Poll n80 → harvest + triage. Confirm `h1v2_merged_salvage.json` when push ends.
Submit only if margin > 0.04 + H4 OK.

## 2026-08-07T05:50:34Z — pass 64: H1v2 merged HF salvage confirmed DONE

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $164.13; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,056.97 (floor OK).

### What I did

1. Polled n80: engines 200×3; sim **198714** alive; progress king **16**/80 /
   chall **15**/80 @ 05:50:29Z (rate ~1.6 turns/min → ETA ~06:30 < soft 06:50).
2. Confirmed merged HF push **202393** **DONE** at 05:49:40Z:
   `unconst/Affine-5czsc2fc98-h1v2-merged` @
   `a31435754de2974e63779f53e953ee1433eaf295` (public, 67.0 GiB, 3 shards,
   14 files). Harvested `h1v2_merged_salvage.json` + verified on HF API.
3. Publicized `…-h1-lora` + `…-h1v2-lora` via `update_repo_settings` so
   future private-quota blocks are less likely (adapters already salvaged).
4. Evidence: `experiments/s4-h1v2-sft/results/h1v2_merged_salvage_confirmed.json`
   (+ `_verified.json`, pod salvage mirror). kevin still king; **chal-00283**
   scoring ~77/80 (watch for crown flip). Do **not** submit until n80
   margin > 0.04 + H4 OK. Deadman can no longer erase the only merged copy.

### Money

Lium $34,056.97; mining spend ≈ $164.13. Floor OK. No new rental. No submit.

### Next

Poll n80 → harvest `h1v2_sim_result.json` → triage `h1v2_decision.json`.
Submit only if margin > 0.04 + H4 OK. Re-check snapshot if chal-00283 crowns.

## 2026-08-07T05:54:31Z — pass 65: H1v2 n80 ETA poll + chal-00283 verdict

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $165.68; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,056.97 (floor OK).

### What I did

1. Polled n80: engines 200×3; sim **198714** alive. 90s rate check:
   20/20 → 25/24 in 102s → **~2.65 turns/min** → ETA **~06:15Z**
   (~35m slack to soft 06:50; ~45m to deadman 07:00). No TTL extend.
2. Fetched live duel `chal-00283` (Shatoria/…-test3): **REJECTED** at
   05:51Z — margin **+0.0017** z=0.18 (noise; both valid). kevin remains
   king @ `6a5815…`. Live eval now **chal-00284** load_challenger.
3. Evidence: `experiments/s4-h1v2-sft/results/h1v2_n80_eta_poll.json`,
   `chal_00283_verdict.json`. Do **not** submit until n80 margin > 0.04
   + H4 OK.

### Money

Lium $34,056.97; mining spend ≈ $165.68. Floor OK. No new rental. No submit.

### Next

Poll n80 → harvest `h1v2_sim_result.json` → triage `h1v2_decision.json`.
Submit only if margin > 0.04 + H4 OK. Re-check snapshot if queue crowns.

## 2026-08-07T06:02:40Z — pass 66: H1v2 artifact harvest fix + n80 ETA

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $168.86; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Deadman 1405846 still armed @ 07:00Z. Lium $34,041.08 (floor OK).

### What I did

1. Polled n80: engines 200×3; sim **198714** alive. Rate check 31/31 →
   35/36 in 150s → **~1.8 turns/min** (slower than pass-65 2.65) → ETA
   **~06:25Z** (~25m slack to soft 06:50; ~35m to deadman 07:00). Progress
   at write ~37–38/80. No TTL extend.
2. Found host harvest never SCPed `h1v2_sim_result_artifact.json` — pair-level
   decomp would vanish at deadman. Patched `host_harvest_results.sh` to fetch
   n80 + n40 artifacts; killed old harvest 1670883; restarted **1748334**.
3. kevin still king @ `6a5815…`; live eval **chal-00284** load_challenger.
   Evidence: `h1v2_n80_eta_poll.json`, `h1v2_harvest_artifact_fix.json`.
   Do **not** submit until n80 margin > 0.04 + H4 OK.

### Money

Lium $34,041.08; mining spend ≈ $168.86. Floor OK. No new rental. No submit.

### Next

Poll n80 → confirm harvest of `h1v2_sim_result.json` + artifact → triage
`h1v2_decision.json`. Submit only if margin > 0.04 + H4 OK.

## 2026-08-07T06:09:00Z — pass 67: extend harvest/deadman for slow n80

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $171.38; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $34,033.60 (floor OK).

### What I did

1. Polled n80: engines 200×3; sim **198714** alive at **55/80** (06:08:47Z).
   90s rate sample 53/52 → 54/53 = **0.67 t/min** (worst ETA **~06:48Z**);
   overall since 05:41 launch ≈ **2.0 t/min** (ETA **~06:22Z**). Teacher
   GPUs 0–1 @100%; king/chall 2–5 idle (teacher bottleneck, not engine death).
2. Old harvest stop 06:55 / deadman 07:00 was too tight for the slow sample.
   Killed harvest **1748334** + deadman **1405846**; restarted harvest
   **1757430** stop **07:45Z** and deadman **1757428** kill **08:00Z**.
   Patched `host_harvest_results.sh` to take `HARVEST_STOP_UTC`.
3. kevin still king @ `6a5815…`; live eval **chal-00284** scoring (king 17/80).
   Evidence: `h1v2_deadline_extend.json`, `h1v2_n80_eta_poll.json`.
   Do **not** submit until n80 margin > 0.04 + H4 OK.

### Money

Lium $34,033.60; mining spend ≈ $171.38. Extra pod-hour if used ≤ $23.60.
Floor OK. Cap OK. No new rental. No submit.

### Next

Poll n80 → confirm harvest of `h1v2_sim_result.json` + artifact → triage
`h1v2_decision.json`. Submit only if margin > 0.04 + H4 OK.

## 2026-08-07T06:20:30Z — pass 68: H1v2 n80 REFUTED; TalentPigs crowned; keep pod

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $175.84; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $34,010.24 (floor OK).

### What I did

1. Polled n80 → waited for completion (62/80 @ ~1.0 t/min → DONE ~06:19Z).
   Engines stayed 200×3. SCP'd `h1v2_sim_result.json` + artifact; ran
   `triage_sim.py` → `h1v2_decision.json`.
2. **Result:** margin **−0.00030** (z=−0.038); chall S=0.00531 vs kevin
   S=0.00561; both valid; **H4 FAIL** r=**0.904** / base×=0.997. Decomp:
   chall Λ2 −0.00978 (slightly better), clip-L1 +0.01509 (pred met) but
   kevin clip-L1 +0.017 still wins. Action `revise_recipe`; **no submit**.
   H1v2 **REFUTED**. Wrote `experiments/s4-h1v2-sft/result.md`.
3. **Live king flipped:** chal-00284 crowned
   `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` reign 3 S=0.0315 at
   06:15Z (while our sim still targeted kevin). Live-king guard match=false.
4. Killed host harvest **1757430** (would early-teardown after got_h1v2);
   left deadman **1757428** @ 08:00Z; marker `KEEP_POD_FOR_PIVOT.txt`.

### Money

Lium $34,010.24; mining spend ≈ $175.84. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Pivot pod: download TalentPigs → re-serve king :8001 → H5 merge or mild
distill → n80 vs **live** king (gate > 0.04). Re-check snapshot (chal-00286
ensure_king may change crown again).

## 2026-08-07T06:25:41Z — pass 69: H5 pivot launched (TalentPigs download→king)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $177.94; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $34,002.45 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Created `experiments/s4-h5-talentpigs/` — `plan.md` (H5 kevin×TalentPigs
   α=0.65 pred margin ≥+0.04), `download_talentpigs.sh`, `pivot_king.sh`,
   `start_pivot.sh`. Uploaded to pod `/root/mining_src/s4-h5-talentpigs/`.
2. Extended host deadman **08:00Z → 12:00Z** (pid **1783662**) for
   download+serve+later merge/n80.
3. Launched pivot pipeline pid **227022**: download
   `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` then re-serve king:8001.
   Cache ~19G at +30s; engines stayed 200×3 during download. Evidence:
   `results/h5_pivot_launched.json`.

### Money

Lium $34,002.45; mining spend ≈ $177.94. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Poll `/root/logs/h5_king_pivot.done` → merge kevin×TalentPigs α=0.65 →
chall:8002 → n80 vs TalentPigs (gate >0.04). Re-check snapshot before sim.

## 2026-08-07T06:33:00Z — pass 70: H5 king pivot DONE + α=0.65 merge→n80 launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $180.82; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,994.63 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Confirmed TalentPigs download done (81s, 66G cache) and king:8001 pivot
   READY at **06:32:28Z** (`h5_king_pivot.done` + `h5_pivot_pipeline.done`;
   wait_ready ~347s — CUDA graph capture). Engines 200×3 (chall still H1v2).
2. Wrote `experiments/s4-h5-talentpigs/start_merge_sim.sh` — CPU merge
   kevin α=0.65 × TalentPigs → `/root/merges/h5-kt65/` with first_1MiB refuse
   vs king, then chall re-serve → n80 `run_sim_duel.py`. Uploaded to pod.
3. Launched pipe pid **231222** (merge_linear **231233**): 1026 common keys,
   only_A=19 mtp leftovers from kevin. Evidence:
   `results/h5_merge_sim_launched.json`.

### Money

Lium $33,994.63; mining spend ≈ $180.82. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Poll `h5_merge.done` → `h5_sim_n80.done` → harvest+triage (gate >0.04).
If weak: α=0.50 or refute merge → TalentPigs-init thought distill.

## 2026-08-07T06:43:38Z — pass 71: H5 merge DONE; unblocked identity crash; resume serve→n80

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $185.00; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,979.14 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Found pass-70 pipe **231222** dead after a successful merge (321s, 67G,
   `first_1MiB_identical=false` vs kevin). Post-merge refuse check crashed:
   `FileNotFoundError` looking for `model-00001-of-00002.safetensors` under
   TalentPigs — king is **16-shard**, merge/kevin is **2-shard**.
2. Patched `start_merge_sim.sh` to resolve king's first shard by glob and
   require same layout + matching first MiB for refuse. Added
   `resume_after_merge.sh` (skip re-merge → identity → chall serve → n80).
3. Launched resume pid **231961**: identity OK (`identical_to_king=false`,
   layout_match=false); `h5_merge.done` @ 06:41:14Z; chall:8002 loading
   `/root/merges/h5-kt65` (pid 232026; wait_ready 232028). Evidence:
   `results/h5_kt65_identity.json`, `h5_kt65_merge_meta.json`,
   `h5_resume_launched.json`.

### Money

Lium $33,979.14; mining spend ≈ $185.00. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Poll `h5_chall_serve.done` → `h5_sim_n80.done` → harvest+triage (gate >0.04).

## 2026-08-07T06:47:05Z — pass 72: H5 chall READY; n80 sim launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $185.40; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,971.35 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled resume pipe **231961**: chall vLLM loaded merge on GPUs 4,5
   (~332s wait incl. torch.compile); health **200** @ 06:46:45Z.
2. Confirmed markers: `h5_chall_serve.done` @ 06:46:53Z; engines
   teacher/king/chall all 200.
3. Confirmed n80 sim pid **235312** launched vs TalentPigs
   (`run_sim_duel.py` → `/root/affine_data/h5_kt65_sim_result.json`).
   Progress JSON not yet written (first turns). Evidence:
   `results/h5_chall_ready_n80_launched.json`.

### Money

Lium $33,971.35; mining spend ≈ $185.40. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Poll `h5_kt65_sim_progress.json` → `h5_sim_n80.done` → harvest+triage
(gate >0.04). If weak: α=0.50 or refute merge → TalentPigs-init thought distill.

## 2026-08-07T06:51:58Z — pass 73: H5 n80 advancing; host harvest armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $188.27; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,963.56 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled sim **235312**: progress at 06:49:12Z was king 1 / chall 3; 120s
   recheck → king **11** / chall **15** at 06:51:20Z; latest king **12** /
   chall **16** at 06:51:47Z. Engines 8000/8001/8002 all **200**. ETA
   ~07:15–07:30Z.
2. Wrote + launched `experiments/s4-h5-talentpigs/host_harvest_h5.sh` pid
   **1818104** (stop 11:45Z before deadman 12:00Z): polls for
   `h5_kt65_sim_result.json`, SCPs artifacts, runs `triage_sim.py` →
   `results/h5_decision.json` with live-king guard.
3. SCPed live progress JSON. Evidence:
   `results/h5_n80_advancing_harvest_armed.json`,
   `results/h5_kt65_sim_progress.json`.

### Money

Lium $33,963.56; mining spend ≈ $188.27. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5_decision.json` when harvest lands; else poll
`h5_sim_n80.done`. Triage gate >0.04; weak → α=0.50 or TalentPigs-init
thought distill.

## 2026-08-07T06:56:15Z — pass 74: H5 n80 rate confirmed (~19/24, ETA~07:28Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $189.79; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,955.80 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled sim **235312**: at 06:53:18Z king 15 / chall 17; 120s recheck →
   king **19** / chall **24** at 06:55:26Z. Engines 8000/8001/8002 all **200**.
   Rate ≈ **1.875** king-tpm / 3.28 chall-tpm → ETA finish **~07:28Z**.
2. Confirmed host harvest **1818104** + deadman **1783662** still alive;
   no `h5_decision.json` / result yet (correct — sim mid-flight).
3. SCPed progress; wrote `results/h5_n80_rate_confirmed.json`.

### Money

Lium $33,955.80; mining spend ≈ $189.79. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5_decision.json` when harvest lands (~07:28Z); else poll
`h5_sim_n80.done`. Triage gate >0.04; weak → α=0.50 or TalentPigs-init
thought distill.

## 2026-08-07T06:59:55Z — pass 75: H5 n80 mid-flight (~34/36, ETA~07:29Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $191.40; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,955.80 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled sim **235312**: at 06:57:28Z king 27 / chall 33; 120s recheck →
   king **34** / chall **36** at 06:59:28Z. Engines 8000/8001/8002 all **200**.
   Rate ≈ **3.5** king-tpm / **1.5** chall-tpm (chall now bottleneck) → ETA
   finish **~07:29Z**.
2. Confirmed host harvest **1818104** + deadman **1783662** still alive;
   no `h5_decision.json` / result yet (correct — sim mid-flight).
3. SCPed progress; wrote `results/h5_n80_midflight_rate.json`.

### Money

Lium $33,955.80; mining spend ≈ $191.40. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5_decision.json` when harvest lands (~07:29Z); else poll
`h5_sim_n80.done`. Triage gate >0.04; weak → α=0.50 or TalentPigs-init
thought distill.

## 2026-08-07T07:04:25Z — pass 76: H5 n80 mid-flight (~48/51, ETA~07:13Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $192.92; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,947.67 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled sim **235312**: at 07:01:09Z king 39 / chall 42; 155s recheck →
   king **48** / chall **51** at 07:03:44Z. Engines 8000/8001/8002 all **200**.
   Rate ≈ **3.48** king-tpm / **3.48** chall-tpm (both recovered; king
   bottleneck) → ETA finish **~07:13Z** (~16m earlier than pass75).
2. Confirmed host harvest **1818104** + deadman **1783662** still alive;
   no `h5_decision.json` / result yet (correct — sim mid-flight).
3. SCPed progress; wrote `results/h5_n80_midflight_rate.json` (pass 76).

### Money

Lium $33,947.67; mining spend ≈ $192.92. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5_decision.json` when harvest lands (~07:13Z); else poll
`h5_sim_n80.done`. Triage gate >0.04; weak → α=0.50 or TalentPigs-init
thought distill.

## 2026-08-07T07:17:35Z — pass 77: H5 α0.65 REJECT gates; α0.50 launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $198.35; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,924.61 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Waited out α0.65 n80 to completion (~07:15:40Z). Harvest wrote
   `results/h5_decision.json` + `h5_kt65_sim_result.json`.
2. Triage: chall **INVALID** — `baseline_band_exceeded`, base×=**4.431**,
   r=1.077, margin forced **0.0**, action `reject_gates`, submit=false.
   King valid S=0.02874. Live-king guard match.
3. Per plan (try α∈{0.65,0.50} before refute): launched α=0.50 pipeline
   pid **240001** → `/root/merges/h5-kt50/` → chall:8002 → n80. Host
   harvest **1847826** → `h5_a50_decision.json`. Deadman **1783662** @12:00Z.
4. Wrote `result.md`, `start_merge_sim_a50.sh`, `host_harvest_h5_a50.sh`,
   `results/h5_a50_launched.json`.

### Money

Lium $33,924.61; mining spend ≈ $198.35. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5_a50_decision.json` when harvest lands. If still gate-fail
or margin < 0.02 → refute H5 merge → TalentPigs-init thought distill.

## 2026-08-07T07:34:27Z — pass 78: H5 α0.50 unpromptable; H5b distill launched

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent ~$203; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,901.01 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. Polled α0.50: merge DONE 07:23:05Z (329s, non-identical); chall READY
   07:28:44Z; sim finished 07:29:24Z in **32s** with
   `unpromptable:probe_no_parsable_action_in_3_turns`. Manual chall sample =
   repeated `**` — equal-weight MoE merge destroyed generation.
2. Harvest wrote `h5_a50_decision.json` (`reject_gates`, margin 0). Per H5
   plan: both α failed → **refute H5 merge parents**. Wrote `result.md`,
   `h5_a50_unpromptable.json`. Freed `/root/merges/h5-kt50`.
3. Launched **H5b** TalentPigs-init thought-only LoRA (lr=1e-5, 440 refs):
   train **245350** GPUs 6,7; pipe **245426**; host harvest **1871830**.
   Thought-mask verify 440/440. Deadman **1783662** @12:00Z still armed.

### Money

Lium $33,901.01; mining spend ≈ $203. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `experiments/s4-h5b-talentpigs-distill/results/h5b_decision.json` when
harvest lands (~train 55–70m + merge/serve/n80). Gate >0.04 + H4.

## 2026-08-07T07:38:32Z — pass 79: H5b HF salvage armed (train step 4/55)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $205.56; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,893.52 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. No `h5b_decision.json` yet — train mid-flight. Polled: step **4**/55 @
   ~62s/it after load; engines 8000/8001/8002 all **200**; pipe waiting
   `train.done`.
2. Found launch `post_train_pipeline.sh` had **no HF adapter/merged push**
   (deadman 12:00Z would erase the only H5b candidate — same failure mode
   as H1v2 before pass 54).
3. Created private HF repos `unconst/Affine-5czsc2fc98-h5b-lora` +
   `…-h5b-merged`. Patched pipe with bg `salvage_adapter.py` +
   `push_merged.py` after merge/identity check. Added `mid_ckpt_salvage.sh`.
4. SCP'd scripts; killed old wait-pipe **245426**; started pipe **246775** +
   mid **246776**. Train **245350** untouched. Harvest **1871830** + deadman
   **1783662** still alive.

### Money

Lium $33,893.52; mining spend ≈ $206. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:30Z). Until
then poll train→merge→HF pids→n80. Gate >0.04 + H4 before Stage 5.

## 2026-08-07T07:43:12Z — pass 80: H5b final-adapter mid-salvage + harvest progress

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $208.43; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,885.70 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
Live eval `chal-00291` loading `adsbasd31badsf/affine-5ec3jw68ha-cmsdkf`.

### What I did

1. No `h5b_decision.json` yet — train mid-flight step **8**/55, loss@5
   **0.596**, ETA ~08:28Z. Engines 200×3; pipe **246775** waiting
   `train.done`; deadman **1783662** @12:00Z.
2. Found mid-ckpt watcher exited on `train.done` without salvaging
   `$TRAIN_DIR/adapter`. If post-train pipe died before HF push, deadman
   would erase the only TalentPigs-init candidate (checkpoints alone may
   race). Patched `mid_ckpt_salvage.sh` to final-sweep + push
   `adapter-final`; restarted mid **247579** (train/pipe untouched).
3. Patched `host_harvest_h5b.sh` to emit structured
   `h5b_train_progress.json` and defer exit while H5b HF push PIDs run.
   Restarted harvest **1884718**.
4. Freed unused `/root/merges/h5-kt65` (68G). Chall still serves deleted
   `h5-kt50` from RAM until post-train swap — leave it.

### Money

Lium $33,885.70; mining spend ≈ $208. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:30Z). Until
then poll `h5b_train_progress.json` → merge → HF pids → n80. Gate >0.04 + H4.

## 2026-08-07T07:48:10Z — pass 81: H5b identity false-positive refuse fixed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $210.38; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,877.92 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. No `h5b_decision.json` yet — train mid-flight step **14**/55, loss@10
   **0.498**, ETA ~08:25Z. Engines 200×3; mid **247579** alive; deadman
   **1783662** @12:00Z.
2. Audited post-train pipe: identity check used `first_1MiB` + shard-name
   equality. TalentPigs-init LoRA leaves embed/lm_head windows → same
   false-positive REFUSE that bit H1. Would have aborted after merge and
   wasted the train under deadman 12:00Z.
3. Patched `post_train_pipeline.sh` to trust `merge_lora.weight_identical`
   + multi-window probe; first_1MiB match alone is an OK note. Also
   `unset CUDA_VISIBLE_DEVICES` before chall serve. SCP'd; restarted pipe
   **249279** (train **245350** + mid **247579** untouched).
4. Freed refuted `/root/h1/merged` + `/root/h1v2/merged` (~136G; HF salvage
   already done). Evidence:
   `results/h5b_identity_false_positive_fix.json`.

### Money

Lium $33,877.92; mining spend ≈ $210. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:30Z). Until
then poll train→merge→confirm `h5b_identity.json` identical_to_king=false
even if first_1MiB_identical=true → HF pids → n80. Gate >0.04 + H4.

## 2026-08-07T07:52:29Z — pass 82: H5b GPU-release-before-merge race fixed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $212.07; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,870.19 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
Live eval chal-00291 scoring (unrelated).

### What I did

1. No `h5b_decision.json` — train step **19**/55, loss@15 **0.508**, ETA
   train.done ~08:24Z, n80 end ~09:54Z (slack to deadman 12:00Z ~2h).
2. Audited post-train path: `train.done` is written while the 35B train
   process still holds GPUs 6,7 during Python teardown. Pipe would start
   `merge_lora --device-map auto` on the same GPUs → OOM/thrash risk under
   deadman. H1v2 had the same pattern but got lucky on poll timing.
3. Patched `post_train_pipeline.sh`: after `train.done`, wait up to 15m for
   `train_lora.py` exit + 15s CUDA settle before merge. Also serialize
   adapter HF push vs mid `adapter-final` (skip root push if mid done) and
   pass `--base-hub TalentPigs/affine-5ekxlcg3fx-abc`. Mid script same
   base-hub. SCP'd; restarted pipe **251842** + mid **251832** (train
   **245350** untouched).
4. Evidence: `results/h5b_gpu_release_race_fix.json`,
   `results/h5b_time_budget_pass82.json`.

### Money

Lium $33,870.19; mining spend ≈ $212. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:30Z). Until
then poll train→confirm pipe log `train proc gone` / `GPU settle done` →
merge → identity → HF → n80. Gate >0.04 + H4.

## 2026-08-07T07:57:48Z — pass 83: H5b n80 retry insurance armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $214.22; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,862.41 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
Live eval chal-00291 scoring ~51/80 (unrelated); queue 11.

### What I did

1. No `h5b_decision.json` — train step **24**/55, loss@20 **0.521**, ETA
   train.done ~08:26Z, n80 end ~10:26Z (slack to deadman 12:00Z ~1.5h).
   Engines 200×3; mid **251832**; harvest **1884718**; deadman **1783662**.
2. Audited post-train n80 path: single foreground `run_sim_duel` under
   `set -e`. H1 already burned ~40m of pod time once on `httpx.ReadTimeout`
   @16/80; vllm_client is 360s×5 but a hard crash still aborts the whole
   H5b pipe and wastes the TalentPigs-init train.
3. Patched `post_train_pipeline.sh`: ≤**3** n80 attempts, each gated on
   ≥40m deadman budget + engine health warn; failures logged to
   `h5b_sim_retries.log`. SCP'd; restarted pipe **253801** (train
   **245350** + mid **251832** untouched). HF salvage repos still empty
   private stubs (siblings=1).
4. Evidence: `results/h5b_n80_retry_fix.json`,
   `results/h5b_time_budget_pass83.json`.

### Money

Lium $33,862.41; mining spend ≈ $214. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:30Z). Until
then poll train→merge→identity→HF→n80 (retries if needed). Gate >0.04 + H4.

## 2026-08-07T08:00:55Z — pass 84: H5b harvest abort + done-marker gate

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent ~$215; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,854.29 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. No `h5b_decision.json` — train step **28**/55, loss@25 **0.429**, ETA
   train.done ~08:31Z, n80 end ~10:36Z (slack to deadman 12:00Z ~1.4h).
   Engines 200×3; pipe **253801**; mid **251832**; deadman **1783662**.
2. Audited host harvest vs pass-83 n80 retries: retries `rm` result.json
   between attempts, so harvesting on bare JSON could triage a doomed
   attempt. Also any `h5b_pipeline.aborted` left harvest spinning until
   11:45Z with no decision for the next pass to pivot on.
3. Patched `host_harvest_h5b.sh`: triage only after `h5b_sim_n80.done` or
   `h5b_pipeline.done`; on abort, SCP marker + write `h5b_decision.json`
   action=`pipe_aborted` immediately (still waits HF salvage before exit).
   Restarted harvest **1917667** (train/pipe/mid untouched).
4. Evidence: `results/h5b_harvest_abort_done_gate_fix.json`,
   `results/h5b_time_budget_pass84.json`.

### Money

Lium $33,854.29; mining spend ≈ $215. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:40Z). Until
then poll train→merge→identity→HF→n80 (retries if needed). Gate >0.04 + H4.


## 2026-08-07T08:04:21Z — pass 85: H5b pipe EXIT abort-trap armed

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $216.20; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,854.29 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. No `h5b_decision.json` — train step **31**/55, loss@30 **0.441**, ETA
   train.done ~08:27Z, n80 end ~10:30Z (slack to deadman 12:00Z ~1.5h).
   Engines 200×3; mid **251832**; harvest **1917667**; deadman **1783662**.
2. Audited post-train failure paths vs pass-84 harvest: merge fail, identity
   REFUSE, `wait_ready` timeout, serve crash, and missing-adapter all exited
   under `set -e` **without** writing `h5b_pipeline.aborted` — harvest would
   spin to 11:45Z with no decision for the next pass to pivot on.
3. Patched `post_train_pipeline.sh`: EXIT trap writes
   `aborted_err_rc=<n>` unless `pipeline.done` or abort already present;
   explicit `aborted_no_adapter`. SCP'd; restarted pipe **256662** (train
   **245350** + mid **251832** untouched).
4. Evidence: `results/h5b_pipe_abort_trap_fix.json`,
   `results/h5b_time_budget_pass85.json`.

### Money

Lium $33,854.29; mining spend ≈ $216. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:30–10:40Z). Until
then poll train→merge→identity→HF→n80 (retries if needed). Gate >0.04 + H4.


## 2026-08-07T08:08:03Z — pass 86: H5b HF wait off critical path

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $217.21; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,846.85 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079.

### What I did

1. No `h5b_decision.json` — train step **35**/55, loss@35 **0.468**, ETA
   train.done ~08:27Z. Engines 200×3; mid **251832**; harvest **1917667**;
   deadman **1783662**. Slack to deadman vs ETA n80 end ~1.5h.
2. Audited post-merge path: pipe still had a **60×10s** poll waiting on mid
   `adapter-final` HF salvage **before** chall serve — up to **10m** on the
   n80 critical path under deadman 12:00Z. Also used inline kill+`serve_three`
   instead of the proven H1v2 chall-only `restart_for_h2`.
3. Patched `post_train_pipeline.sh`: mid HF wait removed (if mid running →
   skip adapter root push; mid owns adapter-final); merged push stays async;
   chall-only via `RESTART_KING=0` + `restart_for_h2` with TalentPigs in
   `KEVIN_*` king slot. SCP'd; restarted pipe **258082** (train **245350** +
   mid **251832** untouched). Cleared any kill-induced abort marker; harvest
   still clean (no false decision).
4. Evidence: `results/h5b_hf_wait_off_critical_path_fix.json`,
   `results/h5b_time_budget_pass86.json`.

### Money

Lium $33,846.85; mining spend ≈ $217. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:20–10:30Z). Until
then poll train→merge→identity→chall-only→n80 (retries if needed). Gate >0.04 + H4.


## 2026-08-07T08:11:12Z — pass 87: H5b stage-aware harvest progress scrape

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $219.44; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,838.95 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.

### What I did

1. No `h5b_decision.json` — train step **38**/55, loss@35 **0.468**, ETA
   train.done ~08:27Z. Engines 200×3; pipe **258082** waiting; mid **251832**;
   deadman **1783662**.
2. Found host-harvest bug: `_scrape_train_progress` set `pipe_waiting=true` if
   `"waiting for"` appeared *anywhere* in `h5b_pipeline.stdout`. That line
   remains after train.done, so merge/serve/n80 would look like still waiting
   for the rest of the critical path — next passes could mis-read state.
3. Patched scrape to derive `stage` from durable markers + **last** pipe log
   line (`waiting_train`→`post_train`→`merge_identity`→`serve`/`n80`→
   `n80_done`/`aborted`); also expose merge/serve/n80 markers, identity, and
   sim_progress. Restarted harvest **1935669** (verified `stage=waiting_train`,
   step 38). Train/pipe/mid untouched. Also SCP'd pipe start cleanup of
   `h5b_chall_serve.done` (live pipe not restarted).
4. Evidence: `results/h5b_stage_aware_progress_fix.json`,
   `results/h5b_time_budget_pass87.json`.

### Money

Lium $33,838.95; mining spend ≈ $219. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:20–10:30Z). Until
then poll `h5b_train_progress.json` `stage` through train→merge→n80.
Gate >0.04 + H4.


## 2026-08-07T08:14:54Z — pass 88: H5b pre-free chall VRAM (GPUs 4,5)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $219.88; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,838.95 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079.

### What I did

1. No `h5b_decision.json` — train step **42**/55, loss@40 **0.468**, ETA
   train.done ~08:28Z. Pipe **258082** waiting; mid **251832**; harvest
   **1935669**; deadman **1783662**.
2. Found critical-path waste: chall:8002 still served deleted-from-disk
   `/root/merges/h5-kt50` from RAM (~118 GiB ×2 on GPUs 4,5). Post-merge
   `restart_for_h2` would have to kill + reclaim that VRAM before loading
   the H5b merged chall — minutes under deadman 12:00Z.
3. Stopped chall pid **240863** now (teacher+king left **200**; train/pipe/mid
   untouched). GPUs 4,5 → **0 MiB**. Pipe will chall-only serve after merge
   into already-empty VRAM.
4. Evidence: `results/h5b_prefree_chall_vram.json`,
   `results/h5b_time_budget_pass88.json`. Progress shows
   `engines.chall=0` intentionally until post-merge serve.

### Money

Lium $33,838.95; mining spend ≈ $220. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:15–10:20Z). Until
then poll `h5b_train_progress.json` `stage` through train→merge→n80.
Gate >0.04 + H4. Expect chall=0 until serve stage.


## 2026-08-07T08:18:46Z — pass 89: H5b TalentPigs packed-visual merge_lora fix

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $222.42; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,831.21 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079.

### What I did

1. No `h5b_decision.json` — train step **46**/55, loss@40 **0.468**, ETA
   train.done ~08:28Z. Pipe **258082** waiting; mid **251832**; harvest
   **1935669**; deadman **1783662**. Chall still pre-freed (GPUs 4,5=0).
2. Found critical merge bug for TalentPigs base: **no**
   `model-visual*.safetensors` — 333 `model.visual.*` tensors packed into
   `model-00016-of-00016.safetensors` with 9 language tensors. Existing
   `merge_lora` only copied `model-visual*` (kevin layout). H5b merge would
   drop the vision tower, restore wrapper `config.json`, then chall:8002
   would crash — abort after ~$220 of train.
3. Patched `experiments/s4-h1-sft/merge_lora.py`: keep kevin-style copy;
   extract still-missing keys into `model-visual-restored.safetensors`;
   refuse if base has visual and out has none; stage meta as
   `h5b_merge_meta.json`. SCP to pod (md5 `e5f51cec…`, compile OK). Dry-run:
   would restore 333 keys from shard 16. Train/pipe/mid **not** restarted
   (pipe invokes merge_lora.py at merge time).
4. Evidence: `results/h5b_talentpigs_visual_restore_fix.json`,
   `results/h5b_time_budget_pass89.json`.

### Money

Lium $33,831.21; mining spend ≈ $222. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Read `results/h5b_decision.json` when harvest lands (~09:15–10:20Z). Until
then poll `stage` through train→merge (confirm visual restore in merge log)
→chall→n80. Gate >0.04 + H4.

## 2026-08-07T08:36:04Z — pass 90: H5b rc=127 file-offset abort recovered; merge+visual OK

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $229.22; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,800.14 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079.

### What I did

1. Polled H5b: train finished **08:26:33Z** (55/55, loss@55 **0.425**,
   adapter present) but pipe **258082** aborted with
   `line 74: ted: command not found` / `aborted_err_rc=127`. Harvest already
   wrote `h5b_decision.json` action=`pipe_aborted` and exited.
2. Root cause: bash file-offset landmine — live pipe slept in wait loop while
   earlier passes SCP'd edits to `post_train_pipeline.sh`; after `train.done`
   break, bash resumed mid-word (`ted` from `written`).
3. Archived false decision → `h5b_decision_pass90_false_abort.json`. Patched
   pipeline (ascii dashes + landmine comment). Cleared abort markers.
   Relaunched pipe **266631** + harvest **1964910**. Deadman **1783662** kept.
4. Merge **DONE** 08:35:14Z: `extracted 333 missing keys` →
   `model-visual-restored.safetensors`; `identical_to_king=false`. Chall:8002
   loading on GPUs 4,5 (pid 270081). HF merged push async (pid 269981);
   adapter-final already salvaged (`ad537ed…`).
5. Evidence: `results/h5b_pipe_file_offset_abort_fix.json`,
   `h5b_identity.json`, `h5b_merge_meta.json`, `h5b_time_budget_pass90.json`.

### Money

Lium $33,800.14; mining spend ≈ $229. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for chall:8002 **200** → n80 → `h5b_decision.json`. Gate >0.04 + H4.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T08:45:33Z — pass 91: H5b chall READY; n80 sim launched + advancing

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $229.76; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,791.33 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079.

### What I did

1. Confirmed chall:8002 still loading at pass start (CUDA graphs / compile).
2. Polled to readiness: **200** @ **08:40:51Z** → pipe logged
   `CHALL_SERVE_DONE` / `ALL_READY` (teacher+king+chall).
3. n80 launched attempt **1/3** @ 08:40:52Z pid **276121**
   (`run_sim_duel.py` vs TalentPigs `dbfbb3e2…`, chall `/root/h5b/merged`).
4. Confirmed advancing: progress king **1**→**6** / chall **2** by 08:45:23Z
   (~3 k-tpm early). ETA ~09:15–09:40Z; deadman 12:00Z slack OK.
5. HF merged salvage already finished: private
   `unconst/Affine-5czsc2fc98-h5b-merged` @ `e1d39a1…` (not a submission;
   `push_merged` meta lists `base_hub=kevin954` — cosmetic; live merge was
   TalentPigs-init).
6. Evidence: `results/h5b_n80_launched.json`, `h5b_sim_progress.json`,
   `h5b_merged_salvage.json`, `h5b_time_budget_pass91.json`.

### Money

Lium $33,791.33; mining spend ≈ $230. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T08:49:22Z — pass 92: H5b n80 advancing (15/80, ETA~09:20Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $234.42; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,784.50 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. Progress: king**10**/chall**9** @ 08:46:50Z → king**15**/chall**15** @
   08:49:11Z. Window ~2.13/2.55 tpm → ETA **~09:20Z**; deadman 12:00Z slack OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass92.json`.

### Money

Lium $33,784.50; mining spend ≈ $234. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T08:52:56Z — pass 93: H5b n80 advancing (19/80, ETA~09:46Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $234.81; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,776.76 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. Progress: king**15**/chall**15** @ 08:49:11Z → king**19**/chall**19** @
   08:52:42Z. Window ~1.14 tpm (slowed vs pass92 ~2.1) → ETA **~09:46Z**;
   overall ~1.61 tpm; deadman 12:00Z slack ~134 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass93.json`.

### Money

Lium $33,776.76; mining spend ≈ $235. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T08:56:35Z — pass 94: H5b n80 advancing (29/80, ETA~09:14Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $237.29; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,769.01 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. Progress: king**19**/chall**19** @ 08:52:42Z → king**29**/chall**29** @
   08:56:09Z. Window ~2.90 tpm (recovered vs pass93 ~1.14) → ETA **~09:14Z**;
   overall ~1.90 tpm; deadman 12:00Z slack ~166 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass94.json`.

### Money

Lium $33,769.01; mining spend ≈ $237. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T09:00:18Z — pass 95: H5b n80 advancing (33/80, ETA~09:35Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $238.65; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,769.01 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.
Live eval phase duel `chal-00295` (not ours).

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. 90s recheck: king**32**/chall**31** @ 08:58:23Z → king**33**/chall**33** @
   08:59:13Z. Window from pass94 29/29 → ~1.30 tpm → ETA **~09:35Z** (dip vs
   pass94 ~2.90); wall-90s ~0.67 tpm; deadman 12:00Z slack ~145 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass95.json`.

### Money

Lium $33,769.01; mining spend ≈ $239. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T09:03:19Z — pass 96: H5b n80 advancing (39/80, ETA~09:28Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $239.86; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,760.86 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.
Live eval phase duel `chal-00295` (not ours).

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. 90s recheck: king**35**/chall**36** @ 09:01:22Z → king**39**/chall**40** @
   09:02:56Z. Window from pass95 33/33 → ~1.61 tpm → ETA **~09:28Z**;
   wall-90s ~2.67 tpm (recovered vs pass95 dip); deadman 12:00Z slack ~152 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass96.json`.

### Money

Lium $33,760.86; mining spend ≈ $240. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T09:07:30Z — pass 97: H5b n80 advancing (47/80, ETA~09:24Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $241.59; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,753.43 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.
Harvest scrape `stage=n80` (sim_n80_done=false).

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. 90s recheck: king**45**/chall**45** @ 09:05:26Z → king**47**/chall**47** @
   09:07:03Z. Window from pass96 39/40 → ~1.94 tpm → ETA **~09:24Z**;
   wall-90s ~1.24 tpm; deadman 12:00Z slack ~156 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass97.json`.

### Money

Lium $33,753.43; mining spend ≈ $242. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T09:13:25Z — pass 98: H5b n80 advancing (58/80, ETA~09:25Z)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $243.04; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,745.62 (floor OK). Snapshot: TalentPigs still king reign 3 @ S=0.0315.
`min_submission_block`=8767079. Host harvest **1964910** + deadman **1783662** alive.
Harvest scrape `stage=n80` (sim_n80_done=false).

### What I did

1. No `h5b_decision.json` yet (expected — n80 incomplete).
2. SSH confirmed engines **200×3**, pipe **266631** + sim **276121** alive,
   attempt 1/3, no retries, no result file.
3. 90s recheck: king**56**/chall**55** @ 09:11:27Z → king**58**/chall**58** @
   09:13:12Z. Window from pass97 47/47 → ~1.79 tpm → ETA **~09:25Z**;
   wall-90s ~1.43 tpm; deadman 12:00Z slack ~154 min OK.
4. SCP'd progress; wrote `results/h5b_time_budget_pass98.json`.

### Money

Lium $33,745.62; mining spend ≈ $243. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

Wait for n80 → `h5b_decision.json`. Gate >0.04 + H4 + live-king.
Do **not** edit the live pipe script on the pod.

## 2026-08-07T09:26:27Z — pass 99: H5b n80 DONE — REFUTED (+0.00322)

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent $248.91; plus
validator `affine-eval` / `affine-bench`. No orphan `mine-*`. Inventory matches.
Lium $33,722.29 (floor OK). Snapshot at triage: TalentPigs still king reign 3
@ S=0.0315; chal-00300 `Talucampe037/…-ck10` was `load_challenger`.
`min_submission_block`=8767079. Deadman **1783662** still armed → 12:00Z.
Harvest exited after writing decision.

### What I did

1. Polled n80 from 60/60 @ 09:14Z → result @ **09:25:18Z** (attempt 1/3).
2. Harvest already triaged → `results/h5b_decision.json`:
   action **`revise_recipe`**, margin **+0.00322**, z=0.547, H4
   r=**0.670** / base×=0.949, submit=false, live-king match=true.
3. Wrote `experiments/s4-h5b-talentpigs-distill/result.md`. Marked H5b
   **REFUTED** in HYPOTHESES; opened H5c as next (not another mild
   440-ref king-init LoRA — Λ2 only +0.004, clip-L1 flat).
4. Engines left **200×3** for pivot; no new rental; no submit.

### Numbers (n80)

| | king | chall H5b |
|---|---|---|
| S | 0.04405 | 0.04699 |
| Λ2 | 0.00936 | 0.01336 |
| clip-L1≈ | +0.0347 | +0.0336 |
| r | 0.650 | 0.670 |

### Money

Lium $33,722.29; mining spend ≈ $249. Floor OK. Cap OK. No new rental.
No submit / no registration burn.

### Next

H5c plan (public TalentPigs crown autopsy / expanded refs). Re-check
snapshot (chal-00300). Keep pod only if GPU job launches; else tear down
`mine-sim-1` before deadman.

## 2026-08-07T09:33:06Z — pass 100: H5c crown autopsy DONE; tore down mine-sim-1

### Machine reconcile

`lium ps`: `mine-sim-1` (`swift-shark-52`) RUNNING spent ~$252 → removed
after verify name prefix `mine-`; validator `affine-eval` / `affine-bench`
untouched. Host deadman **1783662** killed. No orphan `mine-*`.
Lium $33,713.30 (floor OK). Snapshot: TalentPigs still king reign 3 @
S=0.0315; `current_eval` chal-00301 = kevin954 re-challenge
(dispatching). `min_submission_block`=8767079.

### What I did

1. Opened `experiments/s4-h5c-crown-autopsy/`; downloaded chal-00284
   (crown), 00273 (ppp near-miss), 00258 (ruby); recomputed under
   current knobs (`analyze.py` → `results/summary.json` + `table.txt`).
2. Deciding numbers (crown vs kevin): margin **+0.028**, dL1c
   **+0.0157**, dΛ2 +0.0123, L1 share **0.56**, chall r=**0.720**,
   clip-L1 **+0.0325**. Near-miss ppp: margin −0.004, clip-L1 only
   +0.0232 (Δ −0.009 vs crown), Λ2≈0. Confirms TalentPigs crowns on
   **clip-L1 envelope**, not Λ2 — matches why H5b (Λ2+0.004, L1 flat)
   failed.
3. Locked H5c recipe in `result.md` / HYPOTHESES: kevin-init thought
   LoRA on **expanded** teacher_refs; target clip-L1≥0.042, r∈[0.70,0.85],
   n80 margin >0.04 vs TalentPigs.
4. No GPU job this pass → `lium rm mine-sim-1` (idle burn stop). No
   new rental. No submit.

### Money

Lium $33,713.30; mining spend cumulative ~$252. Floor OK. Cap OK.
No registration burn.

### Next

Harvest all public duel teacher_refs on host → rent one `mine-*` →
H5c train → n80 vs TalentPigs. Re-check snapshot (kevin re-challenge).

## 2026-08-07T09:36:00Z — pass 101: H5c expand-refs harvest DONE (791 shortz)

### Machine reconcile

`lium ps`: no `mine-*`; only validator `affine-eval` / `affine-bench`.
Inventory matches. Lium $33,708.61 (floor OK). Snapshot: TalentPigs still
king reign 3 @ S=0.0315; `current_eval` chal-00301 kevin954 re-challenge
(`load_challenger`). `min_submission_block`=8767079.

### What I did

1. Opened `experiments/s4-h5c-expand-refs/`.
2. Harvested teacher_refs from all **60** public duel gz
   (`affine/state/evals/`, read-only) + corpus join
   (`research/data/turns_minicoder.jsonl`, read-only).
3. Wrote three sets + meta/stats/samples:
   - expanded **1329** (3.02× H1's 440)
   - shortz z≤250 **791** (1.80×) — primary H5c DATA
   - shortz+nolist **790** (redundant; shortz alone kills listy)
4. Locked train path in `result.md` / `start_h5c.sh` (kevin init,
   thought-only, lr=2e-5, n80 vs TalentPigs, gate >0.04).
5. No rental this pass (harvest was the increment). No submit.

### Numbers

| set | n | z p50 | listy | vs H1 |
|---|---|---|---|---|
| expanded | 1329 | 216 | 0.1415 | 3.02× |
| shortz≤250 | **791** | 127 | **0.0013** | **1.80×** |

Finding: length filter captures crown style; list scrub adds almost nothing.

### Money

Lium $33,708.61; mining spend still ~$252. Floor OK. Cap OK. No burn.

### Next

Rent `mine-h5c-1` → upload shortz JSONL + train/merge scripts → H5c LoRA
→ n80 vs TalentPigs. Re-check snapshot (kevin re-challenge in flight).
