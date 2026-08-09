# warm-stack — KING-WATCH snapshot

## Goal
Capture Triton caches + serve/merge commands from `mine-f45-1` so a fresh
pod reaches PROMPTABLE in one pass.

## Pod
- Lium name `mine-f45-1` / huid `lunar-matrix-d4` / role mine-watch-1
- SSH `root@38.255.28.21 -p 20099` · kh `/tmp/mine-f45.kh`
- Engines :8000 teacher / :8001 king Tok / :8002 chall (was h140 merged)

## Next (pass after p538)
1. Tar `/root/.triton/cache/{chall,king,teacher*}` (+ note isolated TCACHE paths).
2. Record exact `vllm serve` argv for teacher/king/chall.
3. Merge H64 r=18 Tok-init winner-zA onto local `/tmp` chall; leave ready.
