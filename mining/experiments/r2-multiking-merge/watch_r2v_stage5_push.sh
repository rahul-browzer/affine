#!/usr/bin/env bash
# When bridge_r2v_to_r2l stamps r2v_stage5_ready.json (local pure-sft3 n80
# headroom ≥ 1.5×), purge old public HF merges if needed and upload the local
# sft3 chall dir to unconst/Affine-5czsc2fc98-r2v-sft3 (public).
# Does NOT register a hotkey and does NOT submit — next Ralph pass does
# submit.py --check + fresh hotkey after verifying the decision numbers.
# Never touches teacher/king/chall engines.
set -euo pipefail
LOG=/root/logs/watch_r2v_stage5_push.log
DONE=/root/logs/watch_r2v_stage5_push.done
PIDF=/root/logs/watch_r2v_stage5_push.pid
STAGE5=${STAGE5:-/root/affine_data/r2v_stage5_ready.json}
DEC=${DEC:-/root/affine_data/r2v_sft3_decision.json}
CHALL=${CHALL:-/root/r2_out/sft3_chall}
REPO=${REPO:-unconst/Affine-5czsc2fc98-r2v-sft3}
OUT_META=${OUT_META:-/root/affine_data/r2v_stage5_hf_push.json}
PURGE_META=${PURGE_META:-/root/affine_data/r2v_stage5_hf_purge.json}
HEADROOM_BAR=${HEADROOM_BAR:-1.5}
KEEP_REPOS=${KEEP_REPOS:-unconst/Affine-5czsc2fc98-r1lora,unconst/Affine-5czsc2fc98-r2v-sft3}
mkdir -p /root/logs /root/affine_data
echo $$ >"$PIDF"
exec > >(tee -a "$LOG") 2>&1

echo "[r2v-stage5-push] $(date -u +%Y-%m-%dT%H:%M:%SZ) start"
if [[ -f "$DONE" && -f "$OUT_META" ]]; then
  echo "[r2v-stage5-push] already done: $(cat "$DONE")"
  exit 0
fi

