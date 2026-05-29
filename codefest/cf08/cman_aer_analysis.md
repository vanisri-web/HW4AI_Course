# CMAN AER Analysis

## Given
- N = 1024, f = 50 Hz

---

## Task 1
R = N × f = 1024 × 50 = **51,200 spikes/second**

---

## Task 2
B = R × 20 (bits per packet total)

B = 51,200 × 20 = 1,024,000 bits/seconds

**B = 1.024 Mbits/s**

---

## Task 3
Given: SPI (≤ 50 Mbit/s), I²C (≤ 3.4 Mbit/s), AXI4-Lite (assume 100 Mbit/s)

From Task 2, B = 1.024 Mbits/s, max ≥ B

- I²C → 3.4 Mbit/s ≥ 1.024 Mbit/s ✓
- SPI → 50 Mbit/s ≥ 1.024 Mbit/s ✓
- AXI4 → 100 Mbit/s ≥ 1.024 Mbit/s ✓

**So, I²C is the lowest complexity compared to SPI and AXI4-Lite.**

---

## Task 4
25% of 1024 neurons fire at once

(25/100) × 1024 = 0.25 × 1024 = **256 Neurons firing**

Each neuron that fires sends 1 packet = 20 bits (From Task 2)

Total bits = Neuron firing × bits per packet = 256 × 20 = **5,120 bits**

1 ms = 1/1000 second = 0.001 seconds

Peak bandwidth = 5120 / 0.001 = 512,000 bit/s = **5.12 Mbit/s**

From Task 2:
- B_mean = 1.024 Mbits/s
- Burst Bandwidth (B_burst) = 5.12 Mbit/s

Ratio = B_burst / B_mean = 5.12 / 1.024 = **5×**

From Task 3, we chose I²C → 3.4 Mbit/s

3.4 < 5.12 → **No, it's too slow.**
### Options Analysis

**Option 1:** Choose I²C — it's too slow, but we can add a buffer.

Overflow = 256 × 20 − 3400 = 5120 − 3400 = 1720 bits

In terms of packets: 1720 / 20 = 86 packets

So roughly the size of the buffer would be **256 bytes**.

**Option 2:** Upgrade to SPI

50 ≥ 5.12 — it handles the burst easily. No buffer is needed.

---

## Task 5
Given: All 1024 neurons send 1 bit per neuron fired.

Bits per frame = 1024 neurons × 1 bit per neuron = **1024 bits per frame**

Frames per second = 1 second / 1 ms = 1 / 0.001 = **1000 frames/second**

B_frame = Bits per frame × frames per second = 1024 × 1000 = 1,024,000 bits/s

**B_frame = 1.024 Mbit/s**

From Task 2: B_AER = 1.024 Mbit/s

Ratio = B_AER / B_frame = 1.024 / 1.024 = **1**

B_AER = B_frame → N × f × 20 = N × 1000 × 1

f × 20 = 1000 → f = 1000 / 20 = 50

**f_crossover = 50 Hz**

### Crossover Analysis

| Condition | Result |
|---|---|
| f < 50 Hz | AER wins |
| f = 50 Hz | Equal |
| f > 50 Hz | Frame wins |

**B_AER < B_frame** when f < 50 Hz because AER uses less bandwidth — most neurons are quiet, no point sending empty data.

**B_AER > B_frame** when f > 50 Hz because every AER packet has 20 bits of overhead, while frame-based uses only 1 bit per neuron.

---

## Conclusion

AER is the better choice when most neurons remain silent, since there is no value in transmitting empty data for hundreds of inactive neurons when a compact packet can be sent only upon an actual firing event.