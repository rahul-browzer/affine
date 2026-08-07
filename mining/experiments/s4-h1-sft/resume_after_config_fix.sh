#!/usr/bin/env bash
# Resume H1 after CausalLM-merge wrote text-only config.json (vLLM crash).
# Weights already on disk and differ from kevin; restore wrapper config from
# base, patch HF salvage configs, re-serve chall → n40 → n80.
set -euo pipefail

# shellcheck disable=SC1091
source /root/venv/bin/activate
if [[ -f /root/mine.env ]]; then
  # shellcheck disable=SC1091
  source /root/mine.env
fi

export HF_HOME=/root/hf
export PYTHONPATH=/root/mining_src/affine_pkg:/root/mining_src:${PYTHONPATH:-}

MERGED=/root/h1/merged
BASE=/root/hf/hub/models--kevin954--Affine-5dfqbbh8ev-sft/snapshots/6a5815fad8f4e34c983b1933c1fae5762fe25220
SIM_OUT=/root/affine_data/h1_sim_result.json
SIM_N40=/root/affine_data/h1_sim_result_n40.json
MARKER=/root/logs/h1_pipeline.done
CFG_META=/root/affine_data/h1_config_fix.json
HF_REPO=${HF_REPO:-unconst/Affine-5czsc2fc98-h1-merged}

log() { echo "[h1-cfgfix] $(date -u +%Y-%m-%dT%H:%M:%SZ) $*"; }

if [[ -f "$MARKER" ]]; then
  log "already done ($(cat "$MARKER")); exit"
  exit 0
fi
if [[ ! -f "$MERGED/model-00001-of-00002.safetensors" ]]; then
  log "ERROR: merged weights missing at $MERGED"
  exit 1
fi
if [[ ! -f "$BASE/config.json" ]]; then
  log "ERROR: base snapshot missing at $BASE"
  exit 1
fi

log "restore multimodal wrapper config + visual shard from kevin base"
python3 - <<PY
import json, shutil, time
from pathlib import Path

base = Path("$BASE")
merged = Path("$MERGED")
restored = []
for name in (
    "config.json",
    "preprocessor_config.json",
    "video_preprocessor_config.json",
):
    src = base / name
    dst = merged / name
    if not src.is_file():
        raise SystemExit(f"missing base file {src}")
    shutil.copy2(src, dst)
    restored.append(name)

# CausalLM save dropped model.visual.* (model-visual-extra.safetensors).
visual_added_keys = 0
for src in sorted(base.glob("model-visual*.safetensors")):
    shutil.copy2(src, merged / src.name)
    restored.append(src.name)
bi = json.loads((base / "model.safetensors.index.json").read_text())
mi = json.loads((merged / "model.safetensors.index.json").read_text())
for key, shard in bi["weight_map"].items():
    if key not in mi["weight_map"]:
        mi["weight_map"][key] = shard
        visual_added_keys += 1
total = sum(p.stat().st_size for p in merged.glob("*.safetensors"))
mi.setdefault("metadata", {})
mi["metadata"]["total_size"] = total
if "total_parameters" in bi.get("metadata", {}):
    mi["metadata"]["total_parameters"] = bi["metadata"]["total_parameters"]
(merged / "model.safetensors.index.json").write_text(json.dumps(mi, indent=2) + "\n")
restored.append("model.safetensors.index.json")

cfg = json.loads((merged / "config.json").read_text())
if "auto_map" in cfg:
    del cfg["auto_map"]
    (merged / "config.json").write_text(json.dumps(cfg, indent=2) + "\n")
assert cfg.get("model_type") == "qwen3_5_moe", cfg.get("model_type")
assert cfg.get("architectures") == ["Qwen3_5MoeForConditionalGeneration"], cfg.get(
    "architectures"
)
assert "text_config" in cfg and "vision_config" in cfg
assert (merged / "model-visual-extra.safetensors").is_file()
assert len(mi["weight_map"]) == len(bi["weight_map"]), (
    len(mi["weight_map"]),
    len(bi["weight_map"]),
)

