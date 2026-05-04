# CMAN — Systolic Array Trace (Weight-Stationary)
ECE 410/510 · Spring 2026 · Codefest 5

---

## Task 1 — PE Diagram with Preloaded Weights

In weight-stationary dataflow, weights from matrix B are preloaded into each PE before computation begins and stay fixed throughout all cycles. Only the input values from matrix A stream in from the left.

         Col 0              Col 1
       +------------------+------------------+
Row 0  |   PE[0][0]       |   PE[0][1]       |
       |   Weight = 5     |   Weight = 6     |
       |  (B[0][0] = 5)   |  (B[0][1] = 6)   |
       +------------------+------------------+
Row 1  |   PE[1][0]       |   PE[1][1]       |
       |   Weight = 7     |   Weight = 8     |
       |  (B[1][0] = 7)   |  (B[1][1] = 8)   |
       +------------------+------------------+

- Inputs stream in from the LEFT (row-wise from matrix A)
- Partial sums accumulate DOWNWARD through rows
- Weights never move — they stay fixed in each PE

---

## Task 2 — Cycle-by-Cycle Computation Table

Given:
- A = [[1, 2], [3, 4]]
- B = [[5, 6], [7, 8]]
- Expected C = [[19, 22], [43, 50]]

How it works:
- Cycles 1-2 stream A inputs and accumulate toward C
- Accumulators reset to 0 at the start of each new output column
- Cycles 3-4 stream A inputs again to compute the second output column
- All PEs retain their fixed weights (5, 6, 7, 8) throughout all cycles

| Cycle | Row 0 Input | Row 1 Input | PE[0][0] partial sum | PE[0][1] partial sum | PE[1][0] partial sum | PE[1][1] partial sum | Output C |
|-------|-------------|-------------|----------------------|----------------------|----------------------|----------------------|----------|
| 1 | A[0][0]=1 | A[1][0]=3 | 0+(1x5)=5 | 0+(1x6)=6 | 0+(3x7)=21 | 0+(3x8)=24 | — |
| 2 | A[0][1]=2 | A[1][1]=4 | 5+(2x5)=15 | 6+(2x6)=18 | 21+(4x7)=49 | 24+(4x8)=56 | — |
| reset | — | — | accumulator=0 | accumulator=0 | accumulator=0 | accumulator=0 | — |
| 3 | A[0][0]=1 | A[1][0]=3 | 0+(1x5)=5 | 0+(1x6)=6 | 0+(3x7)=21 | 0+(3x8)=24 | — |
| 4 | A[0][1]=2 | A[1][1]=4 | 5+(2x7)=19 | 6+(2x8)=22 | 21+(4x7)=49 | 24+(4x8)=56 | C=[[19,22],[43,50]] |

Note: After Cycle 2, accumulators reset to 0 to begin the second output column.
All PEs keep their fixed weights throughout — PE[1][0]=7 and PE[1][1]=8 never change.

Verification:
C[0][0] = (1x5) + (2x7) = 5 + 14 = 19  correct
C[0][1] = (1x6) + (2x8) = 6 + 16 = 22  correct
C[1][0] = (3x5) + (4x7) = 15 + 28 = 43 correct
C[1][1] = (3x6) + (4x8) = 18 + 32 = 50 correct

Final result: C = [[19, 22], [43, 50]]

---

## Task 3 — MACs, Reuse, and Memory Accesses

(a) Total MAC operations:
Each output element requires 2 MACs (dot product of length 2).
4 output elements x 2 MACs each = 8 MACs total

(b) Input reuse count:
- Each value in A is broadcast to 2 PEs per cycle = reused 2 times
- Each weight in B is fixed in 1 PE and used across 2 input cycles = reused 2 times
Every value in both A and B is used exactly 2 times.

(c) Off-chip memory accesses:
A = 4 reads  (4 elements, each read once)
B = 4 reads  (4 weights preloaded once into PEs)
C = 4 writes (4 output elements written once)
Total = 12 memory accesses

---

## Task 4 — Output-Stationary Dataflow

In output-stationary dataflow, the partial sums of C stay fixed inside each PE and accumulate in place throughout the entire computation, while both the input values from A and the weights from B stream in from off-chip memory every cycle.