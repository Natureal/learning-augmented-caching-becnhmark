LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/mcf/1/mcf_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/mcf/mcf_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Generating Prediction for LRB, Path: boost_traces/mcf_LRB_1.pkl
Initializing DataTrace:   0%|          | 0/10000000 [00:00<?, ?it/s]Initializing DataTrace:   2%|▏         | 182166/10000000 [00:00<00:05, 1821553.16it/s]Initializing DataTrace:   4%|▍         | 417942/10000000 [00:00<00:04, 2136935.56it/s]Initializing DataTrace:  12%|█▏        | 1176412/10000000 [00:00<00:01, 4624432.16it/s]Initializing DataTrace:  20%|██        | 2013519/10000000 [00:00<00:01, 6103492.24it/s]Initializing DataTrace:  29%|██▉       | 2896334/10000000 [00:00<00:01, 7085981.54it/s]Initializing DataTrace:  38%|███▊      | 3807861/10000000 [00:00<00:00, 7775903.82it/s]Initializing DataTrace:  46%|████▌     | 4585454/10000000 [00:00<00:00, 6842955.80it/s]Initializing DataTrace:  54%|█████▍    | 5431894/10000000 [00:00<00:00, 7315180.95it/s]Initializing DataTrace:  63%|██████▎   | 6346411/10000000 [00:00<00:00, 7852836.23it/s]Initializing DataTrace:  73%|███████▎  | 7279426/10000000 [00:01<00:00, 8289573.92it/s]Initializing DataTrace:  82%|████████▏ | 8226038/10000000 [00:01<00:00, 8638942.56it/s]Initializing DataTrace:  92%|█████████▏| 9158459/10000000 [00:01<00:00, 8843025.07it/s]Initializing DataTrace: 100%|██████████| 10000000/10000000 [00:01<00:00, 7519346.03it/s]
Producing cache on Boost Prediction: 0it [00:00, ?it/s]Producing cache on Boost Prediction: 813it [00:00, 20839.26it/s]
Traceback (most recent call last):
  File "/Users/pchen/miniconda3/envs/py310/lib/python3.10/runpy.py", line 196, in _run_module_as_main
    return _run_code(code, main_globals, None,
  File "/Users/pchen/miniconda3/envs/py310/lib/python3.10/runpy.py", line 86, in _run_code
    exec(code, run_globals)
  File "/Users/pchen/Experiments/learning-augmented-caching-becnhmark/benchmark/__main__.py", line 642, in <module>
    boost_preds_dict['LRB'] = boost_generate_prediction('LRB', shared_model=lrb_gen(), memory_window=args.memory_window)
  File "/Users/pchen/Experiments/learning-augmented-caching-becnhmark/benchmark/__main__.py", line 523, in boost_generate_prediction
    dump_cache.simulate(pc, address)
  File "/Users/pchen/Experiments/learning-augmented-caching-becnhmark/cache/cache.py", line 94, in simulate
    target_index = self.evict_algs[idx].cache.index(aligned_address)
ValueError: 2197677046084 is not in list
