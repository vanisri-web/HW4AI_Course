# Arithmetic Intensity Calculation

## Project: SNN Hardware Accelerator

## Dominant Kernel: lif\_layer\_forward

## 1\. Parameters

|Parameter|Value|
|-|-|
|Input neurons N\_in|784|
|Hidden neurons N\_hid|1000|
|Batch size B|64|
|Timesteps T|25|
|Data type|FP64 (8 bytes)|

## 2\. FLOPs Calculation

Synaptic current per timestep: I\_syn = W x spk\_in\[t]
FLOPs\_matmul = 2 x N\_hid x N\_in x B = 2 x 1000 x 784 x 64 = 100,352,000
LIF update per timestep: FLOPs\_LIF = N\_hid x B x 3 = 1000 x 64 x 3 = 192,000
Total for T=25 timesteps:
FLOPs\_total = 25 x (100,352,000 + 192,000) = 25 x 100,544,000 = 2,513,600,000 FLOPs

## 3\. Bytes Transferred (no cache reuse)

|Operand|Bytes|
|-|-|
|Weight matrix W (1000x784)|6,272,000|
|Spike input per timestep (784x64)|401,408|
|Membrane state read+write (1000x64)|512,000|
|Spike output (1000x64)|512,000|
|Bytes per timestep = 6,272,000 + 401,408 + 512,000 + 512,000 = 7,697,408||
|Bytes total = 25 x 7,697,408 = 192,435,200 bytes||

## 4\. Arithmetic Intensity

AI = FLOPs / Bytes = 2,513,600,000 / 192,435,200 = 13.06 FLOP/byte

## 5\. Roofline Classification (Apple M2 CPU)

Peak compute: 1500 GFLOP/s
Peak bandwidth: 100 GB/s
Ridge point: 1500/100 = 15.0 FLOP/byte
AI = 13.06 < 15.0 => MEMORY-BOUND
Attainable performance = 13.06 x 100 = 1306 GFLOP/s

## 6\. Optimized AI with on-chip weight caching

If W is kept on-chip and reused across T=25 timesteps:
Bytes\_optimized = 6,272,000 + 25x(401,408+512,000+512,000) = 41,907,200
AI\_optimized = 2,513,600,000 / 41,907,200 = 59.97 FLOP/byte => COMPUTE-BOUND

