# M3 Deliverables - SNN LIF Neuron Chip

## File Catalog
| Path | Description |
|---|---|
| README.md | This file - M3 folder index and reproduction instructions |
| rtl/top.sv | Integrated top module: instantiates snn_interface + compute_core |
| tb/tb_top.sv | End-to-end co-simulation testbench; AXI4-Lite master only |
| sim/cosim_run.log | Co-simulation transcript with PASS verdict |
| sim/cosim_waveform.vcd | VCD waveform from simulation |
| synth/config.json | OpenLane 2 configuration |
| synth/openlane_run.log | Full OpenLane 2 stdout/stderr |
| synth/timing_report.txt | STA report: setup slack +1.345ns MET |
| synth/area_report.txt | Area: 6885 cells, 72479 um^2 |
| synth/critical_path.md | Critical path analysis |
| synth/power_report.txt | Power estimate: 39.26 mW |
| synthesis_notes.md | Narrative: what worked, issues, scope status |

## Co-Simulation Reproduction
Simulator: Icarus Verilog (iverilog) 12.0

    cd project/m3
    sed 's/always_comb/always @(*)/g' ../m2/rtl/compute_core.sv > /tmp/cc_sim.sv
    iverilog -g2012 -o sim/cosim rtl/top.sv ../m2/rtl/interface.sv /tmp/cc_sim.sv tb/tb_top.sv
    cd sim && vvp cosim | tee cosim_run.log

Expected output ends with: PASS

## OpenLane 2 Synthesis Reproduction
OpenLane 2 version: v2.1.9

    cd project/m3
    docker run -it -v $(pwd):/work efabless/openlane2:latest python -m openlane /work/synth/config.json
