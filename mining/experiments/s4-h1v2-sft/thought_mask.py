"""Thought-only completion cut for H1v2 SFT.

Canonical harvest completion (see s4-h1-sft/harvest_refs.py):

  </think>
  THOUGHT: {z}

  ```bash
  ...
  ```

Loss should cover tokens through the thought body and mask from the first
bash fence onward (action `y_C`), so we do not rewrite the king's action
calibration that carries clipped L1lift.
"""
from __future__ import annotations

import re

# Prefer the double-newline form produced by completion_from_zy.
FENCE_PRIMARY = "\n\n```bash"
FENCE_RE = re.compile(r"\n\n```bash|\n```bash|```bash")


def thought_cut_char(completion: str) -> int | None:
    """Return char index in `completion` where action/fence begins, or None."""
    i = completion.find(FENCE_PRIMARY)
    if i >= 0:
        return i
    m = FENCE_RE.search(completion)
    return m.start() if m else None


def thought_only_completion(completion: str) -> str | None:
    """Prefix of completion kept under thought-only loss (no fence/action)."""
    cut = thought_cut_char(completion)
    if cut is None:
        return None
    return completion[:cut]
