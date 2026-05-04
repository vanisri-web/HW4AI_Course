# CMAN — Systolic Array Trace (Weight-Stationary)
ECE 410/510 · Spring 2026 · Codefest 5

---

## Task 1 — PE Diagram with Preloaded Weights

In weight-stationary dataflow, weights from matrix B are preloaded into each PE
before computation begins and stay fixed throughout all cycles. Input values from
matrix A stream in from the left row by row.

```
              Col 0              Col 1
            +------------------+------------------+
  Row 0 --> |   PE[0][0]       |   PE[0][1]       |
            |   Weight = 5     |   Weight = 6     |
            |  (B[0][0] = 5)   |  (B[0][1] = 6)   |
            +------------------+------------------+
  Row 1 --> |   PE[1][0]       |   PE[1][1]       |
            |   Weight = 7     |   Weight = 8     |
            |  (B[1][0] = 7)   |  (B[1][1] = 8)   |
            +------------------+------------------+
```

- Row 0 inputs stream from the LEFT: A[0][0]=1, then A[0][1]=2
- Row 1 inputs stream from the LEFT: A[1][0]=3, then A[1][1]=4
- Partial sums accumulate DOWNWARD through rows each cycle
- Weights never move — they stay fixed in each PE throughout all cycles

---

## Task 2 — Cycle-by-Cycle Computation Table

**Given:**
- A = [[1, 2], [3, 4]]
- B = [[5, 6], [7, 8]]
- Expected C = [[19, 22], [43, 50]]

**How it works:**
- Cycle 1 (k=0): Both rows receive first column of A. Each PE multiplies input by its fixed weight.
- Cycle 2 (k=1): Both rows receive second column of A. Each PE accumulates second product.
- Output C is ready after Cycle 2. Cycles 3 and 4 are pipeline drain and write-back phases.
- All weights remain fixed in their PEs throughout all 4 cycles.

| Cycle | Row 0 Input | Row 1 Input | PE[0][0] partial sum | PE[0][1] partial sum | PE[1][0] partial sum | PE[1][1] partial sum | Output C |
|-------|-------------|-------------|----------------------|----------------------|----------------------|----------------------|----------|
| 1 | A[0][0] = 1 | A[1][0] = 3 | 0+(1x5) = **5** | 0+(1x6) = **6** | 0+(3x5) = **15** | 0+(3x6) = **18** | — |
| 2 | A[0][1] = 2 | A[1][1] = 4 | 5+(2x7) = **19** | 6+(2x8) = **22** | 15+(4x7) = **43** | 18+(4x8) = **50** | C ready |
| 3 | 0 (drain) | 0 (drain) | 19 (hold) | 22 (hold) | 43 (hold) | 50 (hold) | C = [[19,22],[43,50]] |
| 4 | 0 (drain) | 0 (drain) | 19 (hold) | 22 (hold) | 43 (hold) | 50 (hold) | Write to memory |

**Note on dataflow:**
In Cycle 1, each PE accumulates: input * B[0][j] using the first A column (weights 5 and 6 for row 0 PEs).
In Cycle 2, each PE accumulates: input * B[1][j] using the second A column (weights 7 and 8 via downward partial sum flow).
Cycles 3 and 4 are pipeline drain cycles — no new inputs arrive, partial sums hold steady,
and the final result C is written back to off-chip memory.
All 4 weights (5, 6, 7, 8) remain physically fixed in their PEs throughout all cycles.

**Verification of final result:**
```
C[0][0] = (1x5) + (2x7) = 5 + 14 = 19   correct
C[0][1] = (1x6) + (2x8) = 6 + 16 = 22   correct
C[1][0] = (3x5) + (4x7) = 15 + 28 = 43  correct
C[1][1] = (3x6) + (4x8) = 18 + 32 = 50  correct
```

**Final result: C = [[19, 22], [43, 50]]** ✓

---

## Task 3 — MACs, Reuse, and Memory Accesses

### (a) Total MAC operations

Each output element C[i][j] requires 2 multiply-accumulate operations
(one per element in the dot product of length 2).

```
4 output elements x 2 MACs each = 8 MACs total
```

### (b) Input reuse count

- Each value in A streams into 2 PEs (one per column) = reused **2 times**
- Each weight in B is fixed in its PE and used across 2 input cycles = reused **2 times**

Every value in both A and B is used exactly **2 times**.

### (c) Off-chip memory accesses

| Matrix | Direction | Count | Detail |
|--------|-----------|-------|--------|
| A | Read | 4 | 4 elements, each read once from off-chip |
| B | Read | 4 | 4 weights preloaded once into PEs before computation |
| C | Write | 4 | 4 output elements written once to off-chip after computation |
| **Total** | | **12** | 4 reads (A) + 4 reads (B) + 4 writes (C) |

---

## Task 4 — Output-Stationary Dataflow

In output-stationary dataflow, the partial sums of C stay fixed inside each PE
and accumulate in place throughout the entire computation, while both the input
values from A and the weights from B stream in from off-chip memory every cycle.