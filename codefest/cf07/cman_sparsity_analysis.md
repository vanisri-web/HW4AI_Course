# CMAN — Sparsity Breakeven Analysis
**ECE 410/510 | Spring 2026 | Codefest 7**

---

## Task 1: Expressions for Dense and Sparse Compute/Memory

**N = 512**, sparsity = s (fraction of zeros)

Each multiply-then-add pair = 2 MAC operations

### (a) Dense MVM Compute (FLOPs)

$$C_{dense} = 2 \times N^2 = 2 \times 512^2 = 524{,}288 \text{ FLOPs}$$

### (b) Dense Memory Bytes

FP32 = 4 bytes per element

$$M_{dense} = 4 \times N^2 = 4 \times 512^2 = 1{,}048{,}576 \text{ bytes}$$

### (c) Sparse Compute (FLOPs, as a function of s)

Only the remaining fraction (1-s) of weights are non-zero:

$$C_{sparse} = C_{dense} \times (1-s) = 2N^2(1-s)$$

$$= 2 \times 512^2 \times (1-s)$$

$$\boxed{C_{sparse} = 524{,}288 \times (1-s) \text{ FLOPs}}$$

### (d) Sparse Memory Bytes (as a function of s)

CSR format stores 3 things:

**i) Values array** — actual non-zero values, each FP32 = 4 bytes:
$$4 \times N^2(1-s) \text{ bytes}$$

**ii) Column index array** — one INT32 per non-zero, 4 bytes each:
$$4 \times N^2(1-s) \text{ bytes}$$

**iii) Row pointer array** — N+1 entries, each INT32 = 4 bytes:
$$4 \times (N+1) \text{ bytes}$$

$$M_{sparse} = 4N^2(1-s) + 4N^2(1-s) + 4(N+1)$$

$$\boxed{M_{sparse} = 8N^2(1-s) + 4(N+1) \text{ bytes}}$$

---

## Task 2: FLOPs Speedup and s for 2× Speedup

$$S_{FLOPs} = \frac{C_{dense}}{C_{sparse}} = \frac{2N^2}{2N^2(1-s)} = \frac{1}{1-s}$$

For 2× speedup:

$$\frac{1}{1-s} = 2 \implies 1-s = \frac{1}{2} \implies s = 0.5$$

$$\boxed{S = 50\%}$$

At 50% sparsity, sparse MVM is 2× faster than dense in terms of FLOPs.

---

## Task 3: Memory Breakeven Sparsity

Set $M_{sparse} = M_{dense}$:

$$8N^2(1-s) + 4(N+1) = 4N^2$$

$$8N^2 - 8N^2s + 4N + 4 = 4N^2$$

$$-8N^2s = 4N^2 - 8N^2 - 4N - 4$$

$$s = \frac{4N^2 + 4N + 4}{8N^2} = \frac{1}{2} + \frac{1}{2N} + \frac{1}{2N^2}$$

Substituting N = 512:

$$s = \frac{1}{2} + \frac{1}{1024} + \frac{1}{2 \times 512^2}$$

$$s = 0.5 + 0.000976 + 0.0000019$$

$$\boxed{s \approx 0.500978 \approx 50.1\%}$$

The tiny extra 0.1% comes from the row pointer array — those 513 extra
integers that CSR always has to store no matter what, even if the matrix
is almost entirely zero. If the row pointer array didn't exist, the
breakeven would be exactly 50%.

**Above this sparsity, sparse format uses less memory than dense.**

---

## Task 4: End-to-End Speedup at s = 0.9 (Memory-Bandwidth-Limited)

**Given:** s = 0.9, N = 512, Bandwidth = 320 GB/s

### Dense Execution Time

$$M_{dense} = 4 \times 512^2 = 1{,}048{,}576 \text{ bytes}$$

$$T_{dense} = \frac{1{,}048{,}576}{320 \times 10^9} \approx 3.28 \text{ ms}$$

### Sparse Execution Time

First count the non-zeros:

$$N^2 \times (1-s) = 512^2 \times (1-0.9) = 262{,}144 \times 0.1 = 26{,}214 \text{ non-zeros}$$

Now compute each part of sparse memory:

- Values array: $26{,}214 \times 4 = 104{,}858$ bytes
- Column index: $26{,}214 \times 4 = 104{,}858$ bytes
- Row pointers: $513 \times 4 = 2{,}052$ bytes

$$M_{sparse} = 104{,}858 + 104{,}858 + 2{,}052 = 211{,}768 \text{ bytes}$$

$$T_{sparse} = \frac{211{,}768}{320 \times 10^9} \approx 0.662 \text{ ms}$$

### Final Speedup

$$S = \frac{T_{dense}}{T_{sparse}} = \frac{3.28}{0.662} \approx 4.95\times$$

$$\boxed{S \approx 4.95\times}$$

At s = 0.9 in a memory-bandwidth-limited system, sparse MVM is approximately **4.95× faster** than dense MVM.
