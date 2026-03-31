LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/xalanc/1/xalanc_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/xalanc/xalanc_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Find boost prediction for LRB, Path: boost_traces/xalanc_LRB_1.pkl
Enbale Boost for LRB[LRB] --> LRBPredictor
Enbale Boost for Mark0[LRB] --> LRBPredictor
Enbale Boost for SimpleGuardLRB-RT0[LRB] --> LRBPredictor
Enbale Boost for CombDet[LRB[LRB], Marker] --> LRBPredictor
Enbale Boost for CombineRandom[LRB[LRB], Marker] --> LRBPredictor
+---------------------------------+------+------+-------+----------+------------+---------------------------+
|               Name              | Hit  | Miss | Total | Hit Rate | Cost Ratio | LRU-normalized Cost Ratio |
+---------------------------------+------+------+-------+----------+------------+---------------------------+
|               OPT               | 4915 | 3725 |  8640 |  0.5689  |   1.000    |           0.000           |
|               Rand              | 3314 | 5326 |  8640 |  0.3836  |   1.430    |           1.570           |
|               LRU               | 3895 | 4745 |  8640 |  0.4508  |   1.274    |           1.000           |
|              Marker             | 3795 | 4845 |  8640 |  0.4392  |   1.301    |           1.098           |
|             LRB[LRB]            | 3252 | 5388 |  8640 |  0.3764  |   1.446    |           1.630           |
|            Mark0[LRB]           | 4388 | 4252 |  8640 |  0.5079  |   1.141    |           0.517           |
|     SimpleGuardLRB-RT0[LRB]     | 4481 | 4159 |  8640 |  0.5186  |   1.117    |           0.425           |
|    CombDet[LRB[LRB], Marker]    | 3728 | 4912 |  8640 |  0.4315  |   1.319    |           1.164           |
| CombineRandom[LRB[LRB], Marker] | 3251 | 5389 |  8640 |  0.3763  |   1.447    |           1.631           |
+---------------------------------+------+------+-------+----------+------------+---------------------------+
