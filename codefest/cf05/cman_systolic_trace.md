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

- Row 0 inputs stream from the LEFT (A[0][0], A[0][1])
- Row 1 inputs stream from the LEFT (A[1][0], A[1][1])
- Partial sums accumulate DOWNWARD through rows each cycle
- Weights never move — they stay fixed in each PE throughout all cycles

---

## Task 2 — Cycle-by-Cycle Computation Table

**Given:**
- A = [[1, 2], [3, 4]]
- B = [[5, 6], [7, 8]]
- Expected C = [[19, 22], [43, 50]]

**How it works:**
- Cycle 1 (k=0): Row 0 receives A[0][0]=1, Row 1 receives A[1][0]=3
- Cycle 2 (k=1): Row 0 receives A[0][1]=2, Row 1 receives A[1][1]=4
- Each PE[i][j] accumulates: partial_sum += A[i][k] * B[k][j]
- In Cycle 1, the active weight column is B column 0 (5, 7)
- In Cycle 2, the active weight column is B column 1 (6, 8) passed via partial sum flow

| Cycle | Row 0 Input | Row 1 Input | PE[0][0] partial sum | PE[0][1] partial sum | PE[1][0] partial sum | PE[1][1] partial sum | Output C |
|-------|-------------|-------------|----------------------|----------------------|----------------------|----------------------|----------|
| 1 | A[0][0] = 1 | A[1][0] = 3 | 0+(1x5) = **5** | 0+(1x6) = **6** | 0+(3x5) = **15** | 0+(3x6) = **18** | — |
| 2 | A[0][1] = 2 | A[1][1] = 4 | 5+(2x7) = **19** | 6+(2x8) = **22** | 15+(4x7) = **43** | 18+(4x8) = **50** | C = [[19,22],[43,50]] |

**Note on dataflow:**
In Cycle 1, each PE accumulates input * B[0][j] (the first row of weights: 5, 6).
In Cycle 2, each PE accumulates input * B[1][j] (the second row of weights: 7, 8),
which streams in via the downward partial sum flow from the row above.
Weights stay physically fixed in their PEs — the partial sum propagation through
rows is what enables each PE to participate in the full dot product computation.

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