**Course:** ECE 410/510 — Hardware for AI and Machine Learning
**Codefest:** CF06
**Name:** Vanisri Kyatham

---

## (a) Ideal I_col0 — Task 1

Setup: V_row0 = 1 V, col 0 held at 0 V (virtual ground), row 1 and col 1 also grounded.

Only R[0][0] = 1 kΩ connects V_row0 to col 0. All other nodes are pinned to 0 V, so no sneak path exists.

I_col0 = V_row0 / R[0][0] = 1V / 1000Ω = 1.0 mA

**Ideal I_col0 = 1.0 mA**

---

## (b) KCL Solution for Floating Node Voltages — Task 2

Setup: V_row0 = 1 V, col 0 held at 0 V. Row 1 and col 1 are floating (undriven).

Let V_r1 = voltage at floating row 1, V_c1 = voltage at floating col 1.

### KCL at V_c1 (col 1):

(V_row0 - V_c1) / R[0][1]  +  (V_r1 - V_c1) / R[1][1]  =  0
(1 - V_c1) / 2000  +  (V_r1 - V_c1) / 1000  =  0

Multiply through by 2000:
(1 - V_c1) + 2(V_r1 - V_c1) = 0
1 - V_c1 + 2*V_r1 - 2*V_c1 = 0
1 + 2*V_r1 - 3*V_c1 = 0   --> Equation (1)

### KCL at V_r1 (row 1):

(V_r1 - 0) / R[1][0]  +  (V_r1 - V_c1) / R[1][1]  =  0
V_r1 / 2000  +  (V_r1 - V_c1) / 1000  =  0

Multiply through by 2000:
V_r1 + 2(V_r1 - V_c1) = 0
3*V_r1 - 2*V_c1 = 0   --> Equation (2)

### Solving:

From (2): V_c1 = (3/2) * V_r1
Substitute into (1):
1 + 2*V_r1 - 3*(3/2)*V_r1 = 0
1 - 2.5*V_r1 = 0

V_r1 = 0.4 V
V_c1 = (3/2) * 0.4 = 0.6 V

**Result: V_row1 = 0.4 V, V_col1 = 0.6 V**

---

## (c) Actual I_col0 Including Sneak Path — Task 2 (continued)

Sneak path current through R[1][0] from floating row 1 (0.4 V) to col 0 (0 V):
I_sneak = (V_r1 - 0) / R[1][0] = 0.4V / 2000Ω = 0.2 mA

Intended current:
I_intended = V_row0 / R[0][0] = 1V / 1000Ω = 1.0 mA

**I_col0 (actual) = 1.0 mA + 0.2 mA = 1.2 mA**

---

## (d) Why Sneak Paths Corrupt MVM Results — Task 3

When a column is read, undriven floating rows and columns form unintended current paths
through the crossbar, adding extra current (like the 0.2 mA sneak current found above)
to the intended output signal. This makes the output larger than the correct MVM answer,
corrupting the computation. In large crossbar arrays this gets much worse because hundreds
of these unwanted paths all contribute extra current simultaneously, making the entire
MVM result unreliable.