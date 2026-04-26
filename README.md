Name: Vanisri Kyatham

Course: Hardware for Artificial Intelligence and Machine Learning

Term: Spring 2026


Tentative Project Topic: Spiking Neural Network Speedup Chip

Project Description:

My tentative project focuses on designing a hardware chip that can speed up Spiking Neural Networks (SNNs). Unlike traditional neural networks, SNNs work more like the human brain by sending information in the form of spikes or signals only when needed. This makes them more energy-efficient and suitable for real-time applications.
The goal of this project is to explore how specialized hardware can improve the performance and efficiency of SNNs. I plan to study existing architectures and identify ways to reduce computation time and power consumption. This may include optimizing data flow, memory usage, and parallel processing on the chip.
This project is important because energy-efficient AI hardware is becoming increasingly necessary for edge devices such as sensors, mobile devices, and autonomous systems. By improving the speed and efficiency of SNNs, this work could contribute to more sustainable and faster AI systems.
## Project HDL — SNN LIF Neuron Accelerator

### Module: lif_neuron.sv
Located in `project/hdl/lif_neuron.sv`

This module implements a Leaky Integrate-and-Fire (LIF) neuron in
synthesizable SystemVerilog. It is the core compute unit of the
SNN hardware accelerator. On each clock cycle it accumulates
synaptic current into a membrane potential register, applies a
leak, and fires a spike when the threshold is crossed.

**Parameters:**
- DATA_WIDTH = 8 (INT8 synaptic input)
- MEM_WIDTH = 32 (32-bit membrane potential accumulator)

**Ports:**
- clk, rst: clock and active-high synchronous reset
- i_syn: INT8 signed synaptic current input
- spike_in: binary spike enable signal
- spike_out: output spike signal
- v_mem: 32-bit membrane potential register

### Interface Choice: AXI4
The accelerator uses AXI4 on-chip bus with HBM2e external memory.

### Precision: INT8
Synaptic weights and inputs use INT8 precision.

### Interface Justification
The software baseline shows arithmetic intensity of 13.06 FLOP/byte
on the M2 CPU, making the kernel memory-bound. The dominant kernel
is I_syn = W * spk_in, a 1000x784 matrix multiply run 25 times per
inference. To reach the target of 6000 GFLOP/s the accelerator
needs at least 100 GB/s bandwidth. AXI4 with HBM2e provides
460 GB/s — a 4.6x safety margin — keeping the compute array
compute-bound at arithmetic intensity of 60 FLOP/byte with
on-chip weight caching. SPI and DDR5 were rejected as insufficient.
