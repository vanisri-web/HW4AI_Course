# CMAN — Systolic Array Trace (Weight-Stationary)
ECE 410/510 · Spring 2026 · Codefest 5

## Task 1 — PE Diagram with Preloaded Weights

```
+------------------+------------------+
|   PE[0][0]       |   PE[0][1]       |
|   Weight = 5     |   Weight = 6     |
+------------------+------------------+
|   PE[1][0]       |   PE[1][1]       |
|   Weight = 7     |   Weight = 8     |
+------------------+------------------+
```

Weights are preloaded from B and stay fixed throughout computation (weight-stationary).

## Task 2 — Cycle-by-Cycle Table

| Cycle | Row 0 Input | Row 1 Input | PE[0][0] | PE[0][1] | PE[1][0] | PE[1][1] | Output C |
|-------|-------------|-------------|----------|----------|----------|----------|----------|
| 1 | 1 | 3 | 0+(1x5)=5 | 0+(1x6)=6 | 0+(3x7)=21 | 0+(3x8)=24 | — |
| 2 | 2 | 4 | 5+(2x5)=15 | 6+(2x6)=18 | 21+(4x7)=49 | 24+(4x8)=56 | — |
| 3 | 1 | 3 | 0+(1x5)=5 | 0+(1x6)=6 | 0+(3x5)=15 | 0+(3x6)=18 | — |
| 4 | 2 | 4 | 5+(2x7)=19 | 6+(2x8)=22 | 15+(4x7)=43 | 18+(4x8)=50 | C=[[19,22],[43,50]] |

Final result C = [[19, 22], [43, 50]]

## Task 3 — MACs, Reuse, and Memory Accesses

(a) Total MAC operations:
4 output values x 2 MACs each = 8 MACs total

(b) Input reuse count:
Every value in A and B is used 2 times

(c) Off-chip memory accesses:
A = 4 reads
B = 4 reads
C = 4 writes
Total = 12 memory accesses

## Task 4 — Output-Stationary Dataflow

In output-stationary dataflow, the partial sums of C stay fixed inside each PE and accumulate in place, while both A input values and B weight values stream in from memory every cycle.