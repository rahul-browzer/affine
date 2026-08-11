# GOAL — win Affine (Bittensor SN120)

**Win the subnet.** Crown checkpoints under the live Reason contract, keep
hotkeys registered in the reign chain, and stay king. Alpha / dollars are a
side effect of winning — they are **not** the objective and must not constrain
how hard you push (beyond the hard floor that protects the validator).

## Operator directive 2026-08-11 — win the subnet, ≥$20k/day B300 fleet

**Objective = win.** Not "make money," not "idle cheaply," not "one careful
pod." The board is adversarial; breadth across experimental axes is how you
find a crown. Serial board-copy screens on one box are not enough.

**Scoring (still Reason v3, `weight_version_key = 3`):**

```
Reason = lpC(y_C | z_A) − lpC(y_C | ∅)     # per pair; miner score = mean
crown  = paired mean(Reason_c − Reason_k) > k_sigma · SE
```

Confirm live `k_sigma` from `api/v1/contract` / snapshot every pass (it has
moved). No gates on score. Legacy S\* conclusions stay in
`archive/legacy-sstar-v2/` — ops only.

**Compute mandate (operator 2026-08-11) — binding:**

1. **Burn at least $20,000/day on mining B300s** (≥ **~$833/h** summed over
   live `mine-*` 8×B300 pods). This is a **floor**, not a ceiling. At ~$64/h
   per 8×B300 that is roughly **≥13 concurrent B300 boxes**. Prefer B300;
   only use B200 if no B300 is available and replace it when B300 appears.
2. **Raise the pod cap to 25** `mine-*` pods so the floor is reachable.
3. **Multiple axes in parallel, every pass that has free slots.** Do not
   serialize one board-challenger n80 behind another on a single box while
   20 slots sit empty. Independent axes include (non-exhaustive): Reason-SFT /
   distill, GRPO/REINFORCE on Reason reward, full-FT vs LoRA, non-king bases,
   multi-king merges, thought-format, data filters, learning-rate/rank families
   that can move the mean by >~SE. One axis per pod; name pods for the axis
   (`mine-r3-grpo-1`, `mine-r2-merge-3`, …).
4. Keep at least one warm duel stack (teacher+king+chall) able to run n80s;
   the rest of the fleet should be training or screening, not idle.
5. Submit when sim margin clears the live crown bar with ~1.5× headroom on a
   fresh slice. Fresh registered hotkey per submit.

**This pass:** scale toward the $20k/day B300 floor immediately — rent free
B300 capacity up to the cap, assign each new pod a distinct axis, and stop
treating a single $52/h B200 as the fleet.

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
This machine runs the SN120 validator. You win by mining, never by touching
the validator.

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
- Max **25** concurrent `mine-*` pods (operator 2026-08-11). Prefer **8×B300**.

**3. Every pod gets a TTL.**
Always pass `--ttl` to `lium up`. Prefer `--ttl 12h` or `24h` and extend
deliberately while it is working.

**4. Money / burn (validator protected; mining is not thrifty).**
The Lium balance is **shared with the validator** (~$70/h on its pods).

- **Never let the Lium balance fall below $10,000.** That floor is the only
  spend brake. Winning the subnet is the goal; do not under-spend to "save"
  credit above the floor.
- **Mining B300 burn floor: > $20,000/day (≥ ~$833/h)** on live `mine-*`
  8×B300 pods (operator 2026-08-11). Sum `$/h` every pass into `LEDGER.md`.
  If you are **under** the floor and B300 capacity exists, **rent in the same
  pass**. Idle under-spend is a failure mode.
- There is **no** mining spend ceiling above the floor unless a later dated
  directive here adds one.
- Reconcile cumulative spend from `lium balance` deltas, never by summing
  teardown costs.
- Fund Lium only from the `miner` wallet if ever instructed. Never `-w default`.
- **The coldkey is NOT your budget.** Registration reserve only. Do not convert
  TAO→Lium without a dated per-amount instruction here.
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

**Stage 4 — beat the king; parallel axes at fleet scale.**
Train / merge / distill / RL candidates. Decision metric: paired Reason margin
vs live king. Run **many axes at once** on the B300 fleet — do not wait for
one n80 to finish before renting the next axis.
*Gate: margin > live (k_sigma·SE) with ~1.5× headroom on a fresh slice.*

**Stage 5 — submit.**
Register hotkey, `submit.py --check`, submit, watch verdict. Winning (crown)
is the point; reinvestment is incidental.

---

## Use the compute

- **Floor: >$20k/day mining on 8×B300** (≥~$833/h, ~≥13 boxes @ ~$64/h). Cap 25
  pods. Report burn vs floor in `LEDGER.md` / `STATE.md` every pass.
- **Unit of parallelism = experimental axis**, not "another board parent on the
  same recipe." If two pods would run the same method with a cosmetic parent
  swap, that is one axis — free the slot for something structurally different
  (GRPO-on-Reason, full-FT, non-king base, thought format, data curriculum, …).
- Keep one warm TKC duel stack; put training weight on the other GPUs/pods.
- Tear a pod when its experiment resolves. Idle pods count against the floor
  without buying information — replace them.
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
