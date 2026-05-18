# M3 Plan — CF07 (Option B Fallback)

Since I synthesized the CF06 fallback (4×4 crossbar MAC), I plan to
attempt synthesis on my actual SNN Speedup Chip core by May 21, 2026,
before the M3 deadline of May 24.

The fallback produced 8,385 gates with $_AND_ (3,938) and $_XOR_ (2,938)
dominating at 47% and 35% respectively, confirming 8-bit MAC logic is
area-intensive even at 4×4 scale. For my SNN core, I expect a larger
flip-flop count due to per-neuron 16-bit membrane potential state registers
(LIF neurons require persistent state), but a simpler multiplier structure
since SNN weights are 1-bit (spike or no spike), which should reduce
$_AND_ and $_XOR_ counts significantly. I will target the same 10 ns
clock and run a full OpenLane flow with ABC and OpenSTA to get actual
slack numbers.

From this exercise I learned to read Yosys stat output, interpret the
SHARE and OPT_MERGE passes, and set up a synthesis flow from scratch.