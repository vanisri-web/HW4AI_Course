# M4 Deliverables — SNN LIF Neuron Accelerator
## ECE 410/510 Spring 2026 | Vanisri Kyatham

| File | Description | Checklist Item |
|------|-------------|----------------|
| README.md | This file — catalogs all M4 files | Section 1 README |
| rtl/top.sv | Top module integrating interface + compute core | Section 2 Source code |
| rtl/compute_core.sv | LIF neuron MAC compute core Q8.8 fixed-point | Section 2 Source code |
| rtl/interface.sv | AXI4-Lite slave interface snn_interface module | Section 2 Source code |
| tb/tb_top.sv | End-to-end co-simulation testbench | Section 2 Testbench |
| sim/final_run.log | Co-simulation log showing PASS verdict | Section 2 Sim log |
| sim/final_waveform.png | Annotated waveform reset compute readback | Section 2 Waveform |
| synth/config.json | OpenLane 2 configuration 10ns clock sky130 | Section 3 Synthesis |
| synth/openlane_run.log | Full OpenLane 2 stdout/stderr | Section 3 Synthesis |
| synth/timing_report.txt | STA: WNS +0.289ns MET at 100 MHz | Section 3 Timing |
| synth/area_report.txt | Area: 1984 cells 20682 um^2 | Section 3 Area |
| synth/power_report.txt | Power: 0.69 mW nom_tt_025C_1v80 | Section 3 Power |
| bench/benchmark.md | Throughput speedup energy comparison | Section 4 Benchmark |
| bench/benchmark_data.csv | Raw numbers behind benchmark.md | Section 4 Raw data |
| bench/roofline_final.png | Final roofline plot projected HW point labeled | Section 4 Roofline |
| report/design_justification.pdf | 9-section design justification report | Section 5 Report |
| report/figures/waveform.png | Waveform figure referenced in report | Section 5 Figures |
| report/figures/roofline.png | Roofline figure referenced in report | Section 5 Figures |
| report/figures/block_diagram.png | Block diagram figure referenced in report | Section 5 Figures |

## RTL Changes from M3
The RTL files in project/m4/rtl/ are identical to project/m3/rtl/.
No functional changes were made. These are the exact versions used for
the OpenLane 2 synthesis run that produced the reports in project/m4/synth/.

## Reproduction Instructions
Simulator: Icarus Verilog iverilog 12.0

    cd project/m4
    iverilog -g2012 -o sim/cosim rtl/top.sv rtl/interface.sv rtl/compute_core.sv tb/tb_top.sv
    cd sim && vvp cosim | tee final_run.log

Expected output ends with: PASS
