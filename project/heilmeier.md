# Heilmeier Questionnaire
## Project: SNN Hardware Accelerator
## ECE 410/510 Spring 2026 | Vanisri Kyatham
## Updated after Codefest 2 profiling

## Q1 - What are you trying to do?
We are designing a specialized hardware accelerator chip to speed up Spiking
Neural Networks (SNNs) running on edge devices such as sensors, mobile phones,
and autonomous systems. SNNs process information as sparse binary spikes like
biological neurons, making them naturally energy-efficient compared to traditional
deep neural networks. However, simulating SNNs in software is slow because
conventional CPUs are optimized for dense floating-point matrix operations, not
for sparse time-stepped spike propagation. Our goal is to build a chip that
directly implements the Leaky Integrate-and-Fire (LIF) neuron model in hardware
with on-chip weight storage and spike-driven dataflow, achieving fast and
energy-efficient SNN inference for real-time edge applications.

## Q2 - How is it done today and what are the limits?
Today SNNs are simulated on general-purpose CPUs using NumPy-based Python code.
Our software baseline (FC-LIF-SNN, 784->1000->10, MNIST, T=25 timesteps) runs
on an Apple M2 CPU and takes 74.6 seconds per 5-epoch training run.
Profiling across 10 runs identifies lif_layer_forward (snn.py:54) as the
dominant kernel consuming 79.0% of total runtime. The inner bottleneck is the
synaptic current computation I_syn = np.dot(W, spk_in[t]), a (1000x784) matrix
multiply executed 25 times per batch with the weight matrix W reloaded from
DRAM at every timestep. Roofline analysis reveals AI = 13.06 FLOP/byte, just
below the M2 CPU ridge point of 15.0 FLOP/byte, making the kernel memory-bound.
Attainable performance is only 1306 GFLOP/s. Every wasted cycle is caused by
redundant DRAM traffic for reloading the same weight matrix 25 times per
inference. This is an architectural problem that software cannot fix.

## Q3 - What is your approach and why is it better?
Our approach is a spike-driven systolic array accelerator with three key features:
1. On-chip weight SRAM: W (6.27MB) is loaded once from HBM and kept in on-chip
SRAM, reused across all T=25 timesteps. This raises AI from 13.06 to ~60
FLOP/byte, pushing the kernel from memory-bound to compute-bound.
2. Spike sparsity exploitation: Since spike activity is binary and sparse
(~10% firing rate), the hardware skips multiply-accumulate operations for
zero-valued spikes, reducing effective compute by ~10x and saving energy.
3. Pipelined LIF update: Membrane potential update, threshold comparison, and
reset are implemented as a 3-stage pipeline after the systolic array output,
eliminating the per-neuron Python loop overhead.
The accelerator targets 6000 GFLOP/s with 600 GB/s HBM bandwidth. With on-chip
weight caching AI=60 F/B exceeds the accelerator ridge point of 10 F/B, making
the kernel compute-bound and achieving ~5x throughput improvement over the M2
CPU baseline. Combined with spike sparsity, energy drops by additional 5-10x
making real-time SNN inference on edge devices practical.
