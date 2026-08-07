#!/usr/bin/env bash
# B300 = SM 10.3. In cutlass Arch, sm_110f is aliased to sm_101f, so
# flash_fwd_sm100's assert `sm_100 <= arch <= sm_110f` rejects sm_103 and
# every vLLM engine dies at profile_run with:
#   AssertionError: Only SM 10.x and 11.x are supported
# Widen the upper bound to sm_121f. Idempotent. Run on the pod after venv install.
set -euo pipefail
FA="${1:-/root/venv/lib/python3.12/site-packages/vllm/vllm_flash_attn/cute/flash_fwd_sm100.py}"
test -f "$FA"
if grep -q 'pass170 patch for B300 sm_103' "$FA"; then
  echo "[patch-b300] already patched: $FA"
  exit 0
fi
cp -a "$FA" "${FA}.bak-b300-sm103"
python3 - "$FA" <<'PY'
from pathlib import Path
import sys
p = Path(sys.argv[1])
t = p.read_text()
old = 'assert self.arch >= Arch.sm_100 and self.arch <= Arch.sm_110f, "Only SM 10.x and 11.x are supported"'
new = 'assert self.arch >= Arch.sm_100 and self.arch <= Arch.sm_121f, "Only SM 10.x/11.x/12.x are supported (pass170 patch for B300 sm_103)"'
if old not in t:
    raise SystemExit(f"assert line not found in {p}")
p.write_text(t.replace(old, new, 1))
print(f"[patch-b300] patched {p}")
PY
