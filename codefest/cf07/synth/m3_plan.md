# M3 Plan — CF07 CLLM
## Design: SNN LIF Neuron Compute Core
**Author:** Vanisri Kyatham | ECE 510 Spring 2026

This synthesis used Option A (project compute core, synth_top.sv).

The WNS of 0.0 ns at 15 ns means timing is met with zero margin. For M3, the clock target was tightened to 10 ns (100 MHz), which the M3 run confirmed with WNS of +0.289 ns.

The critical path bottleneck is the unpipelined 16x16 fixed-point multiplier for membrane leak, evidenced by 1,124 xnor2 instances. This is kept unpipelined for M3 since timing closes at 10 ns. The high-fanout x0[0] input (fanout 71) will be addressed by restructuring the AXI write path.

Q8.8 fixed-point is retained as quantization error is within acceptable bounds. No precision reduction needed. M3 target: sky130A at 10 ns with combined compute_core and snn_interface top module.
