LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/astar/1/astar_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/astar/astar_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Find boost prediction for LRB, Path: boost_traces/astar_LRB_1.pkl
Enbale Boost for LRB[LRB] --> LRBPredictor
Enbale Boost for Mark0[LRB] --> LRBPredictor
Enbale Boost for SimpleGuardLRB-RT0[LRB] --> LRBPredictor
Enbale Boost for CombDet[LRB[LRB], Marker] --> LRBPredictor
Enbale Boost for CombineRandom[LRB[LRB], Marker] --> LRBPredictor
+---------------------------------+-------+--------+--------+----------+------------+---------------------------+
|               Name              |  Hit  |  Miss  | Total  | Hit Rate | Cost Ratio | LRU-normalized Cost Ratio |
+---------------------------------+-------+--------+--------+----------+------------+---------------------------+
|               OPT               | 53944 | 90312  | 144256 |  0.3739  |   1.000    |           0.000           |
|               Rand              | 12092 | 132164 | 144256 |  0.0838  |   1.463    |           0.869           |
|               LRU               |  5787 | 138469 | 144256 |  0.0401  |   1.533    |           1.000           |
|              Marker             |  6849 | 137407 | 144256 |  0.0475  |   1.521    |           0.978           |
|             LRB[LRB]            | 40164 | 104092 | 144256 |  0.2784  |   1.153    |           0.286           |
|            Mark0[LRB]           | 34820 | 109436 | 144256 |  0.2414  |   1.212    |           0.397           |
|     SimpleGuardLRB-RT0[LRB]     | 34824 | 109432 | 144256 |  0.2414  |   1.212    |           0.397           |
|    CombDet[LRB[LRB], Marker]    | 37099 | 107157 | 144256 |  0.2572  |   1.187    |           0.350           |
| CombineRandom[LRB[LRB], Marker] | 36812 | 107444 | 144256 |  0.2552  |   1.190    |           0.356           |
+---------------------------------+-------+--------+--------+----------+------------+---------------------------+
