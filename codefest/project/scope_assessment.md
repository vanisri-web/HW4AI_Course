## CF07 Scope Update — May 17, 2026

Synthesis of the CF06 fallback 4×4 crossbar MAC produced 8,385 gates
(3,938 AND, 2,938 XOR, 1,313 OR, 68 DFF) at 100 MHz target on sky130.
This confirms that even a small 4×4 MAC is gate-intensive at 8-bit
precision. Based on this, I am narrowing my SNN core scope to 8 LIF
neurons with 1-bit spike weights to keep gate count manageable and
ensure positive timing slack for M3.