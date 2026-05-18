# Synthesis Interpretation — CF07
## Design: synth_top (4×4 Crossbar MAC, Option B Fallback)
## Tool: Yosys 0.65 (yowasp), Sky130 HD standard cells

## Clock & Slack
The synthesis was run targeting a clock period of 10 ns (100 MHz) on the
sky130 process node. Since ABC-based STA was unavailable in this environment,
worst-case slack could not be directly reported. No timing constraint
violations were flagged during the synthesis passes. The design passed all
CHECK pass validations with 0 problems reported.

## Critical Path
The critical path runs through the 4-input dot-product MAC logic: input
registers feed into the multiplier tree, which chains through adder logic
before writing to output registers (y0–y3). The dominant cell types along
this path are $_XOR_ (2,938 instances) and $_AND_ (3,938 instances),
which form the carry-propagate adder network for the accumulation tree.
The sink registers are the four $_DFF_PN0_ output flip-flop banks (68
total flip-flops, 17 bits × 4 outputs).

## Cell Area
Total gate count: 8,385 cells after optimization. The top three
contributors are:
1. $_AND_ — 3,938 instances (47% of total), dominant in multiplier logic
2. $_XOR_ — 2,938 instances (35% of total), carry/sum generation in adders
3. $_OR_ — 1,313 instances (16% of total), carry merge and mux logic

## Warnings & Violations
No hold violations, undriven nets, or failed constraints were reported.
The CHECK pass found 0 problems. One notable observation: the SHARE pass
identified 16 multiply cells as "never active" due to combinational
constant-folding, removing 24 redundant cells — indicating the optimizer
correctly identified shared MAC structure across the 4 output rows.