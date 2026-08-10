# R1 result log

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
