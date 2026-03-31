LRB: Fraction [1], Memory Window [1000000], Threshold [0.75], Model Checkpoint[checkpoints/lightgbm/omnetpp/1/omnetpp_1_10_10.txt], Delta[10], EDC[10]
Benchmark: Use Predictor: ['lrb']
Benchmark: Use Trace: traces/omnetpp/omnetpp_test.csv
Benchmark: Only print
Benchmark: Use Boost Trace Prediction
Benchmark: Enable F&R Boost
DeviceManager: Default Device[cpu -> cpu]
Boost Prediction: Generating Prediction for LRB, Path: boost_traces/omnetpp_LRB_1.pkl
Initializing DataTrace:   0%|          | 0/10000000 [00:00<?, ?it/s]Initializing DataTrace:   5%|▌         | 524308/10000000 [00:00<00:01, 5242535.04it/s]Initializing DataTrace:  14%|█▍        | 1439333/10000000 [00:00<00:01, 7541043.86it/s]Initializing DataTrace:  24%|██▍       | 2429550/10000000 [00:00<00:00, 8619074.10it/s]Initializing DataTrace:  35%|███▍      | 3452033/10000000 [00:00<00:00, 9252919.77it/s]Initializing DataTrace:  45%|████▍     | 4492521/10000000 [00:00<00:00, 9668245.55it/s]Initializing DataTrace:  55%|█████▌    | 5546643/10000000 [00:00<00:00, 9965015.16it/s]Initializing DataTrace:  66%|██████▌   | 6610336/10000000 [00:00<00:00, 10184648.23it/s]Initializing DataTrace:  77%|███████▋  | 7682416/10000000 [00:00<00:00, 10355303.14it/s]Initializing DataTrace:  88%|████████▊ | 8759388/10000000 [00:00<00:00, 10484818.90it/s]Initializing DataTrace:  98%|█████████▊| 9841164/10000000 [00:01<00:00, 10587567.88it/s]Initializing DataTrace: 100%|██████████| 10000000/10000000 [00:01<00:00, 9855690.63it/s]
Producing cache on Boost Prediction: 0it [00:00, ?it/s]Producing cache on Boost Prediction: 581it [00:00, 9400.21it/s]
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
ValueError: 3704300956441 is not in list
