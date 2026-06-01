# Benchmark Results - CF09

## Platform Comparison

| Metric | SW Baseline (M2 CPU) | HW Accelerator (sky130, projected) |
|--------|----------------------|------------------------------------|
| Execution time | 74.6 s (5 epochs) | ~37,240 s (projected, serial MAC) |
| Throughput | ~1306 GFLOP/s (attainable) | 0.2 GFLOP/s (projected) |
| Memory usage | ~6.1 MB | Not yet measured |
| Clock frequency | N/A | 100 MHz (from synthesis) |
| Power | N/A | 0.69 mW (from OpenLane) |

## Speedup Computation

Speedup = HW projected throughput / SW baseline throughput
= 0.2 GFLOP/s / 1306 GFLOP/s = 0.00015x

The accelerator is currently slower than software because the compute core
processes one MAC per cycle with no parallelism. This is expected at this
design stage.

## Projection Assumptions

All HW numbers are PROJECTED from synthesis results, not measured via simulation.

1. Clock = 100 MHz (OpenLane timing: worst setup slack +0.289 ns at 10 ns period)
2. Useful ops/cycle = 1 MAC = 2 FLOPs (single-MAC compute core)
3. Projected throughput = 100 MHz x 2 FLOP/cycle = 0.2 GFLOP/s
4. Memory bandwidth = 4 bytes/cycle x 100 MHz = 400 MB/s (32-bit AXI4-Lite)
5. Power = 0.69 mW (OpenLane power report, nom_tt_025C_1v80 corner)
