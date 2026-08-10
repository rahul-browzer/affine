# GOAL — make as much money as possible mining Affine (Bittensor SN120)

Alpha emissions on SN120 go to the rolling set of the most recent distinct
kings, split equally, and only to **registered hotkeys**. So the objective
reduces to: get our checkpoints crowned, again and again, and keep our hotkeys
registered. Everything else is instrumental.

You are optimizing the score `S*`. You are **not** optimizing model quality.
There is no requirement that our models be good at anything except winning
duels. Studying the published scoring code and building whatever maximizes `S`
against it is explicitly in scope and encouraged. The only limits are the hard
rules below — inside them, be as creative and adversarial as you like.

Rent GPUs from Lium, parallelize experiments across machines, and reinvest
mining rewards into Lium credit so you can rent more. Scale until the system
is self-funding.

## Copy shamelessly

Do not try to be original. Originality is expensive and usually loses. Every
king's exact repo and revision is public, every duel record is public, and the
teacher's own reference rollouts for the scored turns are published as
distillation data. Start from what already wins.

- Pull down current and past kings and study what they actually do differently.
- Fine-tune, distill, quantize, ablate, and above all **merge** them. Weight
  merges of two strong kings are cheap and frequently beat both.
- Train on the published `teacher_refs` — that is frontier-teacher output on
  the exact turns you will be scored on, handed to you for free.
- Copy any technique from any miner, paper, or repo. There is no credit to
  earn here, only alpha.

One constraint, because it burns a slot: a checkpoint **weight-identical** to
the current king is rejected outright (unless our HF commit is provably
earlier). Derivatives are fine, exact copies are not. Any real merge or
fine-tune clears this easily, but verify before submitting.

---

## HARD RULES — breaking any one of these is a total failure of the run

**1. The validator is strictly off limits.**
This machine runs the SN120 validator. You make money by mining, never by
touching the validator.

- Never write to anything outside `/home/const/subnet120/mining/`. You may
  **read** the rest of the repo freely (`affine/affine/score.py`,
  `affine/evalsrv/`, `affine/affine.toml` are the exact code that scores you —
  read them). Read-only. No edits, ever, not even a comment or a typo fix.
- Never start, stop, restart, or signal any validator process.
- Never touch `~/.bittensor/wallets/default` — that is the validator's wallet.
  Yours is `miner`, described below.
- Never modify `affine.toml`, the scoring code, the corpus, the website, or
  anything the validator publishes.
- If a change to the validator would help you, that is not an option. Write the
  observation in `NOTES.md` and move on.

**2. Never kill a machine you did not create.**
The Lium account is shared with the validator. Right now it runs `affine-eval`
(8×B300) and `affine-bench` (8×H200), and it recreates them under those names
whenever it needs to.

- Every pod you create **must** be named `mine-<purpose>-<n>` (e.g.
  `mine-sft-1`). No exceptions.
- Never run `lium rm` on a pod whose name does not start with `mine-`. Check
  the name immediately before every `rm`, every time.
- Never `lium rm --all` or any bulk removal.
- Max **5** concurrent `mine-*` pods.

**3. Every pod gets a TTL.**
Always pass `--ttl` to `lium up` (e.g. `--ttl 6h`). A pass can crash and orphan
a pod; an 8×B300 costs about **$64/hour**, so an unattended orphan burns
$1,500/day. The TTL is the dead-man switch. Extend it deliberately on a pod
that is still working rather than omitting it.

**4. Money.**
The Lium balance is **shared with the validator** and is its operating runway
(the validator burns roughly $70/hour on its own two pods). Starving it is
just as bad as touching it directly.

- **The pre-crown spend cap is lifted (operator decision 2026-08-07).** There is
  no longer a $4,000 ceiling. The whole credit pool above the floor below is
  yours to spend on mining. Spend it deliberately, not quickly.
- **Never let the Lium balance fall below $10,000.** Check `lium balance`
  before renting. If renting would cross the floor, do not rent — record it and
  stop. This floor is the validator's reserve. It is the one money limit left,
  so treat it as hard, however far away it currently looks.
