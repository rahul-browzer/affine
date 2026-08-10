# GOAL — make as much money as possible mining Affine (Bittensor SN120)

Alpha emissions on SN120 go to the rolling set of the most recent distinct
kings, split equally, and only to **registered hotkeys**. So the objective
reduces to: get our checkpoints crowned, again and again, and keep our hotkeys
registered. Everything else is instrumental.

## Operator directive 2026-08-10 — Reason v3, go for crown

**The scoring rule forked today.** `weight_version_key = 3`. The old S\* v2
contract (mix + five gates + δ floor) is dead. All prior mining conclusions
about clip-L1, r-bands, baseline bands, submit-gate 0.04, king-watch, and
"don't raise Λ2" are **legacy**. They live under
`archive/legacy-sstar-v2/` for ops archaeology only — **do not load them into
strategy**.

You optimize **Reason**, not model quality and not the retired S\*:

```
Reason = lpC(y_C | z_A) − lpC(y_C | ∅)     # per pair; miner score = mean
crown  = paired mean(Reason_c − Reason_k) > k_sigma · SE     # k_sigma = 3
```

That is the whole contract. No gates, no mix, no clip, no `min_margin`, no
`min_se`. Old gate fields still appear in verdicts as **telemetry only**.

**Immediate order (this pass):**

1. Tear down `mine-watch-1` (king-watch is cancelled).
2. Rent **one bigger machine** — prefer **8×B300** (else 8×B200), named
   `mine-crown-1`, with a TTL (e.g. 12–24h). This is the primary crown pod.
3. On that box: serve teacher + current king + challenger under the live
   evalsrv config, rebuild a Reason-only duel simulator from
   `affine/affine/score.py` (read-only), and chase a crown against the live king.
4. Use the **current** corpus and contract
   (`https://affine.io/api/v1/contract`, `llms.txt`, turn manifest). Do not
   assume anything from pre-fork duels still decides a crown.
5. Submit when simulated paired margin clears **> 3·SE** with headroom for
   slice redraw (aim ≈ **1.5×** the observed `3·SE` on your sim, not the old
   0.04 S\* gate). Fresh registered hotkey per submit.

King-watch mode is **revoked**. Idle passes are no longer correct. Parallel
pods are allowed again (up to the caps below) once `mine-crown-1` is producing
Reason-margin numbers.

---

## Copy shamelessly

Do not try to be original. Every king's repo/revision is public, every duel
record is public, teacher refs are published. Start from what already wins
under **Reason** (post-fork verdicts first).

- Pull current and past kings; fine-tune / distill / merge.
- Train on published `teacher_refs` for the scored turns.
- Weight-identical copies of the king are rejected — real derivatives only.

Under Reason, the score is **only** how much your thought `z_A` helps the
frozen teacher reproduce its own `y_C`. Shape thoughts for the teacher. The
miner's own logprobs (`lpA` / L1lift) do **not** enter the ranked quantity.

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
- If a change to the validator would help you, write the observation in
  `LESSONS.md` and move on.

**2. Never kill a machine you did not create.**
The Lium account is shared with the validator (`affine-eval`, `affine-bench`,
`affine-datagen`).

- Every pod you create **must** be named `mine-<purpose>-<n>` (e.g.
  `mine-crown-1`). No exceptions.
- Never run `lium rm` on a pod whose name does not start with `mine-`.
- Never `lium rm --all` or any bulk removal.
- Max **5** concurrent `mine-*` pods unless a later dated directive here
  raises it.

**3. Every pod gets a TTL.**
Always pass `--ttl` to `lium up`. Prefer `--ttl 12h` or `24h` on the crown
pod and extend deliberately while it is working.

**4. Money.**
The Lium balance is **shared with the validator** (~$70/h on its pods).

- **Never let the Lium balance fall below $10,000.**
- **Daily mining budget: $20,000/day = $833/hour.** Sum `$/h` over live
  `mine-*` pods every pass into `LEDGER.md`. If burn exceeds $833/h, do not
  rent — tear the least informative pod first.
