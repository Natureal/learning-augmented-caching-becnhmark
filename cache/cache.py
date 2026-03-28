from cache.evict import EvictAlgorithm
from cache.evict.algorithms import PredictAlgorithm
from cache.evict.predictor import OraclePredictor
from cache.hash import HashFunction
from data_trace.data_trace import OracleDataTrace
from utils.aligner import Aligner
from typing import Type
from types import SimpleNamespace
import copy
import numpy as np

class Cache:
    def __init__(self, trace_path, aligner_type: Type[Aligner], evict_type: Type[EvictAlgorithm], hash_type:Type[HashFunction], cache_line_size, cache_capacity, associativity):        
        self.evict_algs = None
        self.hits = 0
        self.miss = 0
        self.pred_calls = 0
        self.counts = 0
        self._trace_path = trace_path
        self._aligner = aligner_type(cache_line_size)

        num_cache_lines = cache_capacity // cache_line_size
        num_sets = num_cache_lines // associativity
        if (cache_capacity % cache_line_size != 0 or num_cache_lines % associativity != 0):
            raise ValueError(
                ("Cache capacity ({}) must be an even multiple of "
                "cache_line_size ({}) and associativity ({})").format(
                    cache_capacity, cache_line_size, associativity))
        if num_sets == 0:
            raise ValueError(
                ("Cache capacity ({}) is not great enough for {} cache lines per set "
                "and cache lines of size {}").format(cache_capacity, associativity, cache_line_size))
        
        self.hash_func = hash_type(num_sets)
        self.evict_algs = []
        ###################################################################
        oracle = False
        for _ in range(num_sets):
            evict_alg = evict_type(associativity)
            if hasattr(evict_alg, 'oracle_access'):
                oracle = True
            self.evict_algs.append(evict_alg)
        if oracle:
            print("Cache: use oracle")
            self.__handle_oracle(trace_path)
            print("Cache: finish oracle")

    def __handle_oracle(self, trace_path):
        with OracleDataTrace(trace_path, self._aligner, self.hash_func, scale_times=1, offset=1) as sim_trace:
            count = 0
            # Cache lookups / methods locally (optimization 2)
            evict_algs = self.evict_algs
            get_bucket_index = self.hash_func.get_bucket_index
            align = self._aligner.get_aligned_addr
            next_rec = sim_trace.next
            done = sim_trace.done
            next_bucket_time_aligned = sim_trace.next_bucket_access_time_by_aligned
            # Print every N (optimization 1)
            LOG_INTERVAL = 100000
            while not done():
                pc, address = next_rec()
                aligned_address = align(address)
                bucket_idx = get_bucket_index(aligned_address, pc)
                # Avoid re-align + redundant key (optimization 3)
                next_time = next_bucket_time_aligned(pc, aligned_address, bucket_idx)
                evict_algs[bucket_idx].oracle_access(pc, aligned_address, next_time)
                count += 1
                if count % LOG_INTERVAL == 0:
                    print(f"Oracle processed {count} traces")

    def access(self, pc, address):
        aligned_address = self._aligner.get_aligned_addr(address)
        hit, pred_call = self.evict_algs[self.hash_func.get_bucket_index(aligned_address, pc)].access(pc, aligned_address)

        if hit:
            self.hits += 1
        else:
            self.miss += 1

        self.pred_calls += pred_call

        self.counts += 1
    
    def stat(self):
        return (self.hits, self.miss, self.counts, round(self.hits / self.counts, 4), self.pred_calls)
    
    # todo
    def set_stat(self, hits, miss, counts, pred_calls):
        self.hits = hits
        self.miss = miss
        self.counts = counts
        self.pred_calls = pred_calls

class DumpCache(Cache):
    def __init__(self, is_state, trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity):
        super().__init__(trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity)
        self.is_state = is_state
        self.boost_preds = []
    
    def access(self, pc, address):
        raise NotImplementedError('DumpCache: access not work')
    
    def dump(self):
        return self.boost_preds

    def simulate(self, pc, address):
        aligned_address = self._aligner.get_aligned_addr(address)
        idx = self.hash_func.get_bucket_index(aligned_address, pc)
        
        self.evict_algs[idx].access(pc, aligned_address)
        this_preds = copy.deepcopy(self.evict_algs[idx].preds)
        if not self.is_state:
            target_index = self.evict_algs[idx].cache.index(aligned_address)
            self.boost_preds.append(this_preds[target_index])
        else:
            self.boost_preds.append(copy.deepcopy(this_preds))

class BoostCache(Cache):
    def __init__(self, boost_preds, trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity):
        super().__init__(trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity)
        self.boost_preds = boost_preds
        self.ts = 0

    def access(self, pc, address):
        pred = self.boost_preds[self.ts]
        aligned_address = self._aligner.get_aligned_addr(address)
        hit, pred_call = self.evict_algs[self.hash_func.get_bucket_index(aligned_address, pc)].boost_access(pc, aligned_address, pred)
        
        self.ts += 1
        if hit:
            self.hits += 1
        else:
            self.miss += 1

        self.pred_calls += pred_call
        self.counts += 1

class TrainingCache(Cache):
    def __init__(self, trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity):
        super().__init__(trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity)
    
    def collect(self, pc, address):
        raise NotImplementedError("TrainingCache: 'collect' need override")

class ParrotTrainingCache(TrainingCache):
    def __init__(self, trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity):
        super().__init__(trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity)
    
    def reset(self, model_prob):
        for alg in self.evict_algs:
            alg.reset([1-model_prob, model_prob])
    
    def collect(self, pc, address):
        snapshot = SimpleNamespace()
        snapshot.pc = pc
        snapshot.address = address

        aligned_address = self._aligner.get_aligned_addr(address)
        idx = self.hash_func.get_bucket_index(aligned_address, pc)
        alg = self.evict_algs[idx]
        cache_lines, scores = alg.snapshot()
        snapshot.cache_lines = cache_lines
        snapshot.cache_line_scores = scores
        hit = alg.access(pc, aligned_address)
        return snapshot, hit

class LightGBMTrainingCache(TrainingCache):
    def __init__(self, trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity, delta_nums=1, edc_nums=1):
        super().__init__(trace_path, aligner_type, evict_type, hash_type, cache_line_size, cache_capacity, associativity)
        self.deltas = [{} for _ in range(delta_nums)]
        self.edcs = [{} for _ in range(edc_nums)]
        self.delta_nums = delta_nums
        self.edc_nums = edc_nums
        self.access_time_dict = {}
        self.access_ts = [0] * self.hash_func._num_buckets
    
    def collect(self, pc, address):
        aligned_address = self._aligner.get_aligned_addr(address)
        idx = self.hash_func.get_bucket_index(aligned_address, pc)

        key = f'{idx}_{aligned_address}'
        if key not in self.access_time_dict:
            self.access_time_dict[key] = []
        self.access_time_dict[key].append(self.access_ts[idx])
        # delta
        for i in range(1, self.delta_nums + 1):
            this_access_list = self.access_time_dict[key]
            this_delta = self.deltas[i-1]
            if len(this_access_list) > i:
                delta_i = this_access_list[-i] - this_access_list[-i-1]
                this_delta[key] = delta_i
            else:
                this_delta[key] = np.inf
        delta1 = self.deltas[0][key]
        for i in range(1, self.edc_nums + 1):
            this_edc = self.edcs[i-1]
            if key not in this_edc:
                this_edc[key] = 0
            this_edc[key] = 1 + this_edc[key] * 2 ** (-delta1 / (2 ** (9 + i)))
        self.evict_algs[idx].access(pc, aligned_address)
        target_index = self.evict_algs[idx].cache.index(aligned_address)
        bin_label = self.evict_algs[idx].preds[target_index]
        self.access_ts[idx] += 1
        return (pc, aligned_address, *[self.deltas[i][key] for i in range(self.delta_nums)], *[self.edcs[i][key] for i in range(self.edc_nums)], bin_label)

class SingleInstanceCache(Cache):
    def __init__(self, trace_path, aligner_type, evict_instance, hash_type, cache_line_size, cache_capacity, associativity):
        self.evict_algs = None
        self.hits = 0
        self.miss = 0
        self.counts = 0
        self._trace_path = trace_path
        self._aligner = aligner_type(cache_line_size)

        num_cache_lines = cache_capacity // cache_line_size
        self.num_sets = num_sets = num_cache_lines // associativity
        if (cache_capacity % cache_line_size != 0 or num_cache_lines % associativity != 0):
            raise ValueError(
                ("Cache capacity ({}) must be an even multiple of "
                "cache_line_size ({}) and associativity ({})").format(
                    cache_capacity, cache_line_size, associativity))
        if num_sets == 0:
            raise ValueError(
                ("Cache capacity ({}) is not great enough for {} cache lines per set "
                "and cache lines of size {}").format(cache_capacity, associativity, cache_line_size))
        
        self.hash_func = hash_type(num_sets)
        
        self.evict_instance = evict_instance
        self.evict_algs = [self.evict_instance]
        
        if hasattr(self.evict_instance, 'oracle_access'):
            self.__handle_oracle(trace_path)
    
    def access(self, pc, address):
        aligned_address = self._aligner.get_aligned_addr(address)
        hit = self.evict_instance.access(pc, aligned_address)
        
        if hit:
            self.hits += 1
        else:
            self.miss += 1
        self.counts += 1
        return hit