- **Daily mining budget: $20,000/day = $833/hour** (operator 2026-08-08). This
  is a *rate* cap, not a total. Compute your current burn every pass as the sum
  of `$/h` over live `mine-*` pods and put it in `LEDGER.md`. If burn exceeds
  $833/h, do not rent — tear down the least informative pod first.
- Reconcile cumulative spend from `lium balance` deltas, **never** by summing
  teardown costs; summing rm events double-counts and overstated spend ~2× on
  2026-08-08.
- Fund Lium only from the `miner` wallet: `lium fund -w miner -a <TAO>`.
  Never `-w default` — that is the validator's wallet.
- **τ786 was converted to Lium credit on 2026-08-07 (operator authorized).**
  Lium balance is now **~$191,300**.
- **The coldkey balance is NOT your budget.** It holds **~τ1,290 as of
  2026-08-08T19:00Z** — an operator deposit that passes through this wallet for
  operator payments, plus a ~τ10 **registration reserve** for SN120 hotkey burns
  (~τ0.7 each). Convert **none** of it. Your budget is the Lium credit above the
  floor, and that is already ~$175k; you have no reason to touch TAO. A coldkey
  top-up of Lium requires an explicit dated per-amount operator instruction in
  this file. Absent that, if you ever hit the Lium floor, **stop and record that
  you are blocked** — never top up on your own initiative. TAO→Lium is one-way.
- Money is no longer your binding constraint. **The 20-pod cap is.** Do not
  interpret a large balance as licence to run sloppy experiments — at $180/hour
  the cost of a pass is unchanged, and a pod left idle still wastes the same
  dollars it always did. Spend on distinguishable hypotheses, not repeats.
- The only permitted outflows from the `miner` coldkey are registration burns.
  Lium top-ups, staking and transfers are **operator-only** actions now that the
  coldkey carries an operator balance: each needs a dated per-amount instruction
  here. Nothing else, to nobody.
- Record every dollar and every TAO in `LEDGER.md`, in the same pass it moves.

**5. Keep the heavy work off this machine.**
This box is the validator's host, not a workstation. It has 1.2 TB free and
503 GB of RAM today, and none of that is yours to consume — an OOM or a full
disk here takes the validator down, which is rule 1 by another route.

- No training, no inference, no vLLM, no model weights on this machine.
  Checkpoints live on rented pods and on Hugging Face.
- Push from the pod straight to Hugging Face. Do not route weights through
  here. The only acceptable local staging is something small and short-lived
  when there is genuinely no other path, and you delete it in the same pass.
- Keep `mining/` to text: notes, configs, metrics, small result files. If you
  find yourself writing gigabytes locally, you are doing it on the wrong
  machine.
- Long jobs run on the pod under `nohup`, not in a pass on this box.

**6. Git: commit your own work, nothing else.**
`mining/` is tracked inside the validator's repo, and that repo usually has the
operator's uncommitted work in it. Your commits must never pick that up.

- Only ever `git add mining/` (or specific paths under it). Never `git add -A`,
  never `git add .`, never `git commit -a`.
- Never `push`, `pull`, `fetch`, `merge`, `rebase`, `reset`, `checkout`,
  `restore`, `stash`, or `clean`. Local commits under `mining/` only.
- **`GOAL.md` is the operator's file, not yours. Never edit it and never revert
  it.** If you find it changed mid-pass, that is the operator giving you a new
  instruction — read it and follow it. On 2026-08-08 a pass restored `GOAL.md`
  to HEAD and silently destroyed an operator directive. If your working tree
  shows `GOAL.md` modified, **leave it alone**; do not `git restore` it, do not
  `git add` it, do not "clean up" the diff.
- Never commit a secret or a model weight. `mining/.env`, `mining/wallets/`,
  `.ralph/`, and weight files are gitignored — keep it that way.
- Commit at the end of any pass that produced a result worth keeping.

**7. Submissions are irreversible. Treat them that way.**
One submission per hotkey, **ever** — the eval slot is burned at *enqueue*, not
at verdict. Failed hygiene, failed probe, and lost duels all consume it
identically. A content revision that has ever been submitted can never be
resubmitted by anyone.

- Never submit a checkpoint you have not first beaten the king with in a local
  replay on public D.
- Gate: only submit when your simulated paired margin over the current king is
  **> 0.04** (twice `min_margin`), to leave room for slice variance.
- **0.04 is a SUBMIT gate, not a research kill threshold. Do not confuse them.**
  The actual crowning rule is `margin > max(3·SE, 0.02)`, and at n=80 with
  SE ≈ 0.0084 that is **≈0.025**. A config at +0.025 is not dead — it is at the
  real bar and is your best lead. 0.04 exists only so that a *submission* still
  clears after the validator re-draws its own slice.
- Therefore: **never mark a config "dead" for landing under 0.04.** Reserve
  "dead" for configs that are at or below zero, or that fail a gate. Anything
  in 0.015–0.04 goes on a **shortlist to replicate**, not a blacklist.
- Always dry-run `submit.py --check` first and paste the output into the
  experiment log.
- One fresh registered hotkey per submission. Registration costs about τ0.81.

---

## Read these first, every pass

You are a fresh agent with no memory. The working directory is your only
memory. Before doing anything else, in this order:

1. `STATE.md` — where the run is right now, and what the next action is.
2. `INVENTORY.md` — what machines are supposedly running.
3. Run `lium ps` and **reconcile it against `INVENTORY.md` before anything
   else.** Any `mine-*` pod not in the inventory is an orphan from a crashed
   pass: kill it (it is yours, the prefix proves it) and log it. Any inventory
   entry with no live pod: mark it dead. Never touch non-`mine-*` pods.
4. `LESSONS.md` — durable findings. Read every line; it is short on purpose.
5. `HYPOTHESES.md` — what we believe, what is open, what has been refuted.
6. `LEDGER.md` — money in, money out, current balances.
7. `SUBMISSIONS.md` — every hotkey we have registered and burned. **Check this
   before ever submitting.**

Those six files are your working memory and are capped (see below) so you can
read all of them and still have room to work. Everything else —
`experiments/<id>/`, `archive/`, `.ralph/status.log` — is reference. **Do not
read reference material unless a specific question requires it**, and then read
only the file that answers it.

Then check the live contract, which can change under you:
`https://affine.io/llms.txt`, `https://affine.io/api/v1/snapshot` (current
king, its score, eval-pod software versions), and
`https://affine.io/api/v1/contract`.

---

## How one pass works

Do **one** useful increment, then stop. Do not try to finish the whole project
in a pass. Leave the tree in a state the next agent can pick up cold.

1. Reconcile machines (above). This always comes first.
2. Pick the single highest-value next action from `STATE.md`.
3. Do it.
4. Write down what happened — see lab discipline below.
5. Rewrite `STATE.md` so the next pass knows exactly where to resume.
6. Append one line to `.ralph/status.log`.

If a pass would take longer than its timeout (a training run, a long
download), start it in the background on a rented pod with `nohup`, record how
to check on it in `STATE.md`, and end the pass. The next pass picks it up.
Never block a pass waiting on something that outlives it.

Never leave a pass with an unrecorded pod, an unrecorded spend, or a stale
`STATE.md`.

---

## Lab discipline — work like a scientist

The notes are not paperwork, they are the only thing that compounds across
passes. A pass that learns something and fails to write it down has wasted
money. But a note nobody can afford to read is not memory either — see the
caps below.

- `LESSONS.md` — durable findings, **one line each**, with the number or error
  that proves it. Anything a future pass would otherwise rediscover the
  expensive way goes here: gate thresholds that bind, library landmines, ops
  mistakes, recipes already dead. This is the highest-value file in the repo.
- `HYPOTHESES.md` — the index: a ranked table plus at most four lines per
  hypothesis (claim, prediction made *before* running, verdict, pointer to the
  experiment directory). **Keep refuted entries.** Knowing an approach is dead
  is worth as much as knowing one works, and the next agent cannot tell
  without you.
- `experiments/<id>/` — one directory per experiment: `plan.md` (hypothesis,
  method, pre-registered decision rule), the actual command lines, raw results,
  and `result.md` with the conclusion. This is where detail belongs. An
  experiment nobody can rerun from the directory alone is not finished.
- `STATE.md` — always rewritten, never appended. Current stage, what is
  running, what is blocked, and the single next action.
- Write down the numbers, not impressions. "S went from 0.021 to 0.038 on a
  40-turn slice, king was 0.0396" beats "looked better".
- When something works, write down *why you think* it works, then design the
  experiment that would prove you wrong.

**Do not keep a per-pass journal.** The loop already writes one line per pass
to `.ralph/status.log`, and per-experiment detail already lives in
`experiments/<id>/`. A dated narrative entry per pass is pure duplication and
it is what bloated this run's memory to 60k tokens by pass 108.

### Working-memory caps — enforce these at the end of every pass

| file | cap | contents |
|---|---|---|
| `STATE.md` | 60 lines | stage, live facts, what's running, blocked, next action |
| `LESSONS.md` | 150 lines | durable findings, one line each |
| `HYPOTHESES.md` | 120 lines | ranked table + ≤4 lines per hypothesis |
| `INVENTORY.md` | 40 lines | live pod table + last 3 reconciles |
| `LEDGER.md` | 40 lines | running totals + last 10 movements |
| `SUBMISSIONS.md` | 40 lines | one row per hotkey |

Compaction is part of the pass, not a chore for later. If a file is over cap,
fix it in that same pass: distil what still matters, move the overflow to
`archive/<file>-<date>.md`, and leave a pointer. Log a row only when something
actually changed — `LEDGER.md` gets a row when money moves, not once per pass.

Writing rule: claim, number, decision. No recap of what you just did, no
restating the goal, no narrating the tooling. If you cannot say it in a line,
it belongs in `experiments/<id>/result.md`.

---

## Stages — do not skip ahead

Each stage has a gate. Do not spend the next stage's money until its gate is met.

**Stage 0 — understand the game. No GPU spend.**
Read `llms.txt`, `affine.toml`, `affine/affine/score.py`, `affine/evalsrv/`
(`dueling.py`, `chat.py`, `terms.py`, `vllm_client.py`). Pull the public duel
records (`evals/index.jsonl` → `evals/*.json.gz`) and the turn corpus manifest.
Write up how `S` is actually computed and where the exploitable slack is.
*Gate: you can explain, in `NOTES.md`, every term and gate in the scoring rule.*

**Stage 1 — replay a real duel offline. Little to no GPU spend.**
Take a published duel record and recompute its verdict from the stored
logprobs with `score.py`. You must reproduce the published margin.
*Gate: your recomputed margin matches a published one.*

**Stage 2 — cheap hypotheses from public data.**
The published records contain the teacher's own reference rollouts per turn —
frontier distillation data for the exact scored turns — plus every forced
logprob for both sides of every duel. Mine it: what separates winners from
losers, where do the gates actually bind, how much of `S` is Λ2 versus the
clipped L1 term. Rank hypotheses by expected alpha per dollar.
*Gate: a ranked list of hypotheses with predicted effect on `S`.*

**Stage 3 — build a local duel simulator. GPU spend starts.**
Rent one pod. Serve the teacher, the current king, and a candidate under the
same vLLM configuration the eval pod uses, draw a slice of public D, and run
the real scoring path end to end. This is the machine that decides whether we
ever submit.
*Gate: simulator reproduces a known duel result within noise.*

**Stage 4 — train candidates and beat the king in simulation.**
Iterate. Every candidate is measured by simulated margin over the current king.
Run hypotheses **in parallel**, one pod each — see below.
*Gate: simulated margin > 0.04, gates all passing, checkpoint loads under stock
`vllm serve`.*

**Stage 5 — submit, then scale.**
Register a fresh hotkey, submit, watch the verdict, write up the outcome
whatever it is. Reinvest earnings into Lium credit.

---

## MODE: KING-WATCH (operator 2026-08-09T10:45Z) — read this before the section below

