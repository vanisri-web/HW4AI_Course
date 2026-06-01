# Project Scope Assessment
## Project: SNN LIF Neuron Speedup Chip
**Author:** Vanisri Kyatham | ECE 510 Spring 2026
**Updated:** CF07 post-synthesis

## Scope Confirmed

The project scope remains a single-neuron LIF compute core with AXI4-Lite
host interface, targeting sky130A at 100 MHz. Synthesis results from CF07
confirm this scope is achievable: the compute core synthesizes cleanly to
6885 cells and 72479 um2 at 15 ns with WNS of 0.0 ns. The M3 run at
10 ns achieved WNS of +0.289 ns confirming 100 MHz is feasible.

No scope reduction is required. The original goal of accelerating the
dominant SNN kernel which is the LIF membrane update at 79 percent of
SW runtime is confirmed by synthesis. The design implements exactly the
membrane times leak plus weight operation in hardware. The 1124 xnor2
cells confirm the multiplier is present and functional.

For M4, scope will extend to a 1000-entry weight SRAM to support the
full 784 to 1000 FC-LIF layer benchmarked in M1, replacing the single
register interface that currently limits end-to-end throughput.
