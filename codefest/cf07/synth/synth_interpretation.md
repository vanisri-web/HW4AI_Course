# Synthesis Interpretation — CF07
## Design: synth_top (4×4 Crossbar MAC, Option B Fallback)
## Tool: OpenLane 2.3.10, Yosys 0.65, OpenROAD, Sky130 HD

## Clock & Slack
The design was synthesized and placed-and-routed at a clock period of
15 ns (66 MHz) on the sky130 HD process. At the nominal corner
(25°C, 1.8V), the worst-case setup slack is +5.24 ns and worst-case
hold slack is +1.77 ns — timing is fully met. At the slow corner
(100°C, 1.6V), setup slack is -1.13 ns, improved significantly from
-4.708 ns at the original 10 ns clock target. For M3, the clock period
will be further relaxed to 20 ns to fully close timing across all corners.

## Critical Path
The critical path runs from input registers (x0–x3, w00–w33) through
the 4-input MAC accumulator tree, terminating at output registers y0–y3
(sky130_fd_sc_hd__dfrtp_1, 68 instances = 17 bits × 4 outputs). The
dominant cell types along the path are xnor2 (1,124 instances) and
xor2 (529 instances) for carry/sum generation, and nand2 (557 instances)
for partial-product logic. The resizer inserted 836 timing-repair buffers
to help close setup timing.

## Cell Area
Total cell area: 59,288.1 µm² across 9,690 standard cell instances
on a die of 391.8 × 402.5 µm. Top three contributors by instance count:
1. sky130_fd_sc_hd__xnor2 — 1,124 instances, carry/sum logic
2. sky130_fd_sc_hd__nand2 — 557 instances, partial-product logic
3. sky130_fd_sc_hd__xor2  — 529 instances, adder tree

## Warnings & Violations
Setup violations remain at slow corner (100°C, 1.6V): worst slack
-1.13 ns, improved from -4.71 ns at 10 ns clock. No hold violations
in any corner. DRC passed with 0 errors. LVS passed. Antenna violations:
8 nets/pins flagged with 27 diodes inserted to mitigate. Max fanout
violations: 4 nets. These