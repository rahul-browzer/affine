## p1942 — R2k SKIP (chal-00431 BKN-six Reason−)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,367.
- Harvested `chal00431_reason.json` (scored 02:13:26Z): margin **−0.008159** · se=0.005852 · z=**−1.39** · 3·SE=**0.01755** · headroom=**−0.465×** · n=80 · `challenger_wins=false` · `king_match=true`.
- R2k gate `hr>0` failed → `r2k_premerge.skip` + `r2k_merge_reload.done` (SKIP_R2K_PREMERGE_SKIPPED); **no Talent×BKN6 merge/n80**.
- Board advanced: **chal-00450** sft3 `load_challenger`. Queue: 451→452→455→456→458. R2l still correctly waiting on 450 Reason+.
- R2t saysth×Talent n80 untouched (~34/80, pid 176482); engines 200/200/200.
- Artifacts: `artifacts/chal00431_reason.json`, `artifacts/r2k_{premerge.skip,merge_reload.done}`, `artifacts/r2k_bkn6_skip_p1942.json`.
- Next: harvest R2t; if hr≥1.5× → Stage-5; else 450/458 Reason+ lanes.

## p1941 — R2u WEAK_SKIP (saysth×kevin Δ≪0.01)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,378.
- While R2t n80 ~14→29/80, CPU-premerged saysth0.75×kevin0.25 (saysth layout) → `max_abs_delta=0.00299` · identical_frac=0.438 · 1026 keys · ~420s · 70 GiB.
- Δ≪0.01 → **WEAK_SKIP** (no chall kill / no n80); stubbed `r2u_alpha_decision.json`; purged blend (~66 GiB) → disk 559 GiB free.
- Updated `wait_r2q_before_chall_kill.inc.sh` + R2r merge to yield on R2u; relaunched R2k…p/R2r merge waiters.
- R2t untouched (engines 200/200/200, pid 176482). Finding: saysth/kevin/awesome are one near-identical cluster.
- Artifacts: `artifacts/r2u_{alpha_decision,saysth_kevin_merge_alpha_meta,armed_p1941}.json`.
- Next: harvest R2t; if hr≥1.5× → Stage-5; else queue Reason+ / R2r after 458.

## p1937 — R2s WEAK_SKIP (saysth×awesome Δ≪0.01)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,456.
- R2s CPU premerge finished 01:44:35Z: saysth0.75×awesome0.25 → `max_abs_delta=1.53e-05` · identical_frac=0.659 · 1026 keys · ~297s · 66 GiB.
- Δ≪0.01 → same class as Tok×awesome / kevin×awesome: killed R2s merge waiter **174233** first, stubbed `r2s_alpha_decision.json` (hr=0) + `WEAK_SKIP_NO_N80`, purged blend (~66 GiB).
- R2q pure-saysth n80 untouched (~41/80, pid 171850); engines :8000/:8001/:8002 all 200. R2r no longer blocked by R2s GPU claim.
- Artifacts: `artifacts/r2s_{alpha_decision,merge_reload.done,weak_skip_p1937}.json`.
- Next: harvest R2q decision; if hr≥1.5× → Stage-5; else wait 458 Reason+ for R2r / queue gates.

# R2 result log

## p1930 — whoami (458) prefetch+watch; nearmiss confirm
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,523.
- Board still **chal-00441** `load_challenger` (gzip 404). Harvest deferred.
- Near-miss rescore of published gzips vs Tok: **440 saysth 0.728×** · **436 nvidia 0.454×** · **438 aurora 0.171×** · 437/433/439 Reason−. Gated parents unchanged.
- New queue parent **chal-00458** `marsplan0624/affine-5gedzafcvg-whoami@21ad4572…` — diane-new lineage id, **ungated** weights (25 files / 16 shards). Armed CPU: prefetch pid **159761** + watch-458 pid **159877**. No GPU merge yet (wait Reason+ after R2q).
- Artifacts: `artifacts/r2r_whoami_prefetch_armed_p1930.json`, `artifacts/nearmiss_sweep_p1930.json`, `launch_prefetch_whoami.sh`, `watch_chal00458_reason.sh`.
- Next: harvest 441; R2i…R2q chain; if 458 hr>0 arm R2r Talent×whoami after R2q.

