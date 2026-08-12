# Affine (Bittensor SN120)

Affine is a teacher-anchored distillation subnet on Bittensor. Miners submit
fine-tuned coding-model checkpoints; a frozen teacher model attempts real
software-engineering tasks from a public corpus, and checkpoints are ranked by
how much their reasoning improves the teacher's own actions. Head-to-head duels
crown a King, and emissions pay the King chain (the current king plus up to four
prior kings). Every verdict is replayable offline from public data.

- Website & live dashboard: https://www.affine.io
- Machine-readable index: https://www.affine.io/llms.txt
- Live API: https://www.affine.io/api/v1/ (snapshot, history, contract, duels, benches, dataset, SSE stream)
- Public data & code mirror: https://s3.hippius.com/affine-sn120

## How the game works

1. A miner submits a Hugging Face checkpoint via commit-reveal on-chain.
2. The eval server loads it under a fixed vLLM configuration and runs a duel
   against the reigning King over turns drawn from the public corpus (Corpus D:
   SWE coding turns with reference solutions).
3. Per turn, the miner model produces a "thought"; the frozen teacher
   (`zai-org/GLM-4.5-Air-FP8`) then attempts the task with and without that
   thought. The score is the shift in the teacher's log-probability of its own
   correct action:

   ```
   Reason = lpC(y_C | z_A) − lpC(y_C | ∅)
   ```

   The miner's own logprobs never enter the ranked quantity — only the teacher's
   confidence shift matters, which is what makes the metric hard to game.
4. A challenger is crowned when the paired mean advantage over the king exceeds
   `max(k_sigma · SE, min_margin)` with `k_sigma = 2.0` and `min_margin (δ) = 0.002`
   over 2,080 paired turns (see `affine/affine.toml` for the live contract).
5. The King chain earns emissions until dethroned. Advisory SWE benchmarks
   (`swe_rebench_lite`) are published but never affect crown scoring.

## Submitting a miner (checklist)

0. Wallet: `pip install bittensor huggingface_hub`; `btcli wallet create`;
   check cost `btcli subnets burn-cost 120`; register
   `btcli subnets register --netuid 120 --wallet W --wallet-hotkey H`.
1. Train a coding model that emits thoughts and bash-fenced actions under the
   Affine chat contract (`evalsrv/chat.py`).
2. Push weights to Hugging Face as safetensors (single file or sharded + index).
   Public and non-gated. No `*.py` files, no `auto_map` in config. Caps:
   ≤90 GB safetensors, ≤100 GB repo, ≤5,000 files, `config.json` ≤1 MiB.
3. Name the repo to match `^[^/]+/[Aa]ffine-.+$` and embed both the first 5 and
   last 5 lowercase characters of your coldkey or hotkey ss58 address.
4. Pin a 40-hex revision — never a moving branch.
5. Pre-flight locally before submitting (this is where most submissions die):

   ```bash
   vllm serve you/Affine-<token>-mymodel --revision <sha> \
     --max-model-len 65536 --tensor-parallel-size 2
   # then hit /v1/completions with an echo request
   ```

   The eval pod uses vLLM ≥0.8, transformers ≥4.51, no `--trust-remote-code`,
   `--gpu-memory-utilization 0.8`, `--max-num-batched-tokens 8192`. Only
   natively supported vLLM architectures load.
6. Submit with the standalone client:

   ```bash
   curl -O https://s3.hippius.com/affine-sn120/code/scripts/submit.py
   python submit.py --repo you/Affine-<token>-mymodel \
     --wallet YOUR_WALLET --hotkey YOUR_HOTKEY --revision <40hex> --check
   python submit.py --repo you/Affine-<token>-mymodel \
     --wallet YOUR_WALLET --hotkey YOUR_HOTKEY --revision <40hex>
   ```

   The on-chain payload is `affine1|<hf_repo>|<rev_40hex>|<hotkey_ss58>`,
   timelock-encrypted with a 60-second reveal window.
7. Monitor the dashboard: intake → duel queue → fails.

Hard policies: one submission per hotkey, ever — the slot is consumed only
when a real submission is enqueued. Running `submit.py --check` performs
validation only: it never submits and never consumes the slot, which is why
you should always run it first. Submitted revisions can never be resubmitted
by anyone, and weight-identical copies of the king are rejected unless your
Hugging Face timestamp predates the king's.


## Training a miner (the chat contract)

Duels sample turns from Corpus D. Per turn, the miner model performs a natural
rollout under its own chat template with the prompt ending inside an open
`<think>` block. The canonical assistant body the eval server expects is:

```
</think>
THOUGHT: {z}

{y}
```

i.e. latent reasoning inside `<think>...</think>`, then a visible `THOUGHT:`
line whose text `z` is what gets scored, then the action `y` containing a
final closed ```bash fenced block (the eval server extracts the last closed
bash fence; anything without one scores as a null action).

Budgets from the live contract (`GET /api/v1/contract`, `[duel]`):
`max_thought_tokens = 1024`, `max_action_tokens = 768`, sampling
`temperature = 0.8`, one miner sample per turn.

What to optimize: only the teacher-side effect of the thought is ranked —
`Reason = lpC(y_C | z_A) − lpC(y_C | ∅)`, the shift in the frozen teacher's
log-probability of its own correct action when shown your thought. The miner's
own action and logprobs never enter the ranked score. Train the model to emit
concise thoughts that raise the teacher's confidence in the reference
solution, using Corpus D turns (prompts + reference solutions) as training
data. The checkpoint must remain a stock vLLM-supported architecture (no
custom code) and fit the serving envelope: tensor-parallel-2, 65,536 context,
<= 90 GB safetensors.

## Live API

Base URL `https://www.affine.io/api/v1/`:

| Endpoint | Purpose |
|---|---|
| `GET /snapshot` | Current state: king, queue, eval machine, market data |
| `GET /history` | Verdict history |
| `GET /benchmarks` | Advisory bench scores |
| `GET /contract` | Live contract knobs |
| `GET /duels/{id}` | One duel's detail |
| `GET /duels/{id}/series` | Per-turn scores for a duel |
| `GET /benches`, `/benches/{job_id}`, `/benches/{job_id}/trajectory` | Bench manifest, single bench, agent transcript |
| `GET /dataset`, `/dataset/turns`, `/dataset/turn` | Corpus statistics, paginated index, single turn |
| `GET /stream` | Server-sent-event deltas |

Archives on Hippius S3 (`affine-sn120` bucket): `data/` JSON mirrors and the
validator log, `data/*_full.jsonl.gz` complete audit history since genesis,
`evals/` and `benches/` full per-duel and per-bench records, and `turns/` the
corpus (parquet index + gzipped JSONL trajectory chunks). Checkpoints + public
corpus + published code reproduce any verdict offline.

## Repository layout

- `affine/` — validator core: scoring (`score.py`), prior bank, chain payload,
  checkpoint hygiene, state, corpus materialization; live contract in `affine.toml`
- `evalsrv/` — eval server: duel logic (`dueling.py`), corpus sync, chat
  contract, scoring instrumentation, vLLM client, slot lifecycle (`engine.py`)
- `scripts/submit.py` — standalone commit-reveal submission client
- `mining/`, `ops/`, `research/`, `rollouts/` — operator tooling and research
  harness; see `START_HERE.txt` and `AGENTS.md` for the research handoff notes

## Setup

```bash
./setup.sh
source .venv/bin/activate && source .env
```
