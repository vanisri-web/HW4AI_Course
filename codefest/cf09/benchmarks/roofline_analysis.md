# Roofline Analysis - CF09

The 3x3 CONV2D kernel has an arithmetic intensity ranging from 1.18 FLOP/byte
(lower bound, no data reuse, including output writes) to 2.87 FLOP/byte (upper
bound, full weight reuse, pixels streamed, outputs written). The sky130 ridge
point is 2.42 FLOP/byte (800 MOPS / 330 MB/s).

At AI = 1.18, the kernel is memory-bound, sitting left of the ridge. Attainable
performance = 330 x 1.18 = 389 MOPS. At AI = 2.87, the kernel is compute-bound,
sitting just right of the ridge. Attainable performance = 800 MOPS (compute
ceiling). The kernel straddles the ridge point depending on reuse pattern.

Despite being near the compute ceiling at the upper bound, the projected
throughput of 0.0008 GFLOP/s is far below 800 MOPS. The gap is caused entirely
by the AXI4-Lite interface bottleneck: only 9 of every 120 cycles perform actual
MAC computation giving 7.5% utilisation. The dominant uncertainty in this
projection is the ops/cycle assumption. Synthesis confirms timing closure at
10 ns but does not count actual MAC completions. Adding a cycle counter register
at AXI4-Lite address 0x20 and reading it via cocotb after a representative
900-patch inference would convert this projection to a real measurement.