## p1929 — R2j SKIP (chal-00432 BKN-seven Reason−)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,535.
- Harvested `chal00432_reason.json` (01:08:44Z): margin **−0.010257** · se=0.005954 · z=**−1.72** · 3·SE=**0.01786** · headroom=**−0.574×** · n=80 · `challenger_wins=false` · `king_match=true` · formula Reason.
- R2j gate `hr>0` failed → `r2j_premerge.skip` + `r2j_merge_reload.done` (SKIP_R2J_PREMERGE_SKIPPED); pids 150140/150142 dead; **no Talent×BKN7 merge/n80**.
- Board advanced: **chal-00441** thompsville cgpb8 `dispatching` (R2i still correctly waiting). Queue: 431→450→451→452→455→456.
- R2q pure-saysth still armed (157147) behind remaining R2i/k…p terminals. Engines healthy.
- Artifacts: `artifacts/chal00432_reason.json`, `artifacts/r2j_{premerge.skip,merge_reload.done}`, `artifacts/r2j_bkn7_skip_p1929.json`.
- Next: harvest 441 Reason stamp; if + let R2i fire; else keep k…p gates / R2q.

## p1927 — R2p Talent×sth armed (455)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,545.
- R2i…R2o still waiting on unpublished eval gzips (404); engines 8000/8001/8002 healthy; disk ~295 GiB free.
- sth prefetch already DONE `@8d81e782…` — armed **R2p** without waiting for a refute: watch-455 pid **155793** + `launch_r2p_talent_sth_premerge.sh` **155822** (wait 455 hr>0 → Talent0.25×sth0.75 @ `/root/r2_out/alpha_talent_sth_skew`) + `launch_r2p_merge_reload_sim.sh` **155835** (GPU after R2i…R2o; submit bar 1.5×).
- Artifacts: `artifacts/r2p_sth_armed_p1927.json`.
- Next: first Reason+ among 441/432/431/450/456/451/452/455 → merge→n80; else scan for new DL parent.

## p1925 — R2g REFUTE; R2n Talent×asdf armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,557.
- Harvested `r2g_alpha_decision.json` (00:53:55Z): margin **−0.02030** · se=0.00759 · z=**−2.67** · 3·SE=**0.02278** · headroom=**−0.891×** · reason_c=−0.03810 · reason_k=−0.01608 · n_paired=79 · `challenger_wins=false`.
- Decision `REFUTE_R1_H64_BASELINE` (hyp=R2g) — **do not submit** (bar 1.5×). Parent 440 saysth was Reason+ 0.73×; skew merge lost.
- Armed **R2n**: watch-451 pid **153903** + `launch_r2n_talent_asdf_premerge.sh` **153922** (wait 451 hr>0 → Talent0.25×asdf0.75 @ `/root/r2_out/alpha_talent_asdf_skew`) + `launch_r2n_merge_reload_sim.sh` **153931** (GPU after R2i…R2m; submit bar 1.5×).
- Disk ~295 GiB free; asdf prefetch already DONE `@c2309815…`. R2i/j/k/l/m waiters still polling 404 evals.
- Artifacts: `artifacts/r2g_alpha_{decision,reason_sim}.json`, `artifacts/r2n_asdf_armed_p1925.json`.
- Next: first Reason+ among 441/432/431/450/456/451 → merge→n80; else arm Talent×zeus (452).

## p1920 — R2j Talent×BKN7 armed; asdf+zeus DONE
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,613.
- Prefetch chain: **asdf DONE** 00:31:38Z `@c2309815…`; **zeus DONE** 00:35:30Z `@accc9249…`; **sth** downloading after zeus (~8 GiB).
- R2g Talent×saysth n80 still gathering (~36/80, pid 146391) — not harvestable yet.
- Armed **R2j**: `launch_r2j_talent_bkn7_premerge.sh` pid **150140** (wait 432 Reason hr>0 → Talent0.25×BKN7 0.75 @ `/root/r2_out/alpha_talent_bkn7_seven_skew`) + `launch_r2j_merge_reload_sim.sh` pid **150142** (GPU after R2g/R2i terminal; submit bar 1.5×).
- Re-probe: chal-00436 nvidia still weight-gated for unconst (index 403) despite public sibling list — do not prefetch.
- Artifacts: `artifacts/r2j_bkn7_armed_p1920.json`.
- Next: harvest `r2g_alpha_decision.json`; R2i/R2j fire on 441/432 Reason+.

