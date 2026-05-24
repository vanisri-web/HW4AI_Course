# Critical Path Analysis

## Path
Start: u_compute_core.membrane[7] (rising-edge FF, output Q)
End:   u_compute_core.membrane[15] (rising-edge FF, input D)
Delay: 8.655 ns | Slack: +1.345 ns (MET)

## Logic Stages (14 total)
1. membrane[7] FF output Q
2-6. Signed multiply: membrane x leak_factor - Wallace tree xnor2/xor2 cells
7. Arithmetic right shift 15 bits with sign mux
8-10. Saturating adder: add weight if spike_in
11-13. Saturation clamp: compare vs +32767 and -32768
14. membrane[15] FF input D

## Why Critical
Three arithmetic operations chain in one cycle: 32-bit signed multiply plus 15-bit shift plus 16-bit saturating add. The multiply dominates at ~6ns of the 8.655ns total.

## What Would Shorten It
1. Pipeline the multiply with a register between multiplier and adder. Enables >200 MHz. Tradeoff: one extra cycle latency.
2. Reduce to 8-bit fixed-point. Precision analysis in m2/precision.md shows this is sufficient.
