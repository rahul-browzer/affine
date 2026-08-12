"""Fetch the current Affine competition state: king, phase, queue, stats.

Usage: python examples/fetch_snapshot.py
"""

import requests

BASE = "https://www.affine.io/api/v1"


def main() -> None:
    snap = requests.get(f"{BASE}/snapshot", timeout=30).json()

    king = snap["king"]
    print(f"Phase: {snap['phase']['name']} (since {snap['phase']['since']})")
    print(f"King:  {king['repo']} @ {king['revision'][:8]}")
    print(f"       reign #{king['reign_number']}, crowned {king['crowned_at']}")
    print(f"       hotkey {king['hotkey']}")

    stats = snap["stats"]
    print(
        f"Queue: {stats['duel_queue_len']} pending | lifetime: "
        f"{stats['enqueued_total']} enqueued, {stats['accepted']} accepted, "
        f"{stats['rejected']} rejected, {stats['failed']} failed"
    )

    versions = snap["eval_machine"]["versions"]
    print(f"Eval pod: vllm {versions['vllm']}, transformers {versions['transformers']}")

    market = snap["market"]
    print(
        f"Market: TAO ${market['tao_price_usd']:.2f}, "
        f"registration {market['reg_cost_tao']:.4f} TAO, "
        f"miner emissions {market['miners_tao_per_day']:.2f} TAO/day"
    )


if __name__ == "__main__":
    main()
