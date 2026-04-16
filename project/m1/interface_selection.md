# Interface Selection and Bandwidth Analysis — SNN HW Accelerator

## Selected Interface: AXI4 On-Chip Bus + HBM2e

## Bandwidth Requirement

To avoid becoming interface-bound at target throughput of 6000 GFLOP/s:

Required BW = 6000 / 59.97 = 100 GB/s minimum

## Interface Comparison

| Interface | Bandwidth | Sufficient? |
|-----------|-----------|-------------|
| PCIe 4.0 x16 | ~32 GB/s | No |
| DDR5 | ~64 GB/s | No |
| HBM2e | ~460 GB/s | Yes |
| On-chip SRAM bus | ~1 TB/s | Yes |

## Decision

HBM2e is selected. It provides ~460 GB/s — a 4.6x safety margin over
the required 100 GB/s. On-chip SRAM handles neuron state and weight
buffering at >1 TB/s, keeping the LIF compute array compute-bound.

## Summary

- Required bandwidth: 100 GB/s
- HBM2e provides: 460 GB/s
- Safety margin: 4.6x
- Interface bound risk: None at target throughput

