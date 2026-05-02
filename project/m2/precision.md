# Numerical Precision and Data Format - SNN Compute Core

Project: Spiking Neural Network (SNN) Speedup Chip
Course: ECE 410/510 - Hardware for AI/ML, Spring 2026
Author: Vanisri Kyatham

## 1. Chosen Numerical Format

The compute core uses Q8.8 signed fixed-point (16-bit) for membrane potential,
synaptic weights, and firing threshold. The leak factor uses Q1.15 (16-bit).

- Membrane / Weight / Threshold: 16-bit signed, 8 integer bits, 8 fractional bits.
  Range: -128.0 to +127.996, step = 1/256 = 0.0039.
- Leak factor: 16-bit, 1 integer bit, 15 fractional bits.
  Range: 0.0 to 1.99997, step = 1/32768 = 0.0000305.

## 2. Rationale

Spiking Neural Networks are event-driven: neurons accumulate weighted spike
contributions and compare against a threshold. Operations are simple additions
and one multiply-per-cycle for leak decay. Fixed-point is preferred because:

- Lower area and power: A 16x16-bit fixed-point multiplier uses roughly 4x less
  area than an IEEE-754 FP32 multiplier in a 28nm process. This matches the
  energy-efficiency goals of the SNN chip for edge deployment.
- Deterministic latency: Fixed-point arithmetic has no rounding normalization
  loop, giving a single-cycle critical path.
- No denormals or NaN: Edge hardware avoids IEEE-754 special value overhead.

## 3. Why Q8.8 Specifically?

From M1 roofline analysis, membrane potentials for LIF models lie in [-64, +64]
and typical synaptic weights cluster in [-8, +8]. The 8 integer bits give a safe
range up to +/-128 with clamping. The 8 fractional bits give step = 1/256 = 0.0039,
sufficient to represent sub-threshold potential increments accurately.

Why not Q4.12? Narrowing integer field to 4 bits risks overflow for large
accumulations. The marginal benefit in fractional resolution does not improve
SNN accuracy because spike timing is discrete at the cycle level.

Why not FP16 or BF16? These add 2-3 pipeline stages and more area. For a
single-neuron accelerator at M2 stage, fixed-point is correct. FP16 may be
revisited at M3 if multi-layer weights need dynamic range wider than +/-128.

## 4. Why Q1.15 for Leak?

The leak factor is always <= 1.0. Q1.15 gives 32768 distinct values in [0,1),
sufficient to represent any practical time constant with sub-0.004% error.

Common leak values:
- 0.90 maps to 0x7333, error less than 0.004%
- 0.95 maps to 0x7999, error less than 0.004%
- 0.99 maps to 0x7EB8, error less than 0.003%

## 5. Quantization Error Analysis

Reference values computed in Python using float64, compared to Q8.8 output
across 100 test samples with random weights in [-4, 4], threshold=6.0, leak=0.99.

Results:
- Mean absolute error (weight, Q8.8): 0.001953
- Max error (weight, Q8.8):           0.003906
- Leak factor error (Q1.15 vs FP64):  0.000031

For membrane accumulation over 10 spike steps, maximum accumulated error is
bounded by: 10 x 0.003906 = 0.0391, which is less than 1/26th of threshold 6.0.

## 6. Acceptability Statement

The Q8.8 / Q1.15 fixed-point representation is acceptable because:

1. Maximum quantization error in membrane potential is less than 0.7% of
   threshold, within the sub-1% spike timing jitter tolerance for LIF-based
   SNN classifiers (Rathi et al., Front. Neurosci., 2020).
2. Arithmetic is lossless for M2 testbench vectors since weights are exact
   multiples of 2.0 in Q8.8 and threshold is an exact integer.
3. Format uses 16-bit operands keeping memory bandwidth at 2 bytes per weight,
   consistent with M1 roofline arithmetic intensity assumption.
4. No overflow occurs for tested range; clamping logic prevents wrap-around.

This analysis will be extended at M3 with full network-level accuracy evaluation
against an FP32 PyTorch baseline.
