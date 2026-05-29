# M3 Plan — CF07 CLLM
## Design: SNN LIF Neuron Compute Core
**Author:** Vanisri Kyatham | ECE 510 Spring 2026

This synthesis used Option A (project compute core, compute_core.sv).

The WNS of 0.0 ns at 15 ns means timing is met but with zero margin.
For M3, the clock period was tightened to 10 ns (100 MHz) to match the
M3 target. The M3 synthesis confirmed this works with WNS of +0.289 ns.

The critical path bottleneck is the unpipelined 16x16 fixed-point
multiplier for membrane leak. The 1,124 xnor2 instances confirm this.
For M3, the membrane leak multiply is kept unpipelined but the
high-fanout input x0[0] (fanout 71) is addressed by restructuring the
AXI write path to reduce fan-out at the spike input pin.

The Q8.8 fixed-point format is retained because the 0.65 percent
quantization error is within acceptable bounds for LIF spike timing.
No precision reduction is needed. The target remains sky130A at 10 ns
with the integrated top module combining compute_core and snn_interface.
