#!/usr/bin/env python3
"""Aggregate benchmark results across all datasets and compute summary statistics."""

import re
import os
from collections import defaultdict

DATASETS = [
    "astar", "bzip", "bwaves", "cactusadm", "gems", "lbm",
    "leslie3d", "libq", "mcf", "milc", "omnetpp", "sphinx3", "xalanc",
]

RESULTS_DIR = "results"

METRICS = ["Hit", "Miss", "Total", "Hit Rate", "Cost Ratio", "LRU-normalized Cost Ratio"]


def parse_result_file(filepath: str) -> list:
    """Parse a .res file and extract rows from the PrettyTable."""
    with open(filepath, "r") as f:
        text = f.read()

    header_pattern = re.compile(
        r"\|\s*Name\s*\|\s*Hit\s*\|\s*Miss\s*\|\s*Total\s*\|\s*Hit Rate\s*\|\s*Cost Ratio\s*\|\s*LRU-normalized Cost Ratio\s*\|"
    )
    match = header_pattern.search(text)
    if not match:
        return []

    table_text = text[match.start():]
    row_pattern = re.compile(
        r"\|\s*(.+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*([\d.]+)\s*\|\s*([\d.]+)\s*\|\s*([\d.]+)\s*\|"
    )

    rows = []
    for m in row_pattern.finditer(table_text):
        rows.append({
            "Algorithm": m.group(1).strip(),
            "Hit": int(m.group(2)),
            "Miss": int(m.group(3)),
            "Total": int(m.group(4)),
            "Hit Rate": float(m.group(5)),
            "Cost Ratio": float(m.group(6)),
            "LRU-normalized Cost Ratio": float(m.group(7)),
        })
    return rows


def fmt_table(headers, rows, col_widths=None):
    """Format a list of rows into a pretty ASCII table."""
    if col_widths is None:
        col_widths = [max(len(str(h)), max((len(str(r[i])) for r in rows), default=0)) for i, h in enumerate(headers)]

    def row_str(vals):
        return "| " + " | ".join(str(v).rjust(w) if i > 0 else str(v).ljust(w) for i, (v, w) in enumerate(zip(vals, col_widths))) + " |"

    sep = "+" + "+".join("-" * (w + 2) for w in col_widths) + "+"
    lines = [sep, row_str(headers), sep]
    for r in rows:
        lines.append(row_str(r))
    lines.append(sep)
    return "\n".join(lines)


def main():
    # --- Load all data ---
    all_data = {}
    for ds in DATASETS:
        path = os.path.join(RESULTS_DIR, f"{ds}_lrb.res")
        if not os.path.exists(path):
            print(f"[WARN] Missing result file: {path}")
            continue
        rows = parse_result_file(path)
        if not rows:
            print(f"[WARN] No table found in: {path}")
            continue
        all_data[ds] = rows

    if not all_data:
        print("No result files found.")
        return

    print(f"Loaded results for {len(all_data)} datasets: {', '.join(all_data.keys())}\n")

    # --- Per-dataset tables ---
    for ds, rows in all_data.items():
        print(f"{'=' * 90}")
        print(f"  Dataset: {ds}")
        print(f"{'=' * 90}")
        headers = ["Algorithm"] + METRICS
        table_rows = [[r[h] for h in headers] for r in rows]
        print(fmt_table(headers, table_rows))
        print()

    # --- Aggregate across datasets ---
    agg = defaultdict(lambda: {"Hit": 0, "Miss": 0, "Total": 0,
                                "Hit Rate_sum": 0.0, "Cost Ratio_sum": 0.0,
                                "LRU-norm CR_sum": 0.0, "count": 0})
    for ds, rows in all_data.items():
        for r in rows:
            a = agg[r["Algorithm"]]
            a["Hit"] += r["Hit"]
            a["Miss"] += r["Miss"]
            a["Total"] += r["Total"]
            a["Hit Rate_sum"] += r["Hit Rate"]
            a["Cost Ratio_sum"] += r["Cost Ratio"]
            a["LRU-norm CR_sum"] += r["LRU-normalized Cost Ratio"]
            a["count"] += 1

    agg_headers = ["Algorithm", "Total Hit", "Total Miss", "Total Accesses",
                   "Overall Hit Rate", "Avg Hit Rate", "Avg Cost Ratio",
                   "Avg LRU-norm CR", "# Datasets"]
    agg_rows = []
    for alg, v in agg.items():
        n = v["count"]
        overall_hr = v["Hit"] / v["Total"] if v["Total"] else 0
        agg_rows.append([
            alg,
            v["Hit"], v["Miss"], v["Total"],
            f"{overall_hr:.4f}",
            f"{v['Hit Rate_sum'] / n:.4f}" if n else "N/A",
            f"{v['Cost Ratio_sum'] / n:.4f}" if n else "N/A",
            f"{v['LRU-norm CR_sum'] / n:.4f}" if n else "N/A",
            n,
        ])
    agg_rows.sort(key=lambda x: -float(x[4]))

    print(f"{'=' * 90}")
    print(f"  AGGREGATE SUMMARY (across {len(all_data)} datasets)")
    print(f"{'=' * 90}")
    print(fmt_table(agg_headers, agg_rows))
    print()

    # --- Pivot: Hit Rate by dataset x algorithm ---
    algorithms = list(agg.keys())
    alg_order = sorted(algorithms, key=lambda a: -float(
        agg[a]["Hit"] / agg[a]["Total"] if agg[a]["Total"] else 0))

    for metric in ["Hit Rate", "Cost Ratio", "LRU-normalized Cost Ratio"]:
        print(f"{'=' * 90}")
        print(f"  {metric} by Dataset x Algorithm")
        print(f"{'=' * 90}")

        pivot_headers = ["Dataset"] + alg_order
        pivot_rows = []
        for ds in all_data:
            lookup = {r["Algorithm"]: r[metric] for r in all_data[ds]}
            row = [ds] + [f"{lookup.get(a, 'N/A')}" for a in alg_order]
            pivot_rows.append(row)

        avg_row = ["AVG"]
        for a in alg_order:
            vals = [r[metric] for ds_rows in all_data.values() for r in ds_rows if r["Algorithm"] == a]
            avg_row.append(f"{sum(vals) / len(vals):.4f}" if vals else "N/A")
        pivot_rows.append(avg_row)

        print(fmt_table(pivot_headers, pivot_rows))
        print()

    # --- Save CSV ---
    os.makedirs("results/summary", exist_ok=True)

    with open("results/summary/aggregate.csv", "w") as f:
        f.write(",".join(agg_headers) + "\n")
        for row in agg_rows:
            f.write(",".join(str(v) for v in row) + "\n")

    for metric in ["Hit Rate", "Cost Ratio", "LRU-normalized Cost Ratio"]:
        safe_name = metric.lower().replace(" ", "_").replace("-", "_")
        with open(f"results/summary/{safe_name}_pivot.csv", "w") as f:
            f.write("Dataset," + ",".join(alg_order) + "\n")
            for ds in all_data:
                lookup = {r["Algorithm"]: r[metric] for r in all_data[ds]}
                vals = [str(lookup.get(a, "")) for a in alg_order]
                f.write(ds + "," + ",".join(vals) + "\n")

    print("CSV files saved to results/summary/")


if __name__ == "__main__":
    main()