## p1913 — disk cleanup while R2g merges; BKN seven live
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,646.
- R2g Talent×saysth CPU merge **alive** (pid 140939) ~7/16 shards → `/root/r2_out/alpha_talent_saysth_v9a_skew`; reload waiter 130835 armed.
- Board: **chal-00432** = `BKN1890/…-seven` @ `load_challenger` (watch 140530 already polling gzip).
- Disk was 81% / 334 GiB free — purged dead `r2_out` blends (kevin×awesome, tok×talent×kevin, tok×awesome×2, talent×awesome) + unconst h64 cache → **729 GiB free** (58%). Kept R2g out + awesome_v6_chall stub.
- Note: `/tmp/r2h_ttk_merged` symlink pointed at deleted TTK dir; chall engine stayed **200** (GPU-resident) until R2g reload. Lesson stamped.
- Artifact: pod `/root/affine_data/disk_cleanup_p1913.json` → `artifacts/disk_cleanup_p1913.json`.
- Next: harvest `r2g_alpha_decision.json` after n80; submit only if hr≥1.5×.

## p1912 — chal-00440 saysth Reason+ (0.73×); R2g merge ungated
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,657.
- Harvested eval gzip mid-finish (79/80→publish): `chal00440_reason.json` — margin **+0.009156** · se=0.004193 · z=**2.18** · 3·SE=**0.01258** · headroom=**0.728×** · n=80 · `king_match=true` · `challenger_wins=false` · formula stamped Reason.
- Signal `POS_BELOW_3SE` — not a crown, but clears R2g gate (hr>0).
- Pod watcher 129745 stamped DONE; premerge **130003** gate ok → CPU `merge_alpha.py` Talent0.25×saysth0.75 → `/root/r2_out/alpha_talent_saysth_v9a_skew`; reload waiter **130835** armed for chall→n80.
- R2i/441 + BKN/432 waiters still alive; no new rent/prefetch.
- Artifacts: `artifacts/chal00440_reason.{json,done}`.
- Next: harvest `r2g_alpha_decision.json` after n80; submit only if hr≥1.5×.

## p1911 — R2h TTK REFUTED; BKN seven watch armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,657.
- Harvested `r2h_ttk_decision.json` (00:09:39Z): margin **−0.02112** · se=0.01192 · z=**−1.77** · 3·SE=**0.03577** · headroom=**−0.591×** · reason_c=−0.04088 · reason_k=−0.01658 · n_paired=60 · `challenger_wins=false`.
- Decision stamp `REFUTE_R1_H64_BASELINE` (template; hyp=R2h) — **do not submit** (bar 1.5×).
- BKN seven prefetch **DONE** 00:00:15Z (~66 GiB); mirrored done stamp to `affine_data/`; armed `watch_chal00432_reason.sh` pid **140530**.
- R2g/R2i waiters still alive (440/441 Reason stamps absent; board still scoring chal-00440).
- Artifacts: `artifacts/r2h_ttk_{decision,reason_sim}.json`, `artifacts/r2h_harvest_p1911.json`, `watch_chal00432_reason.sh`.
- Next: R2g if saysth Reason+ else R2i on 441; BKN merge only after 432 Reason+.

## p1909 — R2i reload→n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,702.
- R2h TTK n80 still **RUNNING** (~30/80 @23:53Z; sim 137312; no decision).
- chal-00440 now **scoring** (eval gzip still 404 until duel finishes); 440 watcher + R2g waiters intact.
- Thomp prefetch **DONE** 23:51:15Z; R2i premerge 138637 waiting 441 Reason stamp.
- Wrote+synced `launch_r2i_merge_reload_sim.sh`; armed pid **139014** — after premerge ready + R2h/R2g below-bar lane → chall reload Talent×thomp → n80 (`r2i_alpha_decision.json`); SKIP if premerge skipped or prior clears 1.5×.
- Artifacts: `artifacts/r2i_reload_armed_p1909.json`.
- Next: harvest `r2h_ttk_decision.json`; if <1.5× → R2g if saysth Reason+ else R2i when 441 Reason+/premerge + lane free.

## p1908 — R2i Talent×thompsville gated (441 watcher + premerge)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,702.
- R2h TTK n80 still **RUNNING** (~19/80 @23:50Z; sim 137312; no decision).
- chal-00440 still `load_challenger` (gzip 404 expected); 440 watcher + R2g waiters intact.
- Armed CPU: `watch_chal00441_reason.sh` pid **138617** → `chal00441_reason.json`.
- Armed CPU: `launch_r2i_talent_thomp_premerge.sh` pid **138637** — waits thomp prefetch + 441 Reason+ (hr>0) → Talent0.25×thomp0.75 @ `/root/r2_out/alpha_talent_thomp_cgpb8_skew`.
- Thomp prefetch still mid-download (138058); no GPU touch.
- Artifacts: `artifacts/r2i_talent_thomp_armed_p1908.json`.
- Next: harvest `r2h_ttk_decision.json`; if <1.5× → R2g if saysth Reason+ else R2i reload when premerge ready + lane free.

