# warm-stack — KING-WATCH snapshot

## Goal
Capture Triton caches + serve/merge commands from `mine-f45-1` so a fresh
pod reaches PROMPTABLE in one pass (then we can drop to zero pods).

## Pod
- Lium name `mine-f45-1` / huid `lunar-matrix-d4` / role mine-watch-1
- SSH `root@38.255.28.21 -p 20099` · kh `/tmp/mine-f45.kh`
- Engines :8000 teacher / :8001 king Tok / :8002 chall

## Status (p539)
- [x] Tar `/root/.triton/cache/{teacher,king,chall}` → `warm_stack_triton_cache_p539.tar.gz`
- [x] Record exact `vllm serve` argv → `serve_commands.md`
- [ ] Merge H64 r=18 onto local `/tmp` chall; leave ready (HF push blocked)
