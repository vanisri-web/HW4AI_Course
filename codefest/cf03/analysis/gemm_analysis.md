# GEMM Kernel Analysis

## (a) Why the Naive Kernel is Memory-Bound
The naive CUDA kernel assigns one thread per output element C[i][j].
Each thread independently loads a full row of A and a full column of B
directly from global DRAM memory with zero data reuse between threads.
For a 1024x1024 matrix, each thread reads 2x1024 floats (8 KB) from DRAM
to perform only 1024 multiply-add operations. This gives an arithmetic
intensity of roughly 0.25 FLOP/byte, far below the ridge point of most
modern GPUs (typically 10-15 FLOP/byte). As a result, the GPU compute
units sit idle waiting for data from slow DRAM, making this kernel
firmly memory-bound.

## (b) How Tiling Reduces DRAM Traffic
The tiled kernel divides the matrices into small TxT blocks and loads
them into fast on-chip shared memory. All threads within a block
cooperatively load one tile of A and one tile of B, then reuse that
data T times before fetching the next tile from DRAM. Because each
element is loaded once per tile and reused T times, the total number
of DRAM accesses is reduced by a factor of T=8 compared to the naive
approach. This raises arithmetic intensity to approximately T/2 = 4
FLOP/byte, significantly reducing pressure on memory bandwidth and
moving the kernel closer to the compute-bound region of the roofline.

## (c) Expected vs. Achieved Improvement
With T=8 tiling we expect roughly an 8x reduction in DRAM traffic and
a corresponding speedup over the naive kernel. In practice the tiled
kernel shows a clear speedup in measured GFLOP/s. However, full 8x
improvement may not be achieved because a tile size of 8 is relatively
small, leading to limited occupancy and underutilization of the GPU
compute resources. Additional bottlenecks include shared memory bank
conflicts and insufficient thread-level parallelism. Increasing tile
size to 16 or 32 would better hide memory latency and push the kernel
further toward the compute-bound ridge point on the roofline model.