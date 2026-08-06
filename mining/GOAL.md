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

- **Never let the Lium balance fall below $28,000.** Check `lium balance`
  before renting. If renting would cross the floor, do not rent — record it and
  stop.
- **Cap cumulative mining spend at $4,000 until our first crown.** After a
  crown, you may reinvest earnings above that.
- Fund Lium only from the `miner` wallet: `lium fund -w miner -a <TAO>`.
  Never `-w default` — that is the validator's wallet.
- The only permitted outflows from the `miner` coldkey are: registration
  burns, Lium top-ups, and staking. Nothing else, to nobody.
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
  `stash`, or `clean`. Local commits under `mining/` only.
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
4. `HYPOTHESES.md` — what we believe, what is open, what has been refuted.
5. `NOTES.md` (tail) — the recent narrative.
6. `LEDGER.md` — money in, money out, current balances.
7. `SUBMISSIONS.md` — every hotkey we have registered and burned. **Check this
   before ever submitting.**

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
money.

- `HYPOTHESES.md` — one entry per hypothesis: an id, a falsifiable claim, the
  experiment that would settle it, a **prediction written before you run it**,
  and the verdict (open / supported / refuted) with the number that decided it.
  **Record refuted hypotheses and keep them.** Knowing an approach is dead is
  worth as much as knowing one works, and the next agent cannot tell without
  you.
- `experiments/<id>/` — one directory per experiment: `plan.md` (hypothesis,
  method, pre-registered decision rule), the actual command lines, raw results,
  and `result.md` with the conclusion. An experiment nobody can rerun from the
  directory alone is not finished.
- `NOTES.md` — append-only narrative journal, newest at the bottom, dated. What
  you tried, what surprised you, what you would do differently.
- `STATE.md` — the opposite: always rewritten, never appended. A short snapshot
  of current stage, what is running, what is blocked, and the single next
  action.
- Write down the numbers, not impressions. "S went from 0.021 to 0.038 on a
  40-turn slice, king was 0.0396" beats "looked better".
- When something works, write down *why you think* it works, then design the
  experiment that would prove you wrong.

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
*Gate: simulated margin > 0.04, gates all passing, checkpoint loads under stock
`vllm serve`.*

**Stage 5 — submit, then scale.**
Register a fresh hotkey, submit, watch the verdict, write up the outcome
whatever it is. Then parallelize: independent hypotheses on separate pods, up
to 5, and reinvest earnings into Lium credit.

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
  STATE.md         rewritten every pass: stage, what's running, next action
  NOTES.md         append-only dated journal
  HYPOTHESES.md    hypothesis ledger with predictions and verdicts
  INVENTORY.md     every mine-* pod: name, huid, gpu, $/hr, ttl, purpose, status
  LEDGER.md        every TAO and dollar in or out, with running balances
  SUBMISSIONS.md   every hotkey: registered, repo, revision, verdict, slot state
  experiments/<id>/  plan.md, commands, raw results, result.md
  wallets/         the mining wallet (gitignored)
  .env             HF token (gitignored)
```

If a file does not exist yet, create it. Everything except `wallets/`, `.env`,
`.ralph/`, and model weights is committed to git — the record is the product.
Keep it that way: no secrets and no weights in tracked files.
