# Milestone 2 - SNN Speedup Chip
Author: Vanisri Kyatham
Course: ECE 410/510 - Hardware for AI/ML, Spring 2026

## Prerequisites
Tool: Icarus Verilog version 12.0
Install: sudo apt install iverilog
Python3 with numpy: pip3 install numpy --break-system-packages

## Step 1 - Clone and enter M2 folder
git clone https://github.com/vanisri-web/HW4AI_Course.git
cd HW4AI_Course/project/m2

## Step 2 - Run Compute Core Testbench
iverilog -g2012 -o sim_compute rtl/compute_core.sv tb/tb_compute_core.sv
vvp sim_compute
Expected: PASS All 8 checks passed.

## Step 3 - Run Interface Testbench
Note: Module is named snn_interface inside interface.sv because
interface is a reserved keyword in SystemVerilog IEEE 1800-2012.
The file is named interface.sv as required by the grader checklist.
iverilog -g2012 -o sim_interface rtl/interface.sv tb/tb_interface.sv
vvp sim_interface
Expected: PASS All 4 checks passed.

## Step 4 - Run Precision Analysis Script
python3 precision_analysis.py
This script independently computes Q8.8 quantization errors over
100 samples and verifies the acceptability threshold in precision.md.

## Simulator
Icarus Verilog version 12.0 stable
Flag: -g2012
Tested on: Ubuntu 24.04 WSL2

## Deviations from M1
No deviations. AXI4-Lite interface, LIF neuron kernel, Q8.8 precision unchanged.

## File Structure
project/m2/rtl/compute_core.sv     - LIF neuron RTL synthesizable
project/m2/rtl/interface.sv        - AXI4-Lite slave RTL synthesizable
project/m2/tb/tb_compute_core.sv   - Compute core testbench
project/m2/tb/tb_interface.sv      - Interface testbench
project/m2/sim/compute_core_run.log - PASS All 8 checks passed
project/m2/sim/interface_run.log    - PASS All 4 checks passed
project/m2/sim/waveform.png         - Annotated LIF neuron waveform
project/m2/precision_analysis.py    - 100 sample Q8.8 error analysis
project/m2/precision.md             - Numerical format and error analysis
project/m2/README.md                - This file
