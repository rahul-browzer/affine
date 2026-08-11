# R3 — Reason GRPO results

## p2056 — parallel_dl overlap pip

- **Action:** while `uv pip` still installing, spun `/root/dl_venv` + nohup `parallel_dl` (pid2246) for Tok af10 + GLM teacher into `HF_HOME=/root/hf`
- Patched `bootstrap_r3.sh` to wait on `/root/logs/{tok_init,teacher}.done` / `parallel_dl.pid` instead of always re-downloading
- At 16:37Z: pip VERSIONS ok; HF cache ~1.7G; tok fetch 9/11 files; no free 8×B300
- **Check:** `tail -f /root/logs/parallel_dl.log` then `bootstrap_r3.log` for stamps → teacher → train

## p2055 — bootstrap launched

- **Pod:** `mine-r3-grpo-1` / golden-hawk-ff / 8×B300 @$64/h
- **SSH:** `root@204.9.206.245 -p 40051`
- **Action:** uploaded mining_src + mine.env + 406-row data; `bootstrap_r3.sh` nohup pid=1313
- **Train knobs (armed):** Tok af10 init, LoRA r=16, lr=5e-6, **G=4**, max_new=512, max_steps=200, GPUs 6–7
- **Reward:** Reason = lpC(y\|z) − lpC(y\|∅) via live teacher :8000
- **Post-train:** `post_train_pipeline.sh` armed (merge→chall→n80 vs Tok)
- **HF:** `unconst/Affine-5czsc2fc98-r3-lora` + `-r3-merged` created
- **Check:** `tail -f /root/logs/bootstrap_r3.log` → expect flash patch → DL → teacher → `[r3] TRAIN_LAUNCHED`
- **Market:** 0× 8×B300 available; burn still $116.25/h vs $833/h floor

## p2054 — rented mine-r3-grpo-1 (8×B300)

- Last free 8×B300 @ $64/h TTL 24h
- Axis: R3 GRPO/REINFORCE on Reason (not another R2 board parent)
- Fleet after rent: mine-crown-1 B200 $52.25 + mine-r3-grpo-1 B300 $64 = **$116.25/h**
