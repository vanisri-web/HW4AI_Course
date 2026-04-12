\# Interface Selection and Bandwidth Analysis — SNN HW Accelerator



\## Selected Interface: AXI4 High-Bandwidth On-Chip Bus + HBM (High Bandwidth Memory)



\## Justification

The LIF accelerator requires sustained memory bandwidth to avoid becoming

interface-bound at the target throughput of 6000 GFLOP/s.



Required bandwidth = Target GFLOP/s / Arithmetic Intensity

= 6000 / 59.97 ≈ 100 GB/s



Standard interfaces and their bandwidth:

| Interface | Bandwidth |

|-----------|-----------|

| PCIe 4.0 x16 | \~32 GB/s |

| DDR5 | \~64 GB/s |

| HBM2e | \~460 GB/s ✅ |

| On-chip SRAM bus | \~1 TB/s ✅ |



\## Decision

HBM2e is selected as the off-chip memory interface because it provides

\~460 GB/s, well above the required 100 GB/s. On-chip SRAM with a wide

bus handles neuron state buffering at >1 TB/s, ensuring the accelerator

stays compute-bound rather than interface-bound.



\## Bandwidth Analysis

\- Required BW at target: 100 GB/s

\- HBM2e provides: 460 GB/s

\- Safety margin: 4.6×

\- This margin allows for burst traffic during spike propagation phases

&#x20; without stalling the compute pipeline.

