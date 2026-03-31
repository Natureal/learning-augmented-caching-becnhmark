LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/milc/1/milc_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/milc/milc_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Generating Prediction for LRB, Path: boost_traces/milc_LRB_1.pkl
Initializing DataTrace:   0%|          | 0/10000000 [00:00<?, ?it/s]Initializing DataTrace:   6%|▌         | 555781/10000000 [00:00<00:01, 5557523.80it/s]Initializing DataTrace:  15%|█▍        | 1491715/10000000 [00:00<00:01, 7793832.29it/s]Initializing DataTrace:  24%|██▍       | 2429550/10000000 [00:00<00:00, 8515525.11it/s]Initializing DataTrace:  34%|███▍      | 3443336/10000000 [00:00<00:00, 9155843.04it/s]Initializing DataTrace:  45%|████▍     | 4492267/10000000 [00:00<00:00, 9636626.54it/s]Initializing DataTrace:  55%|█████▌    | 5539856/10000000 [00:00<00:00, 9921825.22it/s]Initializing DataTrace:  65%|██████▌   | 6532042/10000000 [00:00<00:00, 9310372.47it/s]Initializing DataTrace:  76%|███████▌  | 7580611/10000000 [00:00<00:00, 9668403.53it/s]Initializing DataTrace:  86%|████████▋ | 8647760/10000000 [00:00<00:00, 9972579.26it/s]Initializing DataTrace:  97%|█████████▋| 9724261/10000000 [00:01<00:00, 10212083.61it/s]Initializing DataTrace: 100%|██████████| 10000000/10000000 [00:01<00:00, 9568707.07it/s]
Producing cache on Boost Prediction: 0it [00:00, ?it/s]Producing cache on Boost Prediction: 198it [00:00, 17791.89it/s]
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
ValueError: 535024549414 is not in list