## p1907 — thompsville chal-00441 prefetch while R2h gathers
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,713.
- R2h TTK n80 still **RUNNING** (~7/80 @23:47Z; sim 137312; no decision).
- chal-00440 still `load_challenger` (no eval gzip / duel API 404); watcher 129745 + R2g waiters intact.
- Evals index max still chal-00439 — no new completed Reason+ parents.
- Queue index-probe: **thompsville/…-cgpb8@1da22459** weights_ok ~70 GiB; also syntaxsorcerer1/sft3, adsbasd/asdf, BKN1890/seven OK.
- Armed CPU prefetch `launch_prefetch_thompsville.sh` pid **138058** → `/root/logs/r2_prefetch_thompsville.{log,done}`.
- Artifacts: `artifacts/r2_prefetch_thompsville_p1907.json`.
- Next: harvest `r2h_ttk_decision.json`; if <1.5× → R2g if saysth Reason+ else Talent×thompsville gated on 441 Reason+.

## p1906 — R2e Talent×awesome REFUTED; R2h TTK n80 launched
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,725.
- Harvested `r2e_alpha_decision.json` (23:39:06Z): margin **−0.03641** · se=0.01026 · z=**−3.55** · 3·SE=**0.03077** · headroom=**−1.183×** · reason_c=−0.04148 · reason_k=−0.00532 · n_paired=80 · `challenger_wins=false`.
- Decision stamped `REFUTE_R1_H64_BASELINE` (template string; hyp=R2e) — do **not** submit (bar 1.5×).
- Auto-chain: R2h took GPU (R2g still waiting 440 Reason) → chall **132046** `/tmp/r2h_ttk_merged` → engines 200@65536 → n80 sim **137312** (hotkey `local-r2h-ttk-20260810T234453Z`, bh `bdd5bd3807eb2c16…`).
- Artifacts: `artifacts/r2e_alpha_{decision,reason_sim}.json`.
- Next: harvest `r2h_ttk_decision.json`; if <1.5× → R2g if saysth Reason+ else parent rescan.

## p1905 — R2h Tok×Talent×kevin n80 armed (never simulated)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,780.
- R2e Talent×awesome n80 still **RUNNING** (~37/80 @23:20Z; sim 128291; no decision).
- Found: `/root/r2_out/alpha_tok_talent_kevin` (Δ=**0.277**, 66 GiB) was premerged but **never n80'd** — p1893 stubbed `r2_alpha_decision` for Tok×awesome weak-Δ, not TTK.
- Wrote+synced `launch_r2h_ttk_reload_sim.sh`; armed pid **130845** — after R2e below-bar, takes GPU if R2g still waiting 440 Reason (else after R2g) → `r2h_ttk_decision.json`.
- Re-armed R2g reload **130835** (killed old 130365) with R2h pidfile gate so it won't yank chall mid-R2h.
- chal-00440 still `load_challenger`; watcher 129745 + premerge 130003 intact.
- Next: harvest `r2e_alpha_decision.json`; if <1.5× follow R2h/`r2h_ttk_decision.json` then R2g if saysth Reason+.

## p1904 — R2g reload→n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,780.
- R2e Talent×awesome n80 still **RUNNING** (~32/80 @23:17Z; sim 128291; no decision).
- chal-00440 still `load_challenger` (no eval gzip yet); watcher 129745 + premerge 130003 waiting.
- Wrote+synced `launch_r2g_merge_reload_sim.sh`; armed pid **130365** — waits `r2g_premerge.done|skip` then R2e below-bar lane → chall reload Talent×saysth → n80 (`r2g_alpha_decision.json`); SKIP if premerge skipped or prior clears 1.5×.
- Next: harvest `r2e_alpha_decision.json`; if <1.5× follow R2g chain to `r2g_alpha_decision.json`.

