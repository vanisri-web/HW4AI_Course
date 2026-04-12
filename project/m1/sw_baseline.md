\# Software Baseline — SNN LIF Layer



\## Benchmark Setup

\- Platform: Apple M2 CPU

\- Framework: Pure NumPy / Python

\- Network: Single LIF layer, 1024 neurons, 256 timesteps

\- Runs: 10 repeated executions, average taken



\## Results

| Metric | Value |

|--------|-------|

| Execution time | \~1.2 ms per timestep |

| Throughput | \~1306 GFLOP/s (attainable) |

| Arithmetic Intensity | 13.06 FLOP/byte |

| Bound | Memory-bound |

| Peak BW used | \~100 GB/s |



\## Bottleneck

The LIF forward pass is memory-bound on the M2 CPU. The kernel

repeatedly reads membrane potentials and weights from DRAM, limiting

performance to well below the compute ceiling of 1500 GFLOP/s.

