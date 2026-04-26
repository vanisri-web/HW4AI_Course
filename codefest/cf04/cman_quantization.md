# CMAN — Manual INT8 Symmetric Quantization

## Task 1 — Scale Factor

|W| matrix:
| 0.85 | 1.20 | 0.34 | 2.10 |
| 0.07 | 0.91 | 1.88 | 0.12 |
| 1.55 | 0.03 | 0.44 | 2.31 |
| 0.18 | 1.03 | 0.77 | 0.55 |

max(|W|) = 2.31

S = 2.31 / 127 = 0.018189

---

## Task 2 — Quantize (W_q = round(W/S), clamped to [-128, 127])

| 47  | -66 |  19 |  115 |
| -4  |  50 | -103|    7 |
| 85  |   2 | -24 | -127 |
| -10 |  57 |  42 |   30 |

All values fall within [-128, 127], no clamping needed.

---

## Task 3 — Dequantize (W_deq = W_q × S)

|  0.8549 | -1.2005 |  0.3456 |  2.0917 |
| -0.0728 |  0.9094 | -1.8735 |  0.1273 |
|  1.5461 |  0.0364 | -0.4365 | -2.3100 |
| -0.1819 |  1.0368 |  0.7639 |  0.5457 |

---

## Task 4 — Error Analysis

Per-element absolute error |W - W_deq|:

| 0.0049 | 0.0005 | 0.0056 | 0.0083 |
| 0.0028 | 0.0006 | 0.0065 | 0.0073 |
| 0.0039 | 0.0064 | 0.0035 | 0.0000 |
| 0.0019 | 0.0068 | 0.0061 | 0.0043 |

Largest error = 0.0083 at Row 1, Col 4 (W = 2.10, W_deq = 2.0917)

MAE = 0.0696 / 16 = 0.00435

---

## Task 5 — Bad Scale Experiment (S_bad = 0.01)

W_q_bad (after clamping):

|  85 | -120 |  34 |  127 |
|  -7 |   91 | -128|   12 |
| 127 |    3 | -44 | -128 |
| -18 |  103 |  77 |   55 |

W_deq_bad = W_q_bad × 0.01:

|  0.85 | -1.20 |  0.34 |  1.27 |
| -0.07 |  0.91 | -1.28 |  0.12 |
|  1.27 |  0.03 | -0.44 | -1.28 |
| -0.18 |  1.03 |  0.77 |  0.55 |

MAE_bad = 2.74 / 16 = 0.17125

**Explanation:** When S is too small, large-magnitude values exceed
the INT8 representable range and get clamped, causing irreversible
information loss and large reconstruction errors.