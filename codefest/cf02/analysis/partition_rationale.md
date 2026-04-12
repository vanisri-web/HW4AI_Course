# HW/SW Partition Rationale

## Project: SNN Hardware Accelerator

## ECE 410/510 Spring 2026 | Vanisri Kyatham

## (a) Which kernel to accelerate and why

The kernel selected for hardware acceleration is lif\_layer\_forward (snn.py:54).
Profiling across 10 runs shows this function consumes 79.0% of total runtime
(58.93s out of 74.62s total). The roofline analysis confirms this choice:
arithmetic intensity = 13.06 FLOP/byte, just below the M2 CPU ridge point of
15.0 FLOP/byte, making it memory-bound. The root cause is the weight matrix W
(1000x784, 6.27MB) being reloaded from DRAM at every one of the 25 timesteps
per inference. A dedicated hardware accelerator with on-chip SRAM to buffer W
eliminates this redundancy, lifting AI to \~60 FLOP/byte and making the kernel
compute-bound on the accelerator.

## (b) What software will continue to handle

All non-LIF operations remain in software: spike rate encoding of input images,
the output classification layer (10-neuron softmax), cross-entropy loss,
weight updates via STDP, and training loop orchestration including data loading,
batching, and shuffling. These account for less than 21% of runtime and are
lightweight operations already near their attainable ceiling.

## (c) Interface bandwidth required

The accelerator targets 6000 GFLOP/s peak compute. With optimized AI of
\~60 FLOP/byte, required interface bandwidth to avoid becoming interface-bound:
Required BW = Target\_performance / AI = 6000 / 60 = 100 GB/s
This is achievable with HBM2e (600 GB/s available), leaving significant headroom.
The host-to-accelerator link needs only \~1.4MB per timestep for spike inputs.

## (d) Bound classification and accelerator impact

On Apple M2 CPU: lif\_layer\_forward is MEMORY-BOUND (AI=13.06, ridge=15.0 F/B).
Hypothetical SNN accelerator ridge point = 6000/600 = 10.0 FLOP/byte.
With on-chip weight caching, AI rises to \~60 FLOP/byte, exceeding the
accelerator ridge point of 10 F/B. The kernel becomes COMPUTE-BOUND on the
accelerator, delivering \~5x speedup over the M2 CPU baseline.

