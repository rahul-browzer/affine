# warm-stack snapshot — pass 539

## Captured
- `warm_stack_triton_cache_p539.tar.gz` (26 MiB compressed)
  sha256 `e55237b16dee582a7f07f3171c8094e64d26f94fae50619b9bf90b02b574e948`
- `warm_stack_triton_manifest.json` — teacher 520f/8.so; king+chall 1654f/24.so each
- `serve_commands.md` — exact live argv + GPU/util/TRITON_CACHE_DIR

## Source pod
`mine-f45-1` / lunar-matrix-d4 · engines 200/200/200 · remove_at 2026-08-09T21:35Z

## Still TODO
1. Merge H64 r=18 (m7-init winner-zA; see `experiments/s4-h64-m7-winner-za-r18/`) onto `/tmp` and point chall at it.
2. Optional: freeze caches after H64 chall load; re-tar if chall `.so` set changes.
