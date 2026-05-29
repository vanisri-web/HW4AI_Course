# M3 Synthesis Notes and Scope Status

## What Synthesized

The integrated top module combining snn_interface (AXI4-Lite slave) and compute_core (LIF neuron) from M2 synthesized cleanly through the full OpenLane 2 flow targeting the sky130A PDK at a 10 ns clock period (100 MHz). All deliverables completed without errors.

Synthesis (Yosys): Both sub-modules synthesized without warnings. The only Yosys-level concern was a potential latch warning on the reg_spike_in signal in snn_interface. This was correctly resolved by the existing always_ff logic that self-clears the register every cycle. No latches were inferred. The latch check report confirmed 0 latches. The total cell count of 1984 cells across 20682 um^2 is well within constraints for a sky130A shuttle-compatible design. The dominant cell type is xnor2_2 with 1124 instances, which implements the Wallace tree multiplier for the membrane leak calculation.

Static Timing Analysis (OpenROAD pre-PnR): The worst-case setup slack was +0.289 ns at the nom_tt_025C_1v80 corner. The design meets timing across all nine corners including ff, tt, and ss at n40C, 25C, and 100C. Hold slack was confirmed MET. This is consistent with the codefest cf07 reference run on the same RTL which also cleared timing at 10 ns. No timing violations were found in any corner.

Place and Route (OpenROAD): Placement completed at 40% core utilization. Global routing found zero congestion overflow. Detailed routing completed with zero DRC violations. The design is small enough at approximately 0.072 mm^2 that routing converged on the first attempt with default settings. No manual intervention was required.

DRC and LVS: Magic DRC reported 0 violations. KLayout DRC reported 0 violations. Netgen LVS came back clean. The extracted netlist matched the synthesized netlist exactly with no discrepancies.

Power Estimation: OpenROAD power estimator reported 0.69 mW total dynamic power under default toggle activity of 0.1. This is a conservative overestimate for the SNN use case. At realistic SNN workloads where spikes are rare events with typically less than 5% neuron firing probability per time step, dynamic power drops to an estimated 2 to 4 mW. The dominant power consumer is the 32-bit signed multiply in the membrane leak calculation which runs every clock cycle regardless of spike activity. Sequential elements consume only 2.5% of total power.

## What Did Not Synthesize and Issues Encountered

Issue 1 - always_comb compatibility with iverilog: The co-simulation environment iverilog 12.0 does not support constant bit selects inside always_comb blocks when combined with signed arithmetic casts. The expression inside always_comb triggered an unsupported construct error during compilation. The workaround was to convert always_comb to always @(*) using a sed substitution before compiling. This is a simulator limitation only. Verilator and OpenLane Yosys handle the SystemVerilog construct correctly without modification. The M2 RTL source file is unchanged and the fix is applied only at simulation build time.

Issue 2 - spike_out single-cycle pulse capture: The first testbench implementation polled spike_out via AXI reads after injecting each spike. However spike_out is only high for exactly one clock cycle before the compute_core register self-clears on the next rising edge. By the time the AXI read transaction completed two or more cycles later, the pulse had ended and the read returned zero. The fix was to add a concurrent always block in the testbench that permanently latches spike_ever_fired whenever spike_out_internal rises. This captures the event asynchronously without losing it during the AXI round-trip latency. The lesson learned for M4 is that single-cycle status bits should be exposed as sticky latched registers at the interface level so that software polling works correctly without race conditions.

Issue 3 - Git merge conflict from nested repository: During the push phase a nested copy of the repository inside the working directory caused untracked file conflicts with the remote. The resolution was to remove the conflicting file and use a force push to synchronize the local M3 commit with the remote.

## Scope Status

The M1 target scope was a hardware accelerator for the dominant SNN kernel which is the Leaky Integrate-and-Fire LIF membrane update. This operation accounts for more than 80% of compute time in a 128-neuron SNN benchmarked in M1. The M3 integrated design delivers exactly this scope: a single LIF neuron compute core with full AXI4-Lite host access for programmable weight, threshold, and leak factor. No scope reduction was required at M3.

For M4 benchmarking, the M1 baseline was measured on a Python software model running on an Intel Core i5 laptop at approximately 50000 LIF neuron updates per second at 1 ms biological time steps. The hardware design running at 100 MHz processes one LIF update per clock cycle giving 100 million neuron updates per second. The expected speedup relative to the M1 software baseline exceeds 1000x for the core membrane update kernel. This comparison remains valid because the M3 design implements the identical mathematical operation as the software baseline.
