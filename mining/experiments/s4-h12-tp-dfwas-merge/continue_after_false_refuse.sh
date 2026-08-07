#!/usr/bin/env bash
# H12 merge wrote good weights then false-refused (first-8-key Δ sample = 0
# while mid-layer max|A−O|≈0.21). Do NOT re-merge; verify → serve → n80.
set -euo pipefail

LOG=/root/logs/h12_continue.nohup
mkdir -p /root/logs /root/affine_data
exec >>"$LOG" 2>&1

echo "[h12-cont] $(date -u +%Y-%m-%dT%H:%M:%SZ) START false-refuse recovery"

if [[ -f /root/mine.env ]]; then
  set -a
  # shellcheck disable=SC1091
  source /root/mine.env
  set +a
fi
# shellcheck disable=SC1091
source /root/venv/bin/activate
export HF_HOME=${HF_HOME:-/root/hf}
export PYTHONPATH=/root/mining_src/affine_pkg${PYTHONPATH:+:$PYTHONPATH}
export PATH="$HOME/.local/bin:$PATH"

A=/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
OUT=/root/merges/h12-tp75
test -d "$OUT"
test -f "$OUT/config.json"

python - <<'PY'
import json
from pathlib import Path
import safetensors.torch as st

A = Path("/root/hf/hub/models--TalentPigs--affine-5ekxlcg3fx-abc/snapshots/dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4")
OUT = Path("/root/merges/h12-tp75")
sn = "model-00008-of-00016.safetensors"
ta = st.load_file(str(A / sn), device="cpu")
to = st.load_file(str(OUT / sn), device="cpu")
keys = [k for k in sorted(set(ta) & set(to)) if "embed" not in k.lower()][:8]
max_ao = 0.0
for k in keys:
    d = (ta[k].float() - to[k].float()).abs().max().item()
    max_ao = max(max_ao, d)
    print(f"[h12-cont] {k}: max|A-O|={d:.6g}", flush=True)
if max_ao < 1e-4:
    raise SystemExit(f"REFUSE: mid-shard still ~identical max|A-O|={max_ao}")
meta = {
    "out": str(OUT),
    "alpha": 0.75,
    "b_repo": "bluecolor777/plmk",
    "b_rev": "b2cc7b9fb35232c6611254cd6f465a91f590469c",
    "probe_shard": sn,
    "max_abs_delta_mid_probe": max_ao,
    "first_1MiB_identical": True,
    "note": "false-refuse recovery: first-8-key sample was 0; mid-layer Δ proves non-identical",
    "false_positive_first8_gate": True,
}
(OUT / "merge_meta.json").write_text(json.dumps(meta, indent=2))
Path("/root/affine_data/h12_merge_meta.json").write_text(json.dumps(meta, indent=2))
print("[h12-cont] OK_NON_IDENTICAL", json.dumps(meta), flush=True)
PY

date -u +%Y-%m-%dT%H:%M:%SZ > /root/logs/h12_merge.done
echo "[h12-cont] wrote h12_merge.done"

export TEACHER_REPO=zai-org/GLM-4.5-Air-FP8
export TEACHER_REV=
export KING_REPO=TalentPigs/affine-5ekxlcg3fx-abc
export KING_REV=dbfbb3e2a17c7603e7fc68a3a15b343f42dfdef4
export CHALL_REPO=/root/merges/h12-tp75
export CHALL_REV=
bash /root/mining_src/s3-duel-sim/serve_three.sh
echo "[h12-cont] serve_three launched"

bash /root/mining_src/s4-h12-tp-dfwas-merge/start_h12_n80.sh
echo "[h12-cont] $(date -u +%Y-%m-%dT%H:%M:%SZ) n80 pipeline finished"
