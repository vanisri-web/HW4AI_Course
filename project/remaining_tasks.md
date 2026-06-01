# Remaining Tasks Before M4

1. Replace the serial single-MAC datapath in compute_core.sv with a 16-wide
   parallel MAC array to increase ops/cycle from 2 FLOP to 32 FLOP, targeting
   a projected throughput of 3.2 GFLOP/s at 100 MHz instead of 0.2 GFLOP/s.

2. Add a 32-bit cycle counter register mapped to AXI4-Lite address 0x20 in
   interface.sv so that cocotb can read elapsed clock cycles after a 1000x784
   MVM invocation, converting the projected throughput to a measured number.

3. Replace the AXI4-Lite weight-loading interface with an AXI4-Stream burst
   input in interface.sv to reduce per-weight handshake latency from 4 cycles
   to 1 cycle, raising effective memory bandwidth toward 400 MB/s.
