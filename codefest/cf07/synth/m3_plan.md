# M3 Plan — CF07 (Option B Fallback)

Since I synthesized the CF06 fallback (4×4 crossbar MAC), I plan to
attempt synthesis on my actual SNN Speedup Chip core by May 21, 2026,
before the M3 deadline of May 24.

The fallback produced 8,385 gates dominated by $_AND_ and $_XOR_ cells,
confirming that 8-bit MAC logic is area-intensive even at 4×4 scale. For
my SNN core, I expect a larger flip-flop count due to per-neuron membrane
potential state registers (LIF neurons require persistent state), and a
simpler multiplier structure since SNN weights are typically 1-bit (spike
or no spike), which should reduce $_AND_ and $_XOR_ counts significantly.

From this exercise I learned to read Yosys stat output, identify dominant
cell types, and understand how the optimizer removes redundant logic. I
will apply this directly to evaluate my SNN core synthesis results.