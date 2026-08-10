# R2 result log

## p1872 — parent prefetch launched (CPU only)
- Contract `weight_version_key=3`; king Tok af10; fleet=1 @$64/h; bal~$124,418.
- R1b still training **~32/126**; waiter+chain armed; engines 200@65536.
- Started `launch_prefetch_parents.sh` pid **83501**:
  - TalentPigs/affine-5ekxlcg3fx-abc@dbfbb3e2…
  - kevin954/Affine-5dfqbbh8ev-sft@6a5815fa…
- Log `/root/logs/r2_prefetch_parents.log`; done stamp `/root/logs/r2_prefetch_parents.done`.
- Hub cache already showing `models--TalentPigs--affine-5ekxlcg3fx-abc` mid-fetch.
- Next: wait prefetch.done; after R1 lane frees GPUs 6–7, stage α-merge + n80 vs Tok.