meta = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "merged": str(merged),
    "base": str(base),
    "restored": restored,
    "visual_added_keys": visual_added_keys,
    "model_type": cfg.get("model_type"),
    "architectures": cfg.get("architectures"),
    "bug": "AutoModelForCausalLM.save_pretrained wrote qwen3_5_moe_text and "
    "omitted model.visual.*; vLLM needs wrapper config + visual shard",
    "prior_bad_hf_commit": "da940fd917f293098679f49f6cb9c5a0ce6277d2",
}
Path("$CFG_META").parent.mkdir(parents=True, exist_ok=True)
Path("$CFG_META").write_text(json.dumps(meta, indent=2) + "\n")
Path("/root/affine_data/h1_visual_shard_fix.json").write_text(
    json.dumps(
        {
            "utc": meta["utc"],
            "added_weight_keys": visual_added_keys,
            "visual_shard_bytes": (merged / "model-visual-extra.safetensors").stat().st_size,
            "merged_nkeys": len(mi["weight_map"]),
            "base_nkeys": len(bi["weight_map"]),
        },
        indent=2,
    )
    + "\n"
)
print(json.dumps(meta, indent=2))
PY

if [[ -n "${HF_TOKEN:-}" ]]; then
  log "patch HF salvage (config + visual shard + index) on $HF_REPO"
  python3 - <<PY
import json, os, time
from pathlib import Path
from huggingface_hub import HfApi

api = HfApi(token=os.environ["HF_TOKEN"])
repo = "$HF_REPO"
merged = Path("$MERGED")
files = [
    "config.json",
    "preprocessor_config.json",
    "video_preprocessor_config.json",
    "model.safetensors.index.json",
    "model-visual-extra.safetensors",
]
for name in files:
    path = merged / name
    if not path.is_file():
        raise SystemExit(f"missing {path}")
    api.upload_file(
        path_or_fileobj=str(path),
        path_in_repo=name,
        repo_id=repo,
        repo_type="model",
        commit_message=f"fix {name}: restore wrapper config + visual shard",
    )
    print(f"[hf-patch] uploaded {name}", flush=True)
info = api.repo_info(repo, repo_type="model")
sha = getattr(info, "sha", None) or getattr(info, "revision", None)
out = {
    "utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
    "repo": repo,
    "commit_sha": sha,
    "patched_files": files,
    "note": "config+visual patch after CausalLM save omitted vision tower",
}
Path("/root/affine_data/h1_merged_config_patch.json").write_text(
    json.dumps(out, indent=2) + "\n"
)
print(json.dumps(out, indent=2), flush=True)
PY
else
  log "WARN: HF_TOKEN unset; skipping HF config patch"
fi

log "re-serve chall=$MERGED (king+teacher kept)"
RESTART_KING=0 MERGE="$MERGED" bash /root/mining_src/s4-h2-merge/restart_for_h2.sh
log "serve READY"

TTL_DEADLINE_EPOCH=$(date -u -d '2026-08-07T06:50:00Z' +%s 2>/dev/null || echo 0)

log "launch sim n=40 → $SIM_N40"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_N40" \
  --hotkey local-h1-sim-n40 \
  --n-turns 40 \
  --progress-out /root/affine_data/h1_sim_progress_n40.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1
log "SIM_N40_DONE → $SIM_N40"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim_n40.done

now_epoch=$(date -u +%s)
if [[ "$TTL_DEADLINE_EPOCH" =~ ^[0-9]+$ ]] && (( TTL_DEADLINE_EPOCH > 0 )); then
  remain=$(( TTL_DEADLINE_EPOCH - now_epoch ))
else
  remain=99999
fi

if (( remain < 3000 )); then
  log "WARN: only ${remain}s to soft TTL deadline; skipping full n=80"
  {
    date -u +%Y-%m-%dT%H:%M:%SZ
    echo "n40_only remain_s=$remain resume_after_config_fix"
  } >"$MARKER"
  exit 0
fi

log "launch sim n=80 → $SIM_OUT (${remain}s to soft deadline)"
python /root/mining_src/s4-h2-merge/run_sim_duel.py \
  --chall-repo "$MERGED" \
  --out "$SIM_OUT" \
  --hotkey local-h1-sim \
  --n-turns 80 \
  --progress-out /root/affine_data/h1_sim_progress.json \
  --save-artifact \
  >>/root/logs/h1_sim.nohup 2>&1

date -u +%Y-%m-%dT%H:%M:%SZ >"$MARKER"
log "SIM_DONE → $SIM_OUT"
date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h1_sim.done
log "RESUME_CONFIG_FIX_PIPELINE_DONE"
