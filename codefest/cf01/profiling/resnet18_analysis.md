# ResNet-18 Profiling Analysis

## 1. Identification of Top MAC-Intensive Layers

To understand the computational characteristics of ResNet-18, the five layers with the highest Multiply-Accumulate (MAC) counts are identified. These layers dominate the overall compute cost of the network.

| Layer Name   | MACs         | Parameters |
|--------------|-------------:|-----------:|
| Conv2d: 1-1  | 118,013,952  | 9,408      |
| Conv2d: 3-1  | 115,605,504  | 36,864     |
| Conv2d: 3-4  | 115,605,504  | 36,864     |
| Conv2d: 3-16 | 115,605,504  | 147,456    |
| Conv2d: 3-29 | 115,605,504  | 589,824    |

These results indicate that early and intermediate convolutional layers contribute significantly to the total computational workload, despite variations in parameter counts.

---

## 2. Arithmetic Intensity Analysis

Arithmetic Intensity (AI) is a key metric that characterizes the ratio of computation to memory traffic. It helps determine whether a layer is compute-bound or memory-bound.

The analysis below is performed for the layer with the highest MAC count: **Conv2d: 1-1**.

### 2.1 FLOPs Computation

Each MAC operation corresponds to two floating-point operations (one multiplication and one addition):

FLOPs = 2 × MACs  
= 2 × 118,013,952  
= 236,027,904  

---

### 2.2 Memory Access Estimation (No Data Reuse Assumption)

All data movements are calculated assuming no reuse of data (worst-case scenario):

- **Weights**  
  = 9,408 × 4 bytes  
  = 37,632 bytes  

- **Input Activations**  
  = 3 × 224 × 224 × 4  
  = 602,112 bytes  

- **Output Activations**  
  = 64 × 112 × 112 × 4  
  = 3,211,264 bytes  

- **Total Memory Access**  
  = 37,632 + 602,112 + 3,211,264  
  = 3,851,008 bytes  

---

### 2.3 Arithmetic Intensity Calculation

Arithmetic Intensity (AI) is defined as:

AI = FLOPs / Total Memory Access  

AI = 236,027,904 / 3,851,008  
≈ 61.28 FLOPs/byte  

---

## 3. Discussion

The computed arithmetic intensity of approximately 61.28 FLOPs/byte suggests that this layer exhibits a relatively high compute to memory ratio. Such layers are more likely to benefit from hardware acceleration and optimized dataflow strategies, as their performance is less constrained by memory bandwidth compared to low-AI layers.

This analysis highlights the importance of targeting high-MAC convolutional layers when designing efficient CNN accelerators.
