# Milestone 2 - SNN Speedup Chip
Author: Vanisri Kyatham
Course: ECE 410/510 Spring 2026

## Run Compute Core Testbench
iverilog -g2012 -o sim_compute rtl/compute_core.sv tb/tb_compute_core.sv
vvp sim_compute
Expected: PASS All 8 checks passed.

## Run Interface Testbench
sed 's/^module interface/module snn_interface/' rtl/interface.sv > /tmp/snn_interface.sv
iverilog -g2012 -o sim_interface /tmp/snn_interface.sv tb/tb_interface.sv
vvp sim_interface
Expected: PASS All 4 checks passed.

## Simulator
Icarus Verilog version 12.0
Install: sudo apt install iverilog

## Deviations from M1
No deviations. AXI4-Lite interface, LIF neuron kernel, Q8.8 precision unchanged.
