# Instructions

A benchmark for evaluating learning-augmented caching algorithms.

## Traces

The Brightkite and Cite datasets have been included in the folder `traces`.

Datasets from the SPEC CPU2006 benchmark have been included can be obtained following the instructions under `Getting the traces` in [ML caching with guarantees](https://github.com/chledowski/ml_caching_with_guarantees)<sup>[1]</sup>. Please copy the traces to the `traces/{dataset_name}` folder.

## Environment

We employ an environment based on Python 3.10.16 with Anaconda3 (Anaconda3-2021.05-Linux-x86_64.sh). We strongly recommend using Anaconda for effective Python package management and virtual environment configuration.

While it is possible to configure your own environment using a different Python version, please note the following considerations:

* To utilize the `Parrot` model, ensure that your Torch environment is properly configured. In our benchmark, we use CUDA 12.4 to enable GPU support for Torch.
* Due to differences in Python's pickle serialization rules, the released `boost-traces.zip` file may not be compatible with alternative environments. In such cases, you will need to generate your own boost trace file.

## Usage

### Benchmark

Examples:

The following command generates the data presented in Figure 1 of the paper.
```
python -m benchmark --dataset brightkite --oracle --pred oracle_dis --noise_type logdis --test_all --boost_fr
```

Test on the SPEC CPU2006 benchmark by replacing the dataset.
```
python -m benchmark --dataset xalanc --real --pred pleco --boost --boost_fr 
```

Results for all supported algorithms will be provided.

#### Usage
```python
python -m benchmark [--dataset DATASET] [--test_all] [--device DEVICE] (--oracle | --real)
                   [--pred {parrot,pleco,popu,pleco-bin,lrb,oracle_bin,oracle_dis}]
                   [--noise_type {dis,bin,logdis}] [--dump_file] [--output_root_dir OUTPUT_ROOT_DIR] [--verbose]
                   [--boost] [--num_workers NUM_WORKERS] [--boost_fr] [--boost_preds_dir BOOST_PREDS_DIR]
                   [--model_fraction MODEL_FRACTION] [--checkpoints_root_dir CHECKPOINTS_ROOT_DIR]
                   [--parrot_config_path PARROT_CONFIG_PATH] [--lightgbm_config_path LIGHTGBM_CONFIG_PATH]
```

- Datasets

  `--dataset`: Benchmark source dataset name, supported name:
    + `brightkite`
    + `citi`
    + `astar`
    + `bwaves`
    + `bzip`
    + `cactusadm`
    + `gems`
    + `lbm`
    + `leslie3d`
    + `libq`
    + `mcf`
    + `milc`
    + `omnetpp`
    + `sphinx3`
    + `xalanc`

  `--test_all`: This option is only applicable to the `brightkite` and `citi` datasets, where the entire trace is utilized. It is not compatible with the `parrot` or `gbm` predictors, as these models require a separate training set.

- Devices

  `--device`: Model target device, such as `cpu`, `cuda:0` and `cuda:1`...

  This option only works for the `parrot` predictor, in other cases we only use CPU.
  
- Modes

  `real` and `oracle`: You must specify one of them in command.

  - Real Mode

    Supported Predictors:

    + `parrot`
    + `pleco`
    + `popu`
    + `pleco-bin`
    + `gbm`

    `verbose` default to True

    `boost` will use pickle traces (`num_workers` doesn't work)

    `noise_type` doesn't work
    
  - Oracle Mode

    Supported Predictors:

    + `oracle_dis`
    + `oracle_bin`
 
    `verbose` default to False

    `boost` will use multiprocess pool (`num_workers` works)

    `boost_preds_dir` `model_fraction` `checkpoints_root_dir` `parrot_config_path` `lightgbm_config_path` don't work

- Noise Types
  + `logdis`: Log Normal Noise on Next Request Times (NRT)
  + `dis`: Normal Noise on Next Request Times (NRT)
  + `bin`: Binary Flipping Noise on Belady's binary labels
  
- Algorithms

  We incorporate a broad range of existing algorithms in our benchmark.

  #### Algorithms and Predictors compatibility

  | Algorithm                          | PLECO    |   POPU   |  Parrot  |   LRB    |Oracle-Dis|Oracle-Bin|
  |:----------|:------:|:-----:|:---------:|:---:|:----------:|:----------:|
  | Rand                               | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; |
  | LRU                                | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; |
  | Marker                             | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; |
  | Predict (BlindOracle/LRB/Parrot)   | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; |
  | PredictiveMarker<sup>[2]</sup>     | &#10004; | &#10004; | &#10060; | &#10060; | &#10004; | &#10060; |
  | LMarker<sup>[3]</sup>              | &#10004; | &#10004; | &#10060; | &#10060; | &#10004; | &#10060; |
  | LNonMarker<sup>[3]</sup>           | &#10004; | &#10004; | &#10060; | &#10060; | &#10004; | &#10060; |
  | Follower&Robust(F&R)<sup>[4]</sup> | &#10004; | &#10004; | &#10060; | &#10060; | &#10004; | &#10060; |
  | Mark0<sup>[5]</sup>                | &#10060; | &#10060; | &#10060; | &#10004; | &#10060; | &#10004; |
  | Mark&Predict<sup>[5]</sup>         | &#10060; | &#10060; | &#10060; | &#10060; | &#10060; | &#10004; |
  | CombineDeterministic<sup>[6]</sup> | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; |
  | CombineRandom<sup>[6]</sup>        | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; |
  | The Guard Framework                | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; | &#10004; |
  | Guard&BlindOracle                  | &#10004; | &#10004; | &#10060; | &#10060; | &#10004; | &#10060; |
  | Guard&LRB                          | &#10060; | &#10060; | &#10060; | &#10004; | &#10060; | &#10004; |
  | Guard&Parrot                       | &#10060; | &#10060; | &#10004; | &#10060; | &#10060; | &#10060; |

- Predictor

  + `pleco`: A PLECO Model that predicts next request times (NRT).
  + `popu`: A Popularity Model that predicts next request times (NRT).
  + `parrot`: A Parrot Imitation Model that predicts eviction priority for each page.
  + `lrb`: A Gradient Boosting Machine based on Delta and EDC features that predicts belady's binary labels.
  + `oracle_bin`: An offline predictor that predicts next request times (NRT), potentially affected by noise (dis).
  + `oracle_dis`: An offline predictor that predicts belady's binary label, potentially affected by noise (logdis, dis).

- Dump and Verbose

  `dump_file`: Enables result dumping, saving test results in the format `$output_root_dir/$dataset/$fraction/$predictor.csv`.

  `verbose`: Enables detailed output. When enabled, all statistical data (hits, misses, hit rates, and competitive ratios) will be displayed; otherwise, only the hit rate and competitive ratio will be shown.
  
- Boost
  
  In `real` mode, `boost` uses a pickle file from `boost_preds_dir` (creating it if it doesn't exist) to accelerate testing.

  In `oracle` mode, `boost` utilizes a multiprocessing pool to handle all test tasks concurrently.

  We also provide the `boost_fr` parameter, which enables the `Follow&Robust` algorithm to use the Belady trace for calculating the Belady cost within this algorithm. Without this optimization, the entire test process would be significantly slower.
  
- Model Configs

  To use the Parrot or LRB predictors, you must specify the following parameters (or use the defaults):

  + `model_fraction` (default to 1): Specifies the fraction of the training set to be used for training. (In benchmarking, you must select a fraction corresponding to an existing pre-trained model.)
  + `checkpoints_root_dir`: Checkpoints dir.
  + `parrot_config_path`: The `parrot` predictor's config file.
  + `lightgbm_config_path`: The `gbm` predictor's config file.


### Model Training

#### LightGBM Model

```python
python -m model.lightgbm [--dataset DATASET] [--device DEVICE]
                    [--model_fraction MODEL_FRACTION] [--model_config_path MODEL_CONFIG_PATH]
                    [--checkpoints_root_dir CHECKPOINTS_ROOT_DIR] [--traces_root_dir TRACES_ROOT_DIR]
                    [--iter_threshold] [--real_test]
```

You can use our GBM training tool to generate and test the cache model.

- Params:
  + `dataset`: Source dataset
  + `device`: Model load device (in GBM, only `cpu` can work)
  + `model_fraction`: The proportion of the training set used for training. The default value is 1, indicating that the entire training set will be used.
  + `model_config_path`: Model's config
  + `checkpoints_root_dir`: The directory where the checkpoint files are saved after training is completed.
  + `traces_root_dir`: The directory where the datasets are stored.
  + `iter_threshold`: When enabled, this iteratively adjusts the binary splitting threshold from 0 to 1 to determine the optimal threshold for binary classification. If disabled, the threshold defaults to 0.5.
  + `real_test`: After training is completed, the test set will be loaded to evaluate the model's performance.

- Config Example:
  ```json
  {
      "delta_nums": 10,
      "edc_nums": 10,
      "training": {
          "boosting_type": "gbdt", 
          "objective": "binary", 
          "metric": "l2",
          "learning_rate": 0.01,
          "num_boost_round": 8000,
          "num_leaves": 31, 
          "max_depth": 6,
          "subsample": 0.8, 
          "colsample_bytree": 0.8
      }
  }
  ```

  `delta_nums` and `edc_nums`: The dimensions of the **Delta** and **EDC** features, respectively. For more details, refer to [webcachesim2](https://github.com/sunnyszy/lrb) and [Learning relaxed Belady for content distribution network caching](https://dl.acm.org/doi/10.5555/3388242.3388281)<sup>[7]</sup>.

  `training`: The training parameters that will be used by LightGBM.

#### Parrot Model

```python
python -m model.parrot [--dataset DATASET] [--device DEVICE]
                    [--model_fraction MODEL_FRACTION] [--model_config_path MODEL_CONFIG_PATH]
                    [--checkpoints_root_dir CHECKPOINTS_ROOT_DIR] [--traces_root_dir TRACES_ROOT_DIR]
```

- Params:
  + `dataset`: Source dataset
  + `device`: Model load device (Parrot use `CUDA_VISIBLE_DEVICES` to set target device)
  + `model_fraction`: The proportion of the training set used for training. The default value is 1, indicating that the entire training set will be used.
  + `model_config_path`: Model's config
  + `checkpoints_root_dir`: The directory where the checkpoint files are saved after training is completed.
  + `traces_root_dir`: The directory where the datasets are stored.
 
- Config Example:
  ```json
  {
    "address_embedder": {
        "embed_dim": 64,
        "max_vocab_size": 5000,
        "type": "dynamic-vocab"
    },
    "cache_line_embedder": "address_embedder",
    "cache_pc_embedder": "none",
    "loss": [
        "ndcg",
        "reuse_dist"
    ],
    "lstm_hidden_size": 128,
    "max_attention_history": 30,
    "pc_embedder": {
        "embed_dim": 64,
        "max_vocab_size": 5000,
        "type": "dynamic-vocab"
    },
    "positional_embedder": {
        "embed_dim": 128,
        "type": "positional"
    },
    "sequence_length": 80,
    "lr": 0.001,
    "total_steps": 25000,
    "eval_freq": 5000,
    "save_freq": 5000,
    "batch_size": 32,
    "collection_multiplier": 5,
    "dagger_init": 1,
    "dagger_final": 1,
    "dagger_steps": 200000,
    "dagger_update_freq": 50000
  }
  ```
  
  You can find more details about Parrot and its training in [cache_replacement](https://github.com/google-research/google-research/tree/master/cache_replacement)<sup>[8]</sup>.

### Script

We also provide some scripts for training and testing, for reference purposes only. You can find them in the `scripts` folder.

## References

[1] Chłędowski, Jakub Polak, Adam Szabucki, Bartosz Zolna, Konrad. 2021. Robust Learning-Augmented Caching: An Experimental Study. 10.48550/arXiv.2106.14693. 

[2] Thodoris Lykouris and Sergei Vassilvitskii. 2021. Competitive Caching with Machine Learned Advice. J. ACM 68, 4, Article 24 (August 2021), 25 pages. https://doi.org/10.1145/3447579

[3] Dhruv Rohatgi. 2020. Near-optimal bounds for online caching with machine-learned advice. In Proceedings of the Thirty-First Annual ACM-SIAM Symposium on Discrete Algorithms (SODA '20). Society for Industrial and Applied Mathematics, USA, 1834–1845.

[4] Sadek, K. A. and Elias, M. Algorithms for caching and mts with reduced number of predictions. arXiv preprint arXiv:2404.06280, 2024.

[5] Antonios Antoniadis, Joan Boyar, Marek Eliáš, Lene M. Favrholdt, Ruben Hoeksma, Kim S. Larsen, Adam Polak, and Bertrand Simon. 2023. Paging with succinct predictions. In Proceedings of the 40th International Conference on Machine Learning (ICML'23), Vol. 202. JMLR.org, Article 39, 952–968.

[6] Wei, A. Better and simpler learning-augmented online caching. arXiv preprint arXiv:2005.13716, 2020.

[7] Zhenyu Song, Daniel S. Berger, Kai Li, and Wyatt Lloyd. 2020. Learning relaxed Belady for content distribution network caching. In Proceedings of the 17th Usenix Conference on Networked Systems Design and Implementation (NSDI'20). USENIX Association, USA, 529–544.

[8] Evan Zheran Liu, Milad Hashemi, Kevin Swersky, Parthasarathy Ranganathan, and Junwhan Ahn. 2020. An imitation learning approach for cache replacement. In Proceedings of the 37th International Conference on Machine Learning (ICML'20), Vol. 119. JMLR.org, Article 579, 6237–6247.