## p1903 — R2g Talent×saysth gated waiter + near-miss rescan
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,792.
- R2e Talent×awesome n80 still **RUNNING** (~28/80 @23:14Z; sim 128291; no decision).
- Rescan chal-00420..439 vs Tok (per-turn Reason): top DL still **awesome-v6 hr≈0.92×**; nvidia/diane gated; no new completed Reason+ parents.
- Wrote+synced `launch_r2g_talent_saysth_premerge.sh`; armed pid **130003** — waits for 440 Reason stamp with hr>0 then Talent0.25×saysth0.75 → `/root/r2_out/alpha_talent_saysth_v9a_skew` (else SKIP).
- Artifacts: `artifacts/reason_nearmiss_p1903.json`.
- Next: harvest `r2e_alpha_decision.json`; if below 1.5× → use R2g done/skip + 440 Reason for next chall.

## p1902 — saysth prefetch DONE + chal-00440 Reason watcher
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,792.
- R2e Talent×awesome n80 still **RUNNING** (~21/80 @23:11Z; sim 128291; no decision).
- Saysth prefetch **DONE** 23:10:39Z (`saysth/…-v9a@6e13f365…`, 285.6 s) → `/root/logs/r2_prefetch_saysth.done`.
- Evals index max still chal-00439 (no new completed parents).
- Armed CPU watcher `watch_chal00440_reason.sh` pid **129745** → `/root/affine_data/chal00440_reason.json` + `/root/logs/watch_chal00440_reason.done`.
- Artifacts: `artifacts/r2_prefetch_saysth_p1902.json`.
- Next: harvest `r2e_alpha_decision.json`; if below 1.5× and saysth Reason+ → R2g.

## p1901 — parent scan + saysth prefetch while R2e gathers
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,803.
- R2e Talent×awesome n80 **RUNNING** (~7/80 @23:06Z; sim 128291; chall 124848; no decision yet).
- Incremental Reason rescan (per-turn mean from row pairs):
  - **chal-00433** `vera6/…-cc` hr≈**−0.21×** · downloadable · not a parent
  - live **chal-00440** `saysth/Affine-5dtnxamt4t-v9a@6e13f365b36000cf631aad2fa9fb05fdabae0044` · **weights_ok** · no verdict yet
  - best DL Reason+ unchanged: awesome-v6 hr≈0.92×
- Armed CPU prefetch `launch_prefetch_saysth.sh` pid **129090** → `/root/logs/r2_prefetch_saysth.{log,done}`.
- Artifacts: `artifacts/reason_nearmiss_p1901.json`.
- Next: harvest `r2e_alpha_decision.json`; if below 1.5× and saysth Reason+ → R2g merge plan.

## p1899 — R2d pure awesome-v6 n80 DONE → SIGNAL_POS_BELOW_3SE
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,825.
- Harvested `r2d_awesome_decision.json` (22:56:43Z): margin **+0.002227** · se=0.003387 · z=**0.658** · 3·SE=**0.01016** · headroom=**0.219×** · reason_c=−0.00855 · reason_k=−0.01074 · n_paired=80 · `challenger_wins=false`.
- Decision **`SIGNAL_POS_BELOW_3SE`** — do **not** submit (bar 1.5×).
- R2e waiter auto-freed lane at iter=535 → linked `/tmp/r2e_alpha_merged` → killed chall 117592 → launched chall **124848** on Talent×awesome (Δ=0.626); health still loading @22:57Z.
- Artifacts: `artifacts/r2d_awesome_{decision,reason_sim}.json`, `r2d_awesome_reload.done`.
- Next: wait R2e chall healthy + n80 → harvest `r2e_alpha_decision.json`.

## p1898 — R2f kevin×awesome PREMERGE DONE → WEAK_SKIP n80
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,870.
- Harvested `/root/logs/r2f_premerge.done`: **OK** 22:35:17Z · w_kevin=0.25 w_awesome=0.75 · max_abs_delta=**0.008987** · n_keys=1045 · identical_frac=0.448 · 72 GiB @ `/root/r2_out/alpha_kevin_awesome_v6_skew`.
- Δ≪0.01 (same class as Tok×awesome) → killed R2f waiter **122165** first, then stub `r2f_alpha_decision.json` (hr=0) + `WEAK_SKIP_NO_N80` done stamp.
- R2d n80 still gathering (~32/80; sim 121110); R2e waiter 104742 intact; engines 200@65536 untouched.
- Artifacts: `artifacts/r2f_kevin_awesome_merge_alpha_meta.json`, `r2f_premerge.done`, `r2f_alpha_decision.json`.
- Next: harvest R2d; if below 1.5× → R2e Talent×awesome (Δ=0.626) only.

