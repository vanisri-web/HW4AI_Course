# Synthesis Interpretation — CF07 CLLM
## Design: SNN LIF Neuron Compute Core (synth_top)
**Author:** Vanisri Kyatham | ECE 510 Spring 2026
**Tool:** OpenLane 2 | **PDK:** sky130A | **Corner:** nom_tt_025C_1v80

## (a) Clock Period and Worst-Case Slack

The design was synthesized at a 15 ns clock period (66.7 MHz). At the
nom_tt_025C_1v80 corner, the Worst Negative Slack (WNS) is 0.0 ns and
Total Negative Slack (TNS) is 0.0 ns — timing is exactly met with zero
margin. This means the design is right at the edge of meeting timing.
The zero-slack result is consistent across the nominal corner.

## (b) Critical Path

Source: Input port x0[0] (external input, fanout 71)
Sink: Register _13667_ (rising-edge flip-flop, clocked by clk)
Total path delay: approximately 13 ns

The critical path starts at input x0[0] which drives 71 fanout loads.
This high-fanout net contributes 0.62 ns of delay alone. The path then
traverses a deep chain of combinational logic implementing the 16x16
fixed-point multiply-accumulate for membrane leak computation. Dominant
cell types along the path are or3_2 (0.47-0.63 ns each), a21o_2 (0.22 ns),
o211a_2 (0.26-0.33 ns), and a211o_2 (0.31-0.39 ns). The multiply carries
propagate through roughly 20 stages without any pipeline register.

## (c) Total Cell Area and Top Contributors

Total chip area: 72,479.5 um2
Sequential elements: 1,786.7 um2 (2.47%)
Total cell count: 6,885

Top three contributors by instance count:
1. sky130_fd_sc_hd__xnor2_2 — 1,124 instances — Wallace tree multiplier
2. sky130_fd_sc_hd__nand2_2 — 557 instances — adder carry logic
3. sky130_fd_sc_hd__nor2_2  — 537 instances — comparator and accumulator

The xnor2 dominance confirms the multiplier is the area bottleneck.

## (d) Warnings and Constraints

No hold violations. No latches inferred. The zero WNS at 15 ns is a
concern — the design barely passes timing with no margin. The high fanout
of 71 on input x0[0] is a warning: this net should be buffered to reduce
slew. No failed constraints were reported.