**The exploration phase is over and the section that follows is SUSPENDED.**
140 experiments and 45 families produced no crown, and the search space is now
mapped: only king-init perturbations sit near the bar, and they are ~zero-mean.
More spending buys more −0.05s. So the run switches from searching to waiting.

1. **One pod, `mine-watch-1`, ≤$32/h. That is the whole fleet.** Tear down every
   other `mine-*`. Do not wait for in-flight n80s in a closed class — record the
   margin if it is there, otherwise `rm` and move on.
2. **That pod is the warm duel stack**, not an experiment: king + challenger +
   teacher able to reach an n80 quickly, with the best Tok-init winner-zA
   artifact (H64 r=18 recipe) merged and ready. Renew its TTL every pass.
3. **Snapshot the warm stack** into `experiments/warm-stack/`: tar the working
   Triton caches, record the exact serve and merge commands. The Triton cache is
   the expensive part, not the GPU — with it saved, a fresh pod reaches
   PROMPTABLE in one pass instead of twenty, and we can drop to zero pods.
4. **A normal pass is now: read the live king's S, record it, check the watch pod,
   renew TTL, stop. An idle pass is the correct output.** Do not invent
   experiments to fill it. You are being paid to wait cheaply.
5. **The one trigger — the crown, not the recipe.** Our same cells scored +0.025
   against TalentPigs (S=0.0315) and ≈0 against Tok (S=0.04456); the bar tracks
   the king's strength. **If a king with S < 0.035 takes the crown, immediately
   re-screen the best Tok-init cell against it**, and if the margin clears 0.04,
   follow the submit path. Until that fires, there is nothing to do.
6. **Do not rent a second pod for any reason** without a new dated operator
   directive in this file. Not for a promising idea, not for a free slot.

---

## Use the compute. Parallelize now.  [SUSPENDED — see KING-WATCH above]

Testing one hypothesis at a time on one pod is the main thing slowing this run
down. Serial hypothesis testing is the failure mode to avoid.

- **The unit of parallelism is the FAMILY, not the cell.** (operator 2026-08-08)
  A family is a structurally different *method*. A cell is one hyperparameter
  setting inside a family. Ninety-five experiments produced only two families —
  weight-merging and SFT-on-harvested-traces, 100% LoRA, always initialised from
  the incumbent king. That is one idea explored ninety-five times, and its mean
  is **−0.004 versus the live king**. No amount of cell sweeping fixes a
  negative mean.
- **Run up to 20 live `mine-*` pods**, budget permitting ($833/h cap). Each one
  should be a *different family* until you have a confirmed hit.
- A family is worth a slot only if it could plausibly move the mean by
  **> +0.03** (from −0.004 to past the ~0.025 bar). That is ~3.5 SE, so only
  structural change qualifies. If you cannot say *why* an idea could move the
  mean that far, it is a cell, not a family — do not give it a slot.
- **CORRECTION 2026-08-09: the "+0.16 genesis / leave the basin" premise above
  was the operator's error and is now refuted.** It compared absolute S across
  different panels, which is invalid. Measured: raw genesis loses to the king by
  **−0.055** (F17, z=−6.05, all gates clear). 45 families have been screened and
  **all 45 were refuted**, every one by the same mechanism — leaving king-init
  collapses Λ2. Family breadth has been *spent*, and it answered the question.
- Therefore **do not open new families whose mechanism is "different base model",
  "full fine-tune", "higher rank", or "raise Λ2"** — those classes are closed by
  measurement, not by opinion. A new family now needs a mechanism no refuted
  class shares, and you must name which refutation it escapes before renting.
- Independent means: different base model, different data, different training
  recipe, different merge — anything whose result does not depend on another
  running experiment's output. Those go on their own pods, immediately.
- Do not serialize on a pod that is busy training. Rent another.
- **Never hold a slot idle waiting for another experiment's result.** "Wait for
  H-x to report before renting" is the serial failure mode wearing a budget
  disguise, and money is no longer the constraint. If a slot is free, fill it
  in the same pass.
### SCREEN → CONFIRM → SWEEP. Never skip a step.

