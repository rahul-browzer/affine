"""Inspect Corpus D — the public training corpus every duel draws from.

The /dataset endpoints serve statistics and a paginated turn index; bulk
trajectory data lives on Hippius S3 under the corpus_base_url advertised by
/contract (turns/manifest.json, parquet turn index, gzipped JSONL chunks).

Usage: python examples/corpus_stats.py
"""

import requests

BASE = "https://www.affine.io/api/v1"


def main() -> None:
    stats = requests.get(f"{BASE}/dataset", timeout=30).json()
    print(
        f"Corpus epoch {stats['corpus_epoch']} (schema v{stats['schema_version']}): "
        f"{stats['n_turns']:,} turns across {stats['n_trajectories']:,} trajectories "
        f"in {stats['n_chunks']} chunks"
    )
    print(f"Manifest sha256: {stats['manifest_sha256']}")
    for dimension, mix in stats["mix"].items():
        top = sorted(mix.items(), key=lambda kv: kv[1], reverse=True)[:5]
        print(f"  {dimension}: " + ", ".join(f"{k}={v}" for k, v in top))

    page = requests.get(f"{BASE}/dataset/turns", params={"limit": 5}, timeout=30).json()
    print(f"\nTurn index page keys: {sorted(page)}")

    contract = requests.get(f"{BASE}/contract", timeout=30).json()
    dataset = contract["dataset"]
    print(f"Bulk data: {dataset['corpus_base_url']}/{dataset['manifest_key']}")


if __name__ == "__main__":
    main()
