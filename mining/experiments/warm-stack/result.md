# warm-stack snapshot — pass 539

## Captured
- `warm_stack_triton_cache_p539.tar.gz` (26 MiB compressed)
  sha256 `e55237b16dee582a7f07f3171c8094e64d26f94fae50619b9bf90b02b574e948`
- `warm_stack_triton_manifest.json` — teacher 520f/8.so; king+chall 1654f/24.so each
- `serve_commands.md` — exact live argv + GPU/util/TRITON_CACHE_DIR

## Source pod
`mine-f45-1` / lunar-matrix-d4 · engines 200/200/200 · remove_at 2026-08-09T21:35Z

## H64 chall swap (p540, in flight)
- Script: `/root/swap_chall_to_h64.sh` on `mine-f45-1`
- Source: `unconst/Affine-5czsc2fc98-h64-merged@4ebe10443f7f` → `/tmp/h64_merged`
- Then kill :8002 (was `/root/h140/merged`) and serve H64 util=0.72 on existing chall TCACHE
- Done: `/root/logs/h64_chall_swap.done` · meta: `/root/affine_data/h64_chall_swap_meta.json`
- Next: confirm PROMPTABLE; update `serve_commands.md`; re-tar if chall `n_so` ≠24

