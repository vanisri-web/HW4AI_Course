# Project Scope Assessment
**Student:** Vanisri Kyatham
**Project:** SNN Speedup Chip
**Course:** ECE 410/510 — Hardware for AI/ML, Spring 2026

## Initial Scope
My project focuses on designing a hardware accelerator for Spiking Neural
Networks (SNNs). The core idea is to exploit the sparse, event-driven
nature of SNN computation to reduce energy and latency compared to
traditional neural network accelerators.

## CF07 Scope Update — May 17, 2026

Synthesis of the CF06 fallback 4×4 crossbar MAC produced 8,385 gates
(3,938 AND, 2,938 XOR, 1,313 OR, 68 DFF) at 100 MHz target on sky130.
This confirms that even a small 4×4 MAC is gate-intensive at 8-bit
precision. Based on this, I am narrowing my SNN core scope to 8 LIF
neurons with 1-bit spike weights to keep gate count manageable and
ensure positive timing slack for M3. Full chip integration will be
deferred to post-M3 if timing permits.