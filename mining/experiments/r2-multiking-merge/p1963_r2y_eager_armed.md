# p1963 — R2y eager Talent×tpc9

- **When:** 2026-08-11T04:56Z
- **Why:** R2o n80 early (~5/80); chal-00463 still queued behind 455→456→458→462.
  Idle CPU/RAM while waiting for Reason stamp wastes crown-pod wall clock.
- **Change:** rewrite `launch_r2y_talent_tpc9_premerge.sh` to R2x eager pattern:
  CPU α-merge now → stamp `r2y_eager_weights.done`; gate `r2y_premerge.done`
  on chal00463 Reason+ (hr>0). Reason− purges blend.
- **Blend:** Talent 0.25 × tpc9 0.75 → `/root/r2_out/alpha_talent_tpc9_skew`
- **Parents:** TalentPigs@dbfbb3e2… · llorite/…-tpc9@dba3b6f3…
- **Does not steal chall:** DONE gated; merge_reload still waits on DONE.