## p1897 — R2f kevin×awesome CPU premerge + waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,892.
- R2d still gathering (~15/80); R2e waiter 104742 intact; evals index max still chal-00439 (no new DL parent).
- Wrote+synced `launch_r2f_kevin_awesome_premerge.sh` (W_KEVIN=0.25 W_AWESOME=0.75, kevin layout donor) → `/root/r2_out/alpha_kevin_awesome_v6_skew`.
- Premerge **RUNNING** pid **122164** (blend started 22:27:53Z).
- Wrote+synced+armed `launch_r2f_merge_reload_sim.sh` pid **122165** (wait R2e decision then chall reload+n80).
- Pre-reg: submit only if headroom ≥ 1.5×(3·SE).
- Next: harvest R2d decision; chain R2e→R2f if below bar.

## p1896 — near-miss rescan while R2d n80 gathers
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$123,903.
- R2d pure awesome-v6 n80 **RUNNING** (~7/80 @22:25Z; sim pid 121110; decision pending). R2e waiter 104742 still waiting.
- Recomputed per-turn mean Reason for chal≥405 vs Tok; new since p1890:
  - chal-00438 `aurora1001/…-prince` hr≈**0.17×** · **gated 403**
  - chal-00439 `darius3th/…-u2tgykt2` hr≈**−1.79×** · downloadable (not a parent)
- Best downloadable Reason+ unchanged: `0pentensor/…-awesome-v6` hr≈**0.92×** (chal-00425).
- Artifact: `artifacts/reason_nearmiss_p1896.json`.
- Next: harvest `r2d_awesome_decision.json`; if below 1.5× → R2e.

## p1892 — R2e Talent×awesome skew PREMERGE DONE + n80 waiter
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,026.
- R1c still ~105/132 — no decision; Tok×awesome Δ≪0.01 so armed non-Tok parent mix while GPU chain waits.
- Wrote+synced `launch_r2e_talent_awesome_premerge.sh` (W_TALENT=0.25 W_AWESOME=0.75, Talent layout donor) → `/root/r2_out/alpha_talent_awesome_v6_skew`.
- Premerge **OK** 21:27:04Z · max_abs_delta=**0.6258** · n_keys=1026 · identical_frac=0.452 · 66 GiB.
- Wrote+synced+armed `launch_r2e_merge_reload_sim.sh` pid **104742** (past premerge → wait-r2d-lane).
- Prior chain untouched (R1c/R2/R2b/R2c/R2d ALIVE). Engines 200@65536.
- Pre-reg: submit only if headroom ≥ 1.5×(3·SE).
- Next: harvest R1c; if weak → R2→…→R2d→**R2e**.

## p1891 — R2d pure awesome-v6 n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,049.
- R1c still ~88/132 — no decision; equal-α/skew Tok×awesome barely leave Tok (Δ≈0.006–0.009).
- Wrote+synced `launch_r2d_awesome_reload_sim.sh`: materialize `/root/r2_out/awesome_v6_chall` from HF snap `f479a24d…` (+ derived preprocessor) → wait R2c below bar → chall:8002 reload → n80 → `r2d_awesome_decision.json`.
- Armed pid **104051** (log `/root/logs/r2d_awesome_reload.log`). Prior chain untouched (R1c/R2/R2b/R2c ALIVE).
- Pre-reg: submit only if headroom ≥ 1.5×(3·SE).
- Next: harvest R1c; if weak → R2→R2b→R2c→**R2d pure awesome** n80.

## p1890 — R2c skew PREMERGE DONE
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,060.
- Harvested `/root/logs/r2c_premerge.done`: **OK** 21:12:32Z · w_tok=0.25 w_awesome=0.75 · max_abs_delta=**0.008987** · n_keys=1026 · identical_frac=0.452 · 70 GiB @ `/root/r2_out/alpha_tok_awesome_v6_skew`.
- R2c n80 waiter **102560** past premerge → wait-r2b-lane (needs R2b decision + lane free).
- R1c still ~84/132 (no decision yet); engines 200@65536 untouched.
- Incremental chal≥436 Reason scan: chal-00437 syntaxs0cerer hr≈−0.13× (downloadable, not a parent); 00438/00439 pairing incomplete / negative — **awesome-v6 still best downloadable Reason+**.
- Artifacts: `artifacts/r2c_skew_merge_alpha_meta.json`, `r2c_premerge.done`, `reason_nearmiss_p1890.json`.
- Next: harvest R1c; if weak → R2→R2b→R2c skew n80.

## p1889 — R2c skew Tok×awesome premerge + n80 waiter
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,071.
- R1c still ~76/132 — no decision; R2b equal-α Δ≈0.006 is almost Tok → arm stronger pull.
- Wrote+synced `launch_r2c_tok_awesome_skew_premerge.sh` (W_TOK=0.25 W_AWESOME=0.75 → `/root/r2_out/alpha_tok_awesome_v6_skew`) pid **102471**.
- Wrote+synced `launch_r2c_merge_reload_sim.sh` pid **102560** (waits R2b below bar → chall reload → n80 → `r2c_alpha_decision.json`).
- Stamped failed af16/aurora prefetch DONE (n_ok=0 gated) so next pass does not re-chase.
- Pre-reg: submit only if headroom ≥ 1.5×(3·SE); refuse if max_abs_delta==0.
- Next: harvest R1c; if weak → R2 → R2b → R2c skew n80.

## p1888 — R2b premerge DONE + vs-Tok near-miss access scan
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,082.
- R1c still ~73/132 — no decision; harvested R2b CPU premerge instead.
- `/root/logs/r2b_premerge.done`: **OK** 21:02:18Z · max_abs_delta=**0.005997** · n_keys=1026 · identical_frac≈0.45 · 66 GiB @ `/root/r2_out/alpha_tok_awesome_v6`.
- R2b n80 waiter **101161** past premerge → **wait-r2-lane** (r1c_dec=n).
- Recomputed pure Reason for all evals with `request.king_repo==Tok af10`; probed weight download:
  - Best / only downloadable Reason+: **awesome-v6** hr≈0.92× (already in R2b).
  - Gated 403: diane cool/new, nvidia, Tok af16/af8, aurora (API 200 ≠ weights).
- Artifacts: `artifacts/reason_nearmiss_p1888.json`, `reason_vs_tok_p1888.json`.
- Next: harvest R1c; if weak → R2 α n80 then R2b n80.

## p1887 — nearmiss DONE unblocked + R2b n80 waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,094.
- Prefetch pid 99742 **died** after awesome-v6 OK: `diane613/…-cool` **GatedRepoError 403** → no `r2_prefetch_nearmiss.done` → R2b stuck.
- Patched `launch_prefetch_nearmiss.sh` (optional parents non-fatal); stamped DONE (awesome-only); R2b **100240** resumed α-merge shard1.
- Wrote+synced+armed `launch_r2b_merge_reload_sim.sh` pid **101161** → waits `r2b_premerge.done` + R2 lane → chall:8002 reload → n80 → `r2b_alpha_decision.json`.
- R1c ~61/132; engines 200@65536 untouched.
- Next: harvest R1c; if weak → R2 α n80 then R2b n80.

## p1886 — R2b Tok×awesome CPU premerge armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,105.
- R1c still ~56/132 — no decision yet; used idle CPU lane.
- Wrote+synced `launch_r2b_tok_awesome_premerge.sh`: wait `r2_prefetch_nearmiss.done` → equal-α Tok×awesome-v6 → `/root/r2_out/alpha_tok_awesome_v6` + `r2b_premerge.done`.
- Armed pid **100240** (log `/root/logs/r2b_premerge.log`). Prefetch still on awesome-v6 (~26 GiB, 10/11 files).
- Pre-reg: later n80 submit only if headroom ≥ 1.5×(3·SE); refuse if `max_abs_delta==0`.
- Next: harvest R1c; if weak → R2 α n80 then R2b reload+n80 after premerge stamp.

## p1885 — pure-Reason near-miss recompute + prefetch
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,105.
- R1c still training (~52/132); decision not ready — used idle CPU/network.
- Recomputed paired Reason from public duel `lpC_yc_za−lpC_yc_e` (ignore S\* pub margins):
  - **chal-00425** `0pentensor/…-awesome-v6@f479a24d` — pub m=+0.0174 → **Reason m=+0.0108 z=+2.75 hr≈0.92×**.
  - chal-00415 diane-cool — Reason m=+0.0106 z=+1.92 hr≈0.64×.
  - chal-00436 (Reason formula stamp) tojointhecommunity — m=+0.0067 z=+1.36.
- Launched `launch_prefetch_nearmiss.sh` pid **99742** → `/root/logs/r2_prefetch_nearmiss.log`.
- Artifact: `artifacts/reason_nearmiss_p1885.json`.
- Next: harvest R1c decision; if weak → R2 α→n80 then fuse 0pentensor parent.

## p1884 — R2 lane-free gate: pgrep → pidfile
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,116.
- R1c train ~47/132 (pid96239); R1c merge waiter 97305; engines 200@65536.
- Proved `pgrep -af 'train_lora.py|merge_lora.py|launch_r1c_merge'` matches SSH diagnostics (false-positive busy) — would stall α→n80 after R1c decision.
- Patched `launch_r2_merge_reload_sim.sh` → `/root/logs/r1c_train.pid` + `r1c_merge_reload.pid` + `kill -0`.
- Synced; killed old waiter **85408** by PID; relaunched **99246** (premerge reused).
- Next: harvest `r1c_lora_decision.json`; if below bar, R2 α→n80 proceeds without pgrep stall.

## p1876 — premerge harvested (READY for α→n80)
- Contract `weight_version_key=3`; king Tok af10; engines **200/200/200** @65536; burn$64/h; bal~$124,328.
- `/root/logs/r2_premerge.done`: `OK 2026-08-10T18:47:53Z max_abs_delta=0.27734375 n_keys=1026`.
- Artifact `/root/r2_out/alpha_tok_talent_kevin`: 2×33 GiB shards + index + multimodal sidecars; meta confirms distinct from Tok.
- R2 α waiter pid **85408** still on wait-r1-lane (r1b/r1c decisions absent) — will reuse premerge (no re-blend).
- R1b train **~93/126** loss~0.33; waiters 80760/83033 alive. ETA train ~0.35h then merge+n80.
- Next: harvest R1b decision; Stage-5 only if headroom ≥ 1.5×; else R1c then R2 α n80.

## p1875 — premerge healthy + meta stamp fix
- Contract `subnet.weight_version_key=3`; king Tok af10; burn$64/h; bal~$124,395.
- Prefetch **DONE** @18:42Z (TalentPigs+kevin). R1b ~**48/126**; lane pids untouched.
- α-merge running: wrote `model-00001-of-00002.safetensors` (**33 GiB**); blending shard2 (598 keys).
- Bugfix: `launch_r2_premerge.sh` looked for `merge_meta.json`; actual file is `merge_alpha_meta.json`. Patched local+pod; armed `fix_premerge_stamp.sh` pid **86376**.
- Next: harvest `r2_premerge.done` (with max_abs_delta) then R1b/R1c/R2 decisions.

## p1874 — CPU premerge overlapped with R1b
- Contract `weight_version_key=3`; king Tok af10; engines 200@65536; burn$64/h.
- R1b ~**42/126**; R1 lane pids untouched (79866/80760/83033).
- Added `launch_r2_premerge.sh`: waits prefetch → equal-α blend → `/root/logs/r2_premerge.done`.
- Patched `launch_r2_merge_reload_sim.sh` to **reuse** premerge (skip re-blend).
- Killed old waiter 84752 by PID; armed premerge pid **85406** + waiter pid **85408**.
- Prefetch: TalentPigs OK; kevin shard1 ~**28 GiB** incomplete (still downloading).
- Next: harvest R1b/R1c/R2 decisions; Stage-5 only if headroom ≥ 1.5×.

## p1873 — α-merge recipe staged + waiter armed
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,407.
- R1b still **~37/126**; R1b waiter+R1c chain still armed; engines 200@65536.
- Wrote `merge_alpha.py` (CPU equal-α Tok:Talent:Kevin) + `launch_r2_merge_reload_sim.sh`.
- Armed waiter pid **84752** (log `/root/logs/r2_merge_reload.log`).
- Prefetch still running: TalentPigs ~**66 GiB** / 23/25 files; kevin not started yet.
- Decision artifacts (when ready): `/root/affine_data/r2_alpha_reason_sim.json`, `r2_alpha_decision.json`.
- Next: harvest R1b/R1c/R2 decisions; Stage-5 only if headroom ≥ 1.5×.

## p1872 — parent prefetch launched (CPU only)
- Started `launch_prefetch_parents.sh` pid **83501**:
  - TalentPigs/affine-5ekxlcg3fx-abc@dbfbb3e2…
  - kevin954/Affine-5dfqbbh8ev-sft@6a5815fa…
- Log `/root/logs/r2_prefetch_parents.log`; done stamp `/root/logs/r2_prefetch_parents.done`.
