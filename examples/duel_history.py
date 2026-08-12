"""Walk recent duel verdicts and inspect one duel's per-turn score series.

A challenger is crowned when the paired mean advantage over the king exceeds
max(k_sigma * SE, min_margin); /duels/{id}/series exposes the per-turn scores
behind that decision so any verdict can be recomputed offline.

Usage: python examples/duel_history.py
"""

import requests

BASE = "https://www.affine.io/api/v1"


def main() -> None:
    history = requests.get(f"{BASE}/history", timeout=30).json()
    verdicts = [item for item in history["items"] if item["event"] == "verdict"]

    print(f"{len(verdicts)} verdicts in the latest page:")
    for v in verdicts[:10]:
        outcome = "CROWNED" if v.get("challenger_wins") else "rejected"
        # Intake-stage rejections never reach a duel: margin/z/turns are null.
        if v.get("margin") is None:
            reason = v.get("rejection_reason") or v.get("error_code") or "intake"
            print(f"  {v['challenge_id']}  {v['repo'][:44]:44s}  {outcome} ({reason})")
            continue
        print(
            f"  {v['challenge_id']}  {v['repo'][:44]:44s}  {outcome}"
            f"  margin={v['margin']:+.5f}  z={v['z']:+.2f}"
            f"  turns={v['n_paired_turns']}"
        )

    if not verdicts:
        return

    duel_id = verdicts[0]["challenge_id"]
    detail = requests.get(f"{BASE}/duels/{duel_id}", timeout=30).json()
    series = requests.get(f"{BASE}/duels/{duel_id}/series", timeout=30).json()
    print(f"\nDuel {duel_id}: detail keys {sorted(detail)[:8]}")
    print(f"Series payload keys: {sorted(series)[:8]}")


if __name__ == "__main__":
    main()
