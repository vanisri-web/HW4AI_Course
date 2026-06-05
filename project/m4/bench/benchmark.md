# Benchmark Comparison — M4 Final

## Measurement Method
- SW baseline: measured on Apple M2 CPU (Python/NumPy, 10 runs averaged)
- HW accelerator: PROJECTED from synthesis (OpenLane 2, sky130, 100 MHz)
  All hardware numbers are labeled PROJECTED — derived from cycle-count
  analysis and synthesis reports, not from physical FPGA/ASIC measurement.

## Throughput

| Metric | SW Baseline (measured) | HW Accelerator (projected) |
|--------|------------------------|----------------------------|
| Runtime (5 epochs) | 74.6 s | ~37,240 s (projected) |
| Throughput | 0.052 GFLOP/s | 0.0008 GFLOP/s (projected) |
| Clock | N/A | 100 MHz (projected) |
| Power | N/A | 0.69 mW (projected) |

## Speedup vs M1 Baseline

- M1 baseline time: 74.6 s (measured)
- M4 accelerator time: ~37,240 s (projected)
- Speedup = 74.6 / 37,240 = 0.002x (projected)

The accelerator is slower than software. The single-MAC compute core
processes one multiply-accumulate per cycle. AXI4-Lite bus overhead
consumes 45 of every 46 cycles, giving only ~7.5% MAC utilization.

## Energy (projected)

- Power: 0.69 mW (projected, OpenLane nom_tt_025C_1v80)
- Runtime per inference: ~0.621 s (projected)
- Energy per inference: 0.69 mW x 0.621 s = 0.429 mJ (projected)

## Raw Data
See benchmark_data.csv for all underlying numbers.
