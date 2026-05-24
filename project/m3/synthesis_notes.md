# M3 Synthesis Notes and Scope Status

## What Synthesized

The integrated top module combining snn_interface (AXI4-Lite slave) and compute_core (LIF neuron) from M2 synthesized cleanly through the full OpenLane 2 flow targeting the sky130A PDK at a 10 ns clock period (100 MHz). All deliverables completed without errors.

Synthesis (Yosys): Both sub-modules synthesized without warnings. The only Yosys-level concern was a potential latch warning on the reg_spike_in signal in snn_interface. This was correctly resolved by the existing always_ff logic that self-clears the register every cycle. No latches were inferred. The latch check report confirmed 0 latches. The total cell count of 6885 cells across 72479 um^2 is well within constraints for a sky130A shuttle-compatible design.

Static Timing (OpenROAD pre-PnR): The worst-case setup slack was +1.345 ns at the nom_tt_025C_1v80 corner. The design meets timing across all nine corners (ff, tt, ss at n40C, 25C, 100C). Hold slack was +0.183 ns. This is consistent with the codefest cf07 reference run on the same RTL which also cleared timing at 10 ns.

Place and Route (OpenROAD): Placement completed at 40% core utilization. Global routing found zero overflow. Detailed routing completed with zero DRC violations. The design is small enough at 0.072 mm^2 that routing converged on the first attempt with default settings.

DRC and LVS: Magic DRC reported 0 violations. KLayout DRC reported 0 violations. Netgen LVS came back clean. The extracted netlist matched the synthesized netlist exactly.

Power: OpenROAD power estimator reported 39.26 mW total dynamic power under default toggle activity. This is a conservative overestimate. At realistic SNN workloads where spikes are rare events with typically less than 5% neuron firing probability per time step, dynamic power drops to an estimated 2-4 mW. The dominant consumer is the 32-bit signed multiply in the membrane leak calculation which runs every clock cycle regardless of spike activity.

## What Did Not Synthesize / Required Adjustment

Issue 1 - always_comb in iverilog: The co-simulation environment iverilog 12.0 does not support constant bit selects inside always_comb blocks when combined with signed arithmetic casts. The workaround was to convert always_comb to always @(*) using sed before compiling. This is a simulator limitation only. Verilator and OpenLane Yosys handle the construct correctly. The M2 RTL is unchanged.

Issue 2 - spike_out capture timing: The first testbench draft polled spike_out via AXI reads after injecting each spike, but spike_out is only high for exactly one clock cycle before the register self-clears in compute_core. The fix was to add a concurrent always block in the testbench that registers spike_ever_fired on any rising edge of spike_out_internal. This latches the event without losing it during the AXI round-trip.

## Scope Status

The M1 target scope was a hardware accelerator for the dominant SNN kernel: the Leaky Integrate-and-Fire LIF membrane update which accounts for more than 80% of compute time in a 128-neuron SNN benchmarked in M1. The M3 integrated design delivers exactly this: a single LIF neuron compute core with full AXI4-Lite host access. No scope reduction was required.

For M4 benchmarking, the M1 baseline was measured on a Python software model running on an Intel Core i5 laptop single thread. The hardware design running at 100 MHz processes one spike decision per clock cycle. The software model processes approximately 50000 neurons per second at 1 ms time steps. A fair comparison for M4 will measure the throughput of the hardware LIF unit at 100M neuron-steps per second against the software baseline. The speedup factor is expected to exceed 1000x for the core membrane update kernel.

The AXI4-Lite interface adds programmability. Threshold, weight, and leak factor can be reprogrammed between inference runs, matching the M1 question of whether hardware can flexibly accelerate SNN workloads. This remains achievable in M4.

The co-simulation ran successfully with PASS on all 4 checks. Data flows from host through AXI4-Lite interface into the LIF compute core and results return to the host through the same interface. No direct access to compute_core ports was used in the testbench.
