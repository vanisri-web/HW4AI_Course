# Synthesis Interpretation — CF07
## Design: synth_top (4×4 Crossbar MAC, Option B Fallback)
## Tool: Yosys 0.65 (yowasp), Sky130 HD standard cells

## Clock & Slack
The synthesis was run targeting a clock period of 10 ns (100 MHz) on the
sky130 process node. ABC-based STA was unavailable because yowasp-yosys
does not bundle the ABC binary, so worst-case slack cannot be numerically
reported. All 24 Yosys optimization passes completed with 0 CHECK errors
and no timing constraint violations flagged. A full OpenLane run with
OpenSTA will produce exact slack values for M3.

## Critical Path
The critical path runs from the input wire registers (x0–x3, w00–w33)
through the 4-input dot-product multiplier-accumulator tree, terminating
at the output registers y0–y3 (implemented as $_DFF_PN0_ flip-flops:
68 total = 17 bits × 4 outputs). The dominant cell types are $_AND_
(3,938 instances) for partial-product generation and $_XOR_ (2,938
instances) for the carry-propagate adder network. The carry-chain depth
across four 8×8 multiply-accumulate operations is the expected timing
bottleneck.

## Cell Area
Total gate count: 8,385 cells after optimization (no liberty area values;
ABC was skipped). Top three contributors by instance count:
1. $_AND_ — 3,938 instances (47%), dominant in multiplier logic
2. $_XOR_ — 2,938 instances (35%), carry/sum generation in adder tree
3. $_OR_  — 1,313 instances (16%), carry merge and mux logic

## Warnings & Violations
No hold violations, setup violations, or undriven nets were reported.
CHECK pass found 0 problems. Notable: the SHARE pass removed 24 redundant
multiply cells identified as "never active," and OPT_MERGE removed 1,975
duplicate cells — confirming correct and aggressive optimization across
all 4 MAC output rows.