# Software Baseline — SNN LIF Layer

## Benchmark Setup

- Platform: Apple M2 CPU
- Framework: Pure NumPy / Python
- Network: FC-LIF-SNN (784 -> 1000 -> 10), MNIST, T=25 timesteps
- Runs: 10 repeated executions, average taken

## Results

| Metric | Value |
|--------|-------|
| Total training time (5 epochs) | 74.6 seconds |
| Dominant kernel | lif_layer_forward (snn.py:54) |
| Kernel share of runtime | 79.0% |
| Arithmetic Intensity | 13.06 FLOP/byte |
| Ridge point (M2 CPU) | 15.0 FLOP/byte |
| Bound classification | Memory-bound |
| Attainable performance | ~1306 GFLOP/s |

## Bottleneck Analysis

The dominant kernel is lif_layer_forward, specifically the synaptic current
computation I_syn = np.dot(W, spk_in[t]) — a 1000x784 matrix multiply
executed 25 times per batch. The weight matrix W is reloaded from DRAM at
every timestep, causing redundant memory traffic.

With AI = 13.06 FLOP/byte just below the ridge point of 15.0 FLOP/byte,
the kernel is memory-bound. Attainable performance is limited to 1306 GFLOP/s,
well below the M2 compute ceiling of 1500 GFLOP/s.
