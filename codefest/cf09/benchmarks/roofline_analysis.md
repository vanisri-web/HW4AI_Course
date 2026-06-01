# Roofline Analysis - CF09

The LIF synaptic current kernel has an arithmetic intensity ranging from
0.57 FLOP/byte (lower bound, no data reuse) to 13.06 FLOP/byte (upper bound,
full weight reuse across T=25 timesteps). The sky130 ridge point is 0.5
FLOP/byte, so at both bounds the kernel falls in the compute-bound region of
the sky130 roofline.

Despite being compute-bound, the projected peak throughput of 0.2 GFLOP/s is
far below the M2 CPU baseline attainable performance of 1306 GFLOP/s. The gap
is not caused by memory bandwidth. The AXI4-Lite interface at 400 MB/s is
sufficient for this kernel memory traffic. The bottleneck is the single-MAC
serial compute core where only one multiply-accumulate executes per clock
cycle, yielding no data-level parallelism. The compute ceiling is set purely
by this single-MAC throughput at 100 MHz.

Since the projected path was used, the dominant uncertainty is the ops/cycle
assumption. The synthesis confirms timing closure at 10 ns but does not count
actual MAC completions per cycle. FSM control overhead and AXI4-Lite handshake
latency will reduce effective throughput below the projected 0.2 GFLOP/s.
Converting this to a real measurement requires adding a cycle counter register
to the design and reading it via cocotb after a representative 1000x784 MVM.
