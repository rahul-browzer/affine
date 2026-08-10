# R2 — multi-king merge aimed at Reason

## Claim
Weight-space mix of high-Reason reign parents (TalentPigs + kevin954 ± Tok) beats single-king LoRA SFT on paired Reason margin vs live Tok af10.

## Why now
R1 LoRA@8192 was noise (+0.0005). R1b/R1c are still Tok-init SFT variants. Prefetch parents while R1b occupies GPUs 6–7 so merge can start as soon as the R1 lane resolves below the 1.5× bar.

## Parents (pinned)
| repo | revision | role |
|---|---|---|
| Tok331102/affine-5EqYW8McUc-af10 | eb8bf9a356a2… | live king (already cached) |
| TalentPigs/affine-5ekxlcg3fx-abc | dbfbb3e2a17c… | reign 3 |
| kevin954/Affine-5dfqbbh8ev-sft | 6a5815fad8f4… | reign 2 |

## Recipe (pre-registered)
- Equal α: Tok:TalentPigs:kevin = **1:1:1** (`merge_alpha.py`).
- Tok = layout/config donor (multimodal `config.json` + processor sidecars).
- Exit 3 if blend is weight-identical to Tok.
- Then reload chall:8002 @65536 → n80 vs Tok; bar = **1.5 × (3·SE)**.

## Decision rule (pre-register)
n80 paired Reason margin vs Tok af10; submit only if margin ≥ **1.5 × (3·SE)** on a fresh slice. Refuse weight-identical to Tok.

## Scripts
- `launch_prefetch_parents.sh` — CPU/network download.
- `merge_alpha.py` — CPU safetensors blend.
- `launch_r2_merge_reload_sim.sh` — wait prefetch + R1 lane → merge → chall reload → n80 → `r2_alpha_decision.json`.
