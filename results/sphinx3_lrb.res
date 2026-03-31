LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/sphinx3/1/sphinx3_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/sphinx3/sphinx3_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Generating Prediction for LRB, Path: boost_traces/sphinx3_LRB_1.pkl
Initializing DataTrace:   0%|          | 0/10000000 [00:00<?, ?it/s]Initializing DataTrace:   6%|▋         | 640408/10000000 [00:00<00:01, 6403567.02it/s]Initializing DataTrace:  16%|█▌        | 1599381/10000000 [00:00<00:01, 8277665.32it/s]Initializing DataTrace:  26%|██▌       | 2612193/10000000 [00:00<00:00, 9122597.73it/s]Initializing DataTrace:  36%|███▋      | 3644955/10000000 [00:00<00:00, 9598288.13it/s]Initializing DataTrace:  47%|████▋     | 4687369/10000000 [00:00<00:00, 9896088.02it/s]Initializing DataTrace:  57%|█████▋    | 5749152/10000000 [00:00<00:00, 10141408.31it/s]Initializing DataTrace:  68%|██████▊   | 6825817/10000000 [00:00<00:00, 10345743.22it/s]Initializing DataTrace:  79%|███████▉  | 7907962/10000000 [00:00<00:00, 10497115.40it/s]Initializing DataTrace:  90%|████████▉ | 8995095/10000000 [00:00<00:00, 10614078.56it/s]Initializing DataTrace: 100%|██████████| 10000000/10000000 [00:00<00:00, 10086736.28it/s]
Producing cache on Boost Prediction: 0it [00:00, ?it/s]Producing cache on Boost Prediction: 880it [00:00, 16057.27it/s]
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
ValueError: 1119808870798 is not in list
