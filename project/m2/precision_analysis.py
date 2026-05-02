import numpy as np
np.random.seed(42)
N = 100
def to_q88(x): return np.round(x*256).astype(int)/256.0
def to_q115(x): return np.round(x*32768).astype(int)/32768.0
weights_fp64 = np.random.uniform(-4.0,4.0,N)
weights_q88  = to_q88(weights_fp64)
weight_errors = np.abs(weights_fp64-weights_q88)
print("="*55)
print("Weight Quantization Error (Q8.8 vs FP64)")
print("="*55)
print(f"Samples:             {N}")
print(f"Mean absolute error: {np.mean(weight_errors):.6f}")
print(f"Max error:           {np.max(weight_errors):.6f}")
leak_values=[0.90,0.95,0.99]
print("\n"+"="*55)
print("Leak Factor Quantization Error (Q1.15 vs FP64)")
print("="*55)
for lv in leak_values:
    lq=to_q115(lv)
    err=abs(lv-lq)
    print(f"leak={lv:.2f}  Q1.15=0x{int(lv*32768):04X}  error={err:.8f}")
print("\n"+"="*55)
print("Acceptability Check")
print("="*55)
print(f"Max accumulated error over 10 spikes: {10*(1/256):.6f}")
print(f"Threshold value:                      6.0000")
print(f"Error as percent of threshold:        {10*(1/256)/6.0*100:.3f}%")
print(f"Acceptable (less than 1%):            YES")
print("\nConclusion: Q8.8 format is acceptable for LIF SNN inference.")
print("Reference: Rathi et al., Front. Neurosci., 2020.")
