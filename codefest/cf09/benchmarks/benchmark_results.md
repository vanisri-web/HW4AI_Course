# Benchmark Results - CF09

## Platform Comparison

| Metric | SW Baseline (M2 CPU, measured) | HW Accelerator (sky130, projected) |
|--------|--------------------------------|------------------------------------|
| Execution time | 74.6 s (5 epochs, 60k samples) | ~37,240 s (projected, serial MAC) |
| Throughput (measured) | 0.052 GFLOP/s (measured from timed run) | 0.0008 GFLOP/s (projected) |
| Memory usage | ~6.1 MB | Not yet measured |
| Clock frequency | N/A | 100 MHz (from synthesis) |
| Power | N/A | 0.69 mW (from OpenLane) |

## Throughput Measurement

SW baseline throughput is MEASURED from the actual timed run:
Total FLOPs = 64,800 FLOPs/sample x 60,000 samples = 3.888 GFLOP
Total time = 74.6 s (5 epochs, measured on Apple M2)
Measured throughput = 3.888 GFLOP / 74.6 s = 0.052 GFLOP/s

## Speedup Computation

Speedup = HW projected throughput / SW measured throughput
= 0.0008 GFLOP/s / 0.052 GFLOP/s = 0.015x

The accelerator is currently slower than software because the compute core
processes one MAC per cycle with no parallelism. 111 of every 120 cycles
are AXI4-Lite bus overhead, giving only 7.5% MAC utilisation.

## Projection Assumptions

All HW numbers are PROJECTED from synthesis results, not measured via simulation.

1. Clock = 100 MHz (OpenLane timing: worst setup slack +0.289 ns at 10 ns period)
2. Useful ops/cycle = 1 MAC = 2 FLOPs (single-MAC compute core)
3. Projected throughput = 100 MHz x 2 FLOP/cycle x 7.5% utilisation = 0.0008 GFLOP/s
4. Memory bandwidth = 4 bytes/cycle x 100 MHz = 400 MB/s (32-bit AXI4-Lite)
5. Power = 0.69 mW (OpenLane power report, nom_tt_025C_1v80 corner)
