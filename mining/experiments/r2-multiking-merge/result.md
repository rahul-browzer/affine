# R2 result log

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
