# R1 result log

## p1852 — unstick restore → engines loading
- Teacher DL finished; first restore crashed: `syntax error near **kw` (running script was edited mid-pass).
- Killed pid1305; `mv` `.new`→`restore_warm_stack.sh`; relaunched pid **9697** (skips all HF stamps).
- Pre-linked `/tmp/h64_merged`; B300 patch + Tok preprocessor OK on relaunch.
- vLLM serve started: teacher:8000 / king:8001 / chall:8002 (pids 9910/9923/9936) — weight load in progress, not 200 yet.
- Watcher pid3045 still armed for n80 → `r1_decision.json`. Local `experiments/warm-stack/restore_warm_stack.sh` synced.

## p1851 — pre-serve B300 + Tok hygiene
- Contract `weight_version_key=3`; king Tok af10; fleet=1 mine-crown-1 @$64/h.
- King + H64 downloads done; teacher GLM still ~52G / 55 files mid-flight.
- **Tok:** visual tensors live in language shards (333/333 resolved); derived missing `preprocessor_config.json` from `processor_config.json`.
- **B300:** applied `flash_fwd_sm100` upper-bound patch (`sm_110f`→`sm_121f`); stamped `/root/logs/b300_flash_patch.done`.
- Staged `/root/restore_warm_stack.sh.new` (patch+Tok bake-in); did **not** overwrite running restore pid1305.
- Watcher pid3045 still waiting for 200/200/200 → n80 → `r1_decision.json`.

## p1850 — unblock schema-v2 sim deps
- Contract still `weight_version_key=3`; king Tok af10 unchanged.
- HF DL healthy: `/root/hf` ~78→103G in ~2m (~550MB/s); restore pid1305 + watcher pid3045 alive.
- **Bug found:** venv had pyarrow but **no pandas** → `CorpusSync` / n80 would fail after engines up.
- Installed `pandas==3.0.5` (+ python-dateutil); corpus smoke OK (40335 index rows, epoch 7).
- Stamped `/root/logs/deps_pandas.done`. Patched `restore_warm_stack.sh` + `launch_when_ready.sh` to require pandas/pyarrow.
- No `r1_decision.json` yet (still downloading weights).

## p1849 — Reason harness + corpus + auto n80
- Contract confirmed `weight_version_key=3`.
- Uploaded `/root/mining_src/{affine_pkg,r1-reason-distill,s3-duel-sim}` (read-only score path).
- Corpus sync OK: epoch **7** schema v2 manifest `167085451ab6…` → stamped `corpus.done`.
- Fixed `sync_corpus.sh` for v2 (was failing on missing `turns.jsonl` before stamp).
- `launch_when_ready.sh` pid **3045**: waits PROMPTABLE then runs H64 vs Tok n80 Reason sim → `r1_decision.json`.
- Restore still DL (~44G HF); poll `warm_stack_ready.done` / `r1_decision.json`.

## p1848 — crown bootstrap launched
- Pod: `mine-crown-1` / lunar-orbit-50 / `ssh root@86.38.182.50 -p 40300`
- Uploaded Triton tar + `restore_warm_stack.sh` + `/root/mine.env`
- `nohup` restore pid **1305** @ 2026-08-10T16:14:32Z