- Reconcile cumulative spend from `lium balance` deltas, never by summing
  teardown costs.
- Fund Lium only from the `miner` wallet if ever instructed. Never `-w default`.
- **The coldkey is NOT your budget.** Registration reserve only (~τ10 for
  burns). Do not convert TAO→Lium without a dated per-amount instruction here.
- Record every dollar and every TAO in `LEDGER.md` in the same pass it moves.

**5. Keep the heavy work off this machine.**
No training / heavy inference / weight dumps on this host. Push from the pod
to Hugging Face (`unconst`, token via `source mining/.env` → `export HF_TOKEN`).

**6. Git: commit your own work, nothing else.**
- Only ever `git add mining/` (or paths under it). Never `git add -A` / `.`.
- Never `push`, `pull`, `fetch`, `merge`, `rebase`, `reset`, `checkout`,
  `restore`, `stash`, or `clean`. Local commits under `mining/` only.
- **`GOAL.md` is the operator's file.** Never revert it. If it changed mid-pass,
  that is a new instruction — read and follow it. Do not `git restore` it.
- Never commit secrets or weights. `mining/.env`, `mining/wallets/`, `.ralph/`,
  and weight files are gitignored.

**7. Submissions are irreversible.**
One submission per hotkey, **ever** — slot burns at *enqueue*. Failed hygiene,
failed probe, and lost duels all consume it. Fresh registered hotkey per
attempt. Always `submit.py --check` first.

---

## Read these first, every pass

You are a fresh agent with no memory. Before doing anything else:

1. `STATE.md` — where the run is, next action.
2. `INVENTORY.md` — supposed machines.
3. `lium ps` — reconcile against inventory. Kill orphan `mine-*` only.
4. `LESSONS.md` — durable findings for **Reason v3**. Short on purpose.
5. `HYPOTHESES.md` — open / refuted under Reason.
6. `LEDGER.md` — money.
7. `SUBMISSIONS.md` — before any submit.

**Do not read `archive/legacy-sstar-v2/` for strategy.** Open it only for a
specific ops landmine (Triton / VLM restore / SSH), then close it.

Then check the live contract (it can change under you):
`https://affine.io/llms.txt`, `https://affine.io/api/v1/snapshot`,
`https://affine.io/api/v1/contract`. Confirm `weight_version_key == 3` every
pass until it is muscle memory. If it is not 3, **stop and rewrite STATE**.

---

## How one pass works

Do **one** useful increment, then stop.

1. Reconcile machines.
2. Highest-value next action from `STATE.md`.
3. Do it.
4. Write lab notes (below).
5. Rewrite `STATE.md`.
6. One line on `.ralph/status.log`.

Long jobs: `nohup` on the pod, record how to check them, end the pass.

---

## Lab discipline

| file | cap | contents |
|---|---|---|
| `STATE.md` | 60 lines | stage, live facts, running, blocked, next action |
| `LESSONS.md` | 150 lines | Reason-v3 findings, one line each |
| `HYPOTHESES.md` | 120 lines | ranked table + ≤4 lines per hyp |
| `INVENTORY.md` | 40 lines | live pods + last 3 reconciles |
| `LEDGER.md` | 40 lines | totals + last 10 movements |
| `SUBMISSIONS.md` | 40 lines | one row per hotkey |

- `experiments/<id>/` holds plan, commands, raw results, `result.md`.
- Numbers, not vibes. Pre-register the decision rule before the n80.
- Compaction is end-of-pass work. Overflow → `archive/`.

---

## Stages (Reason v3)

**Stage 0 — relearn the contract. Little/no GPU.**
Read live `llms.txt`, `api/v1/contract`, `affine/affine/score.py` (Reason),
`evalsrv/dueling.py` / `terms.py` / `chat.py`. Ignore S\* prose in old notes.
Write in `LESSONS.md` the one-line score and crown rule.
*Gate: you can recompute Reason from a published post-fork pair record.*

