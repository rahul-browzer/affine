# warm-stack snapshot — pass 539 / H64 ready p541

## Captured
- `warm_stack_triton_cache_p539.tar.gz` (26 MiB compressed)
  sha256 `e55237b16dee582a7f07f3171c8094e64d26f94fae50619b9bf90b02b574e948`
- `warm_stack_triton_manifest.json` — teacher 520f/8.so; king+chall 1654f/24.so each
- `serve_commands.md` — exact live argv + GPU/util/TRITON_CACHE_DIR (updated p541)

## Source pod (snapshot)
`mine-f45-1` / lunar-matrix-d4 · engines 200/200/200 · TTL ended 2026-08-09T21:35Z

## H64 chall swap — DONE p541 @ 12:04:10Z
- DL `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f` → `/tmp/h64_merged` (66G)
- :8002 id=`/tmp/h64_merged` · engines **200/200/200** · chall `n_so=24` (no re-tar)
- Stamp: `/root/logs/h64_chall_swap.done`

## Re-rent p1115 @ 21:38Z
- `mine-watch-1` / golden-wolf-bd / `37b3ea5c…` @$28/h `--ttl 6h` → remove_at 03:38Z
- SSH 152.236.142.236:40301 · COUNT=8 · tar sha e55237b1… uploaded
- `restore_warm_stack.sh` nohup pid=901 → poll `/root/logs/warm_stack_ready.done`