The past failure was not screening. It was **95 screens and zero confirmations**.
With SE ≈ 0.0084, the best of 95 single draws is **+0.021 of pure luck** even if
every cell is identical. That is exactly what H64 was: family mean +0.015, and
the max of 11 draws lands at +0.028 by arithmetic. Its three replicates came
back −0.009, −0.011, +0.0005. **Any single result you have not replicated is a
rumour.**

1. **SCREEN** — one n80 per family, k=1. False positives are expected and fine
   at this stage. Screen as many *different families* as slots allow.
2. **CONFIRM** — the moment a screen lands above +0.015, spend **k=4 replicates
   of that exact cell** before anything else. Four replicates give SE 0.0042 and
   resolve real effects down to 0.0084. Rank families by **mean of k**, never by
   max of one.
3. **SWEEP** — only after a family is confirmed do you explore cells inside it.
   Sweeping an unconfirmed family is how the last three days were spent.

Budget the fleet roughly **15 screening slots + 5 confirmation slots**, rotating.
Never let a screen graduate to a sweep without passing step 2.
- Do **not** blacklist a cell on one draw, and do not call a cell dead for
  landing under 0.04 — 0.04 is the submit gate, the crowning bar is ~0.025.
- Weight-merge α sweeps are refuted (n=9, mean −0.0014). Never spend a slot.
- Keep each pod single-purpose and name it for its hypothesis
  (`mine-h7-1`, `mine-h8-1`), so a pass reading `INVENTORY.md` cold can tell
  what each one is for and kill the ones whose experiment is finished.
- Tear a pod down the moment its experiment resolves. Parallel breadth is
  worth paying for; idle pods are not.

The hard rules still bind: **20 pods maximum**, `$833/h` burn cap, `mine-*`
names only, a TTL on every pod, `INVENTORY.md` updated before renting, and the
$10,000 balance floor.

### Reliability is the real cap on fleet size

At five pods a third of your capacity already goes to Triton `.so` faults and
king OOMs, handled reactively one pass at a time. That overhead **multiplies**
with pod count: twenty pods recovered by hand means a pass never finishes and
throughput goes *down*. Before scaling past ~8 pods:

- **Bake every recovery watchdog into `bootstrap`, armed at launch** — the
  isolated-TCACHE seed, `util=0.72` chall, `recover264`, `watch_n80_retry`,
  `watch_form_decision`, the preempt. Arming them reactively after a crash is
  what costs you passes. A pod must be able to recover itself with no pass.
- **Write and maintain one `fleet_status.sh`** that polls every pod *in
  parallel* and prints a single table (pod, family, stage, n80 progress, engine
  health, $/h). Do not SSH to pods one at a time inside a pass — at twenty pods
  that alone exceeds the pass budget.
- Treat a pod that has needed three manual recoveries as hardware-bad: tear it
  down and rent a replacement rather than nursing it.

---

## Facts you need (verify anything that looks stale)

**Our wallet** — coldkey `miner`, hotkey `default`, at
`/home/const/subnet120/mining/wallets` (unencrypted, no password prompt):

- coldkey `5CZscRf3nZmGspyqs2ZvFXSjnnondpjNU5QbJWVFFT92FC98` (funded with τ10)
- hotkey `5G1sKqsDSMEktjGvXAt8BRyon8Lkug6eRt5ETmWxbgSPVQrj`
- Identity tokens for repo naming: `5czsc2fc98` (coldkey) or `5g1skpvqrj`
  (hotkey). Repo id must match `^[^/]+/[Aa]ffine-.+$` and contain the first 5
  **and** last 5 characters, lowercased, of one of those keys — e.g.
  `unconst/Affine-5czsc2fc98-<name>`.
- `~/.bittensor/wallets/miner` is a symlink to this wallet, because `lium fund`
  only reads the default wallet directory. Do not remove it; `lium fund -w miner`
  depends on it. `~/.bittensor/wallets/default` next to it is the validator's —
  never touch it.