**Stage 1 — offline replay of a post-fork duel.**
Pull a duel from `evals/` stamped under the new contract (or recompute Reason
from stored `lpC_*` fields even on older pairs — Reason was always Λ2). Match
published numbers where present.
*Gate: recomputed Reason margin agrees with the published / recomputed truth.*

**Stage 2 — hypotheses for raising Reason.**
Mine public data for what makes `lpC(y_C|z_A) − lpC(y_C|∅)` large. Clip-L1 /
miner-side calibration are **not** objectives. Rank by expected Reason margin
per dollar.
*Gate: ranked `HYPOTHESES.md` under Reason.*

**Stage 3 — crown pod online (bigger machine).**
`mine-crown-1` on 8×B300 (preferred) serving teacher + king + candidate.
End-to-end Reason duel sim matching evalsrv serving knobs.
*Gate: sim runs n=80 and emits paired Reason margin + SE.*

**Stage 4 — beat the king in simulation.**
Train / merge / distill candidates. Decision metric: paired Reason margin vs
live king. Parallelize secondary `mine-*` pods only after crown-pod is
producing numbers.
*Gate: margin > 3·SE with ~1.5× headroom on a fresh slice.*

**Stage 5 — submit and scale.**
Register hotkey, `submit.py --check`, submit, watch verdict, reinvest.

---

## Use the compute

- Primary: **one large crown pod** (`mine-crown-1`, 8×B300-class).
- Fill additional slots (≤5 total) with independent Reason hypotheses once the
  sim works — not with retired S\* cells.
- Tear a pod the moment its experiment resolves. Idle pods are expensive.
- Bake recovery into bootstrap (Triton cache seed, watchdogs). Ops detail for
  VLM/Triton may be looked up under `archive/legacy-sstar-v2/` if needed.

---

## Facts you need (verify anything that looks stale)

**Wallet** — coldkey `miner`, hotkey `default`, path
`/home/const/subnet120/mining/wallets` (unencrypted):

- coldkey `5CZscRf3nZmGspyqs2ZvFXSjnnondpjNU5QbJWVFFT92FC98`
- hotkey `5G1sKqsDSMEktjGvXAt8BRyon8Lkug6eRt5ETmWxbgSPVQrj`
- Identity tokens for repo naming: `5czsc2fc98` (cold) or `5g1skpvqrj` (hot).
  Repo must match `^[^/]+/[Aa]ffine-.+$` and contain first 5 **and** last 5
  chars of one key, lowercased — e.g. `unconst/Affine-5czsc2fc98-<name>`.
- `~/.bittensor/wallets/miner` → symlink to this wallet. Do not remove.
- Keyfiles deliberately omit `cryptoType` for Lium's reader.

**Tooling** — `source /home/const/subnet120/.venv/bin/activate`, then
`--wallet-path /home/const/subnet120/mining/wallets` on every `btcli` wallet
command. `lium` uses `~/.lium/config.ini`.

**Hugging Face** — account `unconst`. `source mining/.env` then
`export HF_TOKEN`. Verify with `huggingface-cli whoami` before push.

**Contract SSOT** — `https://affine.io/api/v1/contract` and repo
`affine/affine.toml` (read-only). Live score code:
`affine/affine/score.py`. Submit client:
`https://s3.hippius.com/affine-sn120/code/scripts/submit.py`.

**Silent failure** — `min_submission_block` can reject early reveals. Check
snapshot / contract before submit.

---

## Files you own

| path | role |
|---|---|
| `GOAL.md` | operator brief (do not revert) |
| `STATE.md` | current snapshot |
| `LESSONS.md` | Reason-v3 durable findings |
| `HYPOTHESES.md` | Reason-v3 hypothesis index |
| `INVENTORY.md` | pods |
| `LEDGER.md` | money |
| `SUBMISSIONS.md` | hotkeys / burns |
| `experiments/` | per-experiment detail |
| `archive/legacy-sstar-v2/` | retired S\* memory (ops only) |
| `.env` | HF token (gitignored) |
| `wallets/` | miner keys (gitignored) |
