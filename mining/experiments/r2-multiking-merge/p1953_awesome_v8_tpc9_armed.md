# p1953 — arm awesome-v8 + tpc9 prefetch

While R2l Talent×sft3 n80 ~11/80 gathers on mine-crown-1:

- Index probe OK: `0pentensor/Affine-5dflhtkufw-awesome-v8@6c04b16d461d429f9e288508e92f9e42322baec6` (2 shards, ~70 GiB)
- Index probe OK: `llorite/affine-5cjfxpsxn8-tpc9@dba3b6f31b3078cda332434b962c8343ea2aa7d4` (4 shards, ~70 GiB)
- Launched: `launch_prefetch_awesome_v8.sh` then chained `launch_prefetch_tpc9_after_awesome_v8.sh`
- Reason watchers: `watch_chal00462_reason.sh`, `watch_chal00463_reason.sh`
- No GPU merge until post-verdict Reason+ stamp