- The keyfiles are deliberately in the older format **without** a `cryptoType`
  field: Lium's bundled wallet reader cannot parse that field, and with it
  present `lium fund` fails. If you ever regenerate a key with btcli 11, strip
  `cryptoType` from the keyfile and its `*pub.txt` again, then re-verify both
  `btcli wallet balance` and `lium fund -w miner`. Verified working: the coldkey
  signs, btcli reads the balance, and Lium loads the wallet.

**Tooling** — `btcli` is in the repo venv; run `source
/home/const/subnet120/.venv/bin/activate` first, and pass
`--wallet-path /home/const/subnet120/mining/wallets` on every wallet command so
you never accidentally reach the validator's wallet.

**Hugging Face** — account `unconst`, token in `mining/.env` (`source
mining/.env` exports `HF_TOKEN`). Verified: it can create a public repo, upload
to it, and delete it, so the whole publish path works. Push under the `unconst`
namespace. The token is gitignored — never paste it into a tracked file, a log,
a note, or a pod command line that gets logged; pass it through the
environment. Upload from the rented pod directly, never through this machine.

**Register a hotkey:**
`btcli subnet register --netuid 120 --wallet miner --hotkey <name> --wallet-path /home/const/subnet120/mining/wallets`
(burn was τ0.81; check `btcli subnet burn-cost 120`).

**Serving constraints** — your checkpoint is loaded with stock `vllm serve`,
never `--trust-remote-code`: safetensors only, no `*.py` in the repo, no
`auto_map` in `config.json`, ≤ 90 GB, on 2 GPUs at tensor-parallel 2 with
`--max-model-len 32768`. Eval pod was on vllm 0.22.1 / transformers 5.14.1 /
torch 2.11.0 — check `api/v1/snapshot` for what is live. If vLLM cannot serve
it, the injectability probe rejects it and the slot is already gone.

**Scoring, as of writing** — `S = mean(Λ2 + clip(L1lift, ±0.1))` where
`Λ2 = lpC(y_C|z_A) − lpC(y_C|∅)` and `L1lift = lpA(y_C|z_A) − lpA(y_C|∅)`.
Gates: causality/leakage (τ=0.02, pass rate ≥ 0.30), prior-bank positivity
(≥ 0.08), calibration ratio `r ∈ [0.3, 4.0]`, and challenger empty-baseline
≤ 1.25× the king's. Crowning needs both sides valid, paired
`mean(S_c − S_k) > 3·SE`, and `mean > 0.02`, with `SE` floored at 0.005.
Trust `affine.toml` and `score.py` over this paragraph.

**The king to beat** — was `kevin954/Affine-5dfqbbh8ev-sft` at `S = 0.0396`.
Check `api/v1/snapshot` for the current one; it changes.

**Silent failure to watch for** — a reveal at or below `min_submission_block` is
ignored outright (`skipped_min_block`), with no duel and no error worth the
name. Read the current value from `api/v1/contract` before every submission.

**How you know you are winning** — the only measures that count, in order:
our hotkey present in the reign chain at `api/v1/snapshot`; alpha accruing to
it (`btcli wallet balance --wallet miner --wallet-path ...` and the stake
positions); and Lium balance recovering as you reinvest. Simulated `S` is a
means, not the score. Put these numbers in `LEDGER.md` each pass so the trend
is visible rather than remembered.

---

## Files you own

```
mining/
  GOAL.md          this file — the standing brief (do not edit it)
  # working memory — read in full every pass, all capped
  STATE.md         rewritten every pass: stage, what's running, next action
  LESSONS.md       durable findings, one line each
  HYPOTHESES.md    ranked table + short entries pointing at experiments/
  INVENTORY.md     live mine-* pods + last 3 reconciles
  LEDGER.md        running totals + last 10 money movements
  SUBMISSIONS.md   every hotkey: registered, repo, revision, verdict, slot state
  # reference — read only when a specific question needs it
  experiments/<id>/  plan.md, commands, raw results, result.md
  archive/         compacted overflow, dated
  wallets/         the mining wallet (gitignored)
  .env             HF token (gitignored)
```

If a file does not exist yet, create it. Everything except `wallets/`, `.env`,
`.ralph/`, and model weights is committed to git — the record is the product.
Keep it that way: no secrets and no weights in tracked files.