echo "[r2v-stage5-push] waiting for $STAGE5"
for i in $(seq 1 2880); do
  if [[ -f "$STAGE5" ]]; then
    echo "[r2v-stage5-push] STAGE5 present at iter=$i"
    break
  fi
  if (( i % 12 == 0 )); then
    crumb=$(python3 -c "import json;from pathlib import Path;p=Path('/root/affine_data/r2v_sft3_reason_progress.json');
print(p.read_text().strip() if p.is_file() else 'no-progress')" 2>/dev/null || echo none)
    echo "[r2v-stage5-push] wait iter=$i crumb=${crumb:-none}"
  fi
  if (( i == 2880 )); then
    echo "TIMEOUT $(date -u +%Y-%m-%dT%H:%M:%SZ)" | tee "$DONE"
    exit 2
  fi
  sleep 10
done

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
if [[ -z "${HF_TOKEN:-}" ]]; then
  echo "[r2v-stage5-push] FATAL HF_TOKEN missing" >&2
  exit 2
fi

export STAGE5 DEC CHALL REPO OUT_META PURGE_META HEADROOM_BAR KEEP_REPOS
python3 - <<'PY'
import json, os, time
from pathlib import Path

stage = json.loads(Path(os.environ["STAGE5"]).read_text())
dec = json.loads(Path(os.environ["DEC"]).read_text()) if Path(os.environ["DEC"]).is_file() else {}
hr = stage.get("headroom_vs_3se", dec.get("headroom_vs_3se"))
bar = float(os.environ["HEADROOM_BAR"])
if hr is None or float(hr) < bar:
    raise SystemExit(f"FATAL stage5 headroom {hr} < {bar}")

chall = Path(os.environ["CHALL"])
if not (chall / "model.safetensors.index.json").is_file():
    raise SystemExit(f"FATAL chall missing index: {chall}")
if not (chall / "preprocessor_config.json").is_file():
    raise SystemExit("FATAL chall missing preprocessor_config.json")
if not (chall / "config.json").is_file():
    raise SystemExit("FATAL chall missing config.json")
cfg = json.loads((chall / "config.json").read_text())
if "auto_map" in cfg:
    raise SystemExit("FATAL auto_map in config.json")
arch = cfg.get("architectures") or []
if "Qwen3_5MoeForConditionalGeneration" not in arch:
    raise SystemExit(f"FATAL bad architectures {arch}")

shards = []
total = 0
for p in sorted(chall.iterdir()):
    if p.name.endswith(".safetensors"):
        t = p.resolve()
        if not t.is_file():
            raise SystemExit(f"FATAL missing shard {p}")
        shards.append(t)
        total += t.stat().st_size
if total < 20 * (1 << 30):
    raise SystemExit(f"FATAL chall too small ({total} bytes)")

keep = {x.strip() for x in os.environ["KEEP_REPOS"].split(",") if x.strip()}
repo = os.environ["REPO"]
token = os.environ["HF_TOKEN"]
from huggingface_hub import HfApi

api = HfApi(token=token)
# Free public storage: delete largest Affine-5czsc artifacts except keep-list.
# Include fullft/trefsft/etc — not only *-merged (p1949: those alone left ~70G
# fullft repos that still tripped the public storage cap).
deleted = []
errors = []
models = list(api.list_models(author="unconst"))
cands = []
for m in models:
    if not m.id.startswith("unconst/Affine-5czsc2fc98-"):
        continue
    if m.id in keep:
        continue
    try:
        info = api.model_info(m.id, files_metadata=True)
        sz = sum(int(getattr(s, "size", 0) or 0) for s in (info.siblings or []))
    except Exception as e:
        errors.append({"id": m.id, "error": f"info: {e}"})
        continue
    if sz >= int(1e9):
        cands.append((sz, m))
cands.sort(key=lambda x: x[0], reverse=True)
need_gb = total / 1e9 + 5.0
freed = 0
for sz, m in cands:
    if freed / 1e9 >= need_gb:
        break
    try:
        api.delete_repo(m.id, repo_type="model")
        deleted.append({"id": m.id, "bytes": sz})
        freed += sz
        print(f"[r2v-stage5-push] purged {m.id} ({sz/1e9:.1f}G)", flush=True)
    except Exception as e:
        errors.append({"id": m.id, "error": str(e)})
        print(f"[r2v-stage5-push] purge err {m.id}: {e}", flush=True)

Path(os.environ["PURGE_META"]).write_text(
    json.dumps(
        {
            "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
            "need_gb": need_gb,
            "freed_bytes": freed,
            "freed_gb": freed / 1e9,
            "deleted": deleted,
            "errors": errors,
            "keep": sorted(keep),
        },
        indent=2,
    )
    + "\n"
)

readme = chall / "README.md"
if not readme.is_file():
    readme.write_text(
        "---\n"
        "base_model: syntaxsorcerer1/Affine-5gbhwtw4zo-sft3\n"
        "library_name: transformers\n"
        "pipeline_tag: text-generation\n"
        "tags:\n"
        "- affine-r2v-sft3\n"
        "- reason-v3\n"
        "---\n\n"
        "# R2v pure-sft3 challenger (Reason v3)\n\n"
        "Local n80 cleared ≥1.5×(3·SE) vs Tok af10. Pre-submit artifact only.\n"
    )

api.create_repo(repo, private=False, exist_ok=True, repo_type="model")
print(
    f"[r2v-stage5-push] uploading {chall} ({total/(1<<30):.1f} GiB) → {repo} public",
    flush=True,
)
info = api.upload_folder(
    folder_path=str(chall),
    repo_id=repo,
    repo_type="model",
    commit_message="R2v pure-sft3 Stage-5 pre-submit (Reason v3 local n80 ≥1.5×)",
    allow_patterns=[
        "*.safetensors",
        "*.json",
        "*.txt",
        "*.model",
        "tokenizer*",
        "vocab*",
        "merges.txt",
        "special_tokens_map.json",
        "chat_template*",
        "README.md",
        "*.jinja",
    ],
    ignore_patterns=["*.py", "*.bin", "optimizer*", "rng*", "scheduler*", "*_result.json"],
)
meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "repo": repo,
    "private": False,
    "chall": str(chall),
    "bytes": total,
    "n_shards": len(shards),
    "commit_sha": getattr(info, "commit_id", None) or str(info),
    "headroom_vs_3se": float(hr),
    "margin": stage.get("margin", dec.get("margin")),
    "se": stage.get("se", dec.get("se")),
    "source_stage5": os.environ["STAGE5"],
    "source_decision": os.environ["DEC"],
    "action_next": "REGISTER_FRESH_HOTKEY_THEN_submit.py_--check",
    "note": "HF push only — NOT submitted; verify decision then burn a fresh hotkey",
}
Path(os.environ["OUT_META"]).write_text(json.dumps(meta, indent=2) + "\n")
print(json.dumps(meta, indent=2), flush=True)
print("[r2v-stage5-push] DONE", flush=True)
PY

echo "OK $(date -u +%Y-%m-%dT%H:%M:%SZ) pushed $(python3 -c "import json;print(json.load(open('$OUT_META'))['commit_sha'])")" | tee "$DONE"
