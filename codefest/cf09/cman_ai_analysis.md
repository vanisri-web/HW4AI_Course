# CMAN Analysis - CF09
ECE 410/510 Spring 2026 | Vanisri Kyatham

## Task 1: Dominant Kernel Identification

The dominant kernel is the 3x3 CONV2D dot product, the inner loop of an im2col style convolution.
It runs inside CONV2D-im2col and accounts for 80-6% of total software runtime. The hardware design
replaces exactly this kernel with 4 parallel MAC processing elements.

### Kernel Dimensions

| Parameter | Value |
|-----------|-------|
| Kernel Spatial Size | 3x3 = 9 taps |
| I/P Channels | 1 |
| O/P Channels / PEs | 4 (NUM_PE = 4) |
| I/P Feature Map | 32x32 = 1024 pixels |
| O/P Feature Map | (32-3+1) x (32-3+1) = 30x30 = 900 o/p patches |

### Data Types

| Data | Type | Size |
|------|------|------|
| Input Pixels | INT8 Signed | 1 byte each |
| Weights | INT8 Signed | 1 byte each |
| Accumulator | INT32 Signed | 4 bytes each |

The INT32 accumulator is needed because the maximum partial sum is
9 x 127 x 127 = 145,161, which overflows INT8 and INT16.

## Task 2: FLOPs Count

Each MAC operation = 2 FLOPs
Each PE does 9 MACs = 18 FLOPs
4 PEs running in parallel = 4 x 18 = 72 FLOPs per patch
Across all 900 output patches for one full 32x32:
Total FLOPs per invocation = 64,800 FLOPs

## Task 3: Bytes Transferred

Reuse Pattern: GEMM-style weight reuse across output patches.

### Lower Bound (No Data Reuse)

Every time a weight or pixel is needed, it goes all the way to off-chip memory
and fetches it even if it was just used one patch ago.

Pixels: 9 pixels x 1 byte x 900 patches = 8,100 bytes
Weights for all 4 PEs: 4 x 9 weights x 1 byte x 900 patches = 32,400 bytes
Bytes_lower = (9 + 36) x 900 = 45 x 900 = 40,500 bytes
Lower bound = 40,500 bytes. This gives the lowest possible AI.

### Upper Bound (Perfect On-Chip Data Reuse for Weights)

Weights loaded once: 4 x 9 x 1 byte = 36 bytes
Pixels streamed across all patches: 9 x 900 = 8,100 bytes
Bytes_upper = 36 + 8,100 = 8,136 bytes
Upper bound = 8,136 bytes. This gives the highest possible AI.

## Task 4: Arithmetic Intensity

AI = Total FLOPs / Total Bytes. From Task 2: FLOPs = 64,800

| Bound | FLOPs | Bytes | AI (FLOP/byte) |
|-------|-------|-------|----------------|
| Low (No reuse) | 64,800 | 40,500 | 1.60 |
| Upper (Weight reuse) | 64,800 | 8,136 | 7.96 |

### Sky130A Platform at 100 MHz

Peak compute = 4 PEs x 1 MAC/cycle x 100 MHz x 2 FLOPs/MAC = 800 MOPS
Peak BW = 330 MB/s (AXI4-Lite 32-bit bus)
Ridge Point = 800 / 330 = 2.42 FLOP/byte

AI = 1.60 is left of the ridge (2.42), Memory bound with no reuse.
AI = 7.96 is right of the ridge (2.42), Compute bound with weight reuse.

At AI = 1.60, attainable performance = 330 x 1.60 = 528 MOPS
At AI = 7.96, attainable performance = Min(330 x 7.96, 800) = 800 MOPS (Compute ceiling)

## Task 5: Bottleneck Identification and Improvement

Bottleneck: Hardware Interface Bandwidth (AXI4-Lite)

One patch takes 120 clock cycles. Only 9 of those cycles are actual MAC computation,
that is 7.5% utilisation. The remaining 111 cycles are AXI4-Lite bus overhead while
the MAC units sit idle waiting for data. The design is not short on compute or
on-chip memory, it is starved by the interface.

### Single Highest-Leverage Change

Replace the per-patch sequential AXI writes with a 9-deep streaming pixel FIFO.
This collapses pixel delivery from 111 bus overhead cycles down to 9 FIFO cycles
per patch, cutting total patch latency from 120 cycles to 30 cycles and raising
throughput from 60 MOPS to 240 MOPS, a 4x improvement with no changes to the MAC array.
