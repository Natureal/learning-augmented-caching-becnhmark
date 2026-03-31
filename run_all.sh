#!/bin/bash

DATASETS=(astar bzip bwaves cactusadm gems lbm leslie3d libq mcf milc omnetpp sphinx3 xalanc)

mkdir -p results

for ds in "${DATASETS[@]}"; do
    echo "========== Running dataset: $ds =========="
    python -m benchmark --dataset "$ds" --real --pred lrb --boost --boost_fr > "results/${ds}_lrb.res" 2>&1
    echo "========== Finished dataset: $ds (exit code: $?) =========="
done

echo "All done."
