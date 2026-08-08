# Pass 279 — retarget H70 n80 to new live king

## Fact
Live king changed @ 2026-08-08T09:49:00Z (reign 4):
- **was** `TalentPigs/affine-5ekxlcg3fx-abc` @ `dbfbb3e2…` S≈0.0315
- **now** `Tok331102/affine-5EqYW8McUc-af10` @ `eb8bf9a356a254f71faaa439e8abc3cfba572c53` **S=0.04456**

## Action
H70 train finished (step 26/26, loss≈0.453, ~687s). Merge LoRA in progress.
Launched `retarget_king_pass279.sh` (pid recorded on pod):
1. Patch KING defaults in `retry_h70_n80.sh` / `post_train_pipeline.sh` / `prewarm_engines.sh`
2. `snapshot_download` new king (in flight @~14G during pass)
3. Wait `chall_serve.done`, kill any early n80, swap `:8001` → Tok331102, wait promptable

Relaunched `watch_n80_retry` after accidental kill (awk matched watcher argv containing retry path).

## Decision rule for next passes
- H70 n80 must report margin vs **Tok331102** (submit-relevant).
- H66–H69 mid-n80 vs TalentPigs: finish for ranking only; winners need re-sim vs Tok before submit.
