LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/libq/1/libq_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/libq/libq_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Generating Prediction for LRB, Path: boost_traces/libq_LRB_1.pkl
Initializing DataTrace:   0%|          | 0/10000000 [00:00<?, ?it/s]Initializing DataTrace:   5%|▌         | 532487/10000000 [00:00<00:01, 5323478.94it/s]Initializing DataTrace:  14%|█▍        | 1438681/10000000 [00:00<00:01, 7522246.37it/s]Initializing DataTrace:  24%|██▍       | 2405272/10000000 [00:00<00:00, 8500917.22it/s]Initializing DataTrace:  34%|███▍      | 3404484/10000000 [00:00<00:00, 9089526.12it/s]Initializing DataTrace:  43%|████▎     | 4313449/10000000 [00:00<00:00, 8969577.33it/s]Initializing DataTrace:  53%|█████▎    | 5265687/10000000 [00:00<00:00, 9155818.05it/s]Initializing DataTrace:  62%|██████▏   | 6181620/10000000 [00:00<00:00, 8885738.37it/s]Initializing DataTrace:  72%|███████▏  | 7189375/10000000 [00:00<00:00, 9255822.67it/s]Initializing DataTrace:  82%|████████▏ | 8212684/10000000 [00:00<00:00, 9556164.90it/s]Initializing DataTrace:  92%|█████████▏| 9227805/10000000 [00:01<00:00, 9737621.29it/s]Initializing DataTrace: 100%|██████████| 10000000/10000000 [00:01<00:00, 9170152.60it/s]
Producing cache on Boost Prediction: 0it [00:00, ?it/s]Producing cache on Boost Prediction: 982it [00:00, 22382.75it/s]
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
ValueError: 2177228752931 is not in list
