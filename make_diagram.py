import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch

fig, ax = plt.subplots(figsize=(12, 9))
ax.set_xlim(0, 12)
ax.set_ylim(0, 9)
ax.axis("off")

def box(x, y, w, h, label, sub="", color="#e8e0f8", textcolor="#3c2e7a"):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0.1",
                                facecolor=color, edgecolor="#888", linewidth=1))
    if sub:
        ax.text(x+w/2, y+h/2+0.18, label, ha="center", va="center",
                fontsize=9, fontweight="bold", color=textcolor)
        ax.text(x+w/2, y+h/2-0.18, sub, ha="center", va="center",
                fontsize=7, color=textcolor)
    else:
        ax.text(x+w/2, y+h/2, label, ha="center", va="center",
                fontsize=9, fontweight="bold", color=textcolor)

def arrow(x1, y1, x2, y2, label=""):
    ax.annotate("", xy=(x2,y2), xytext=(x1,y1),
                arrowprops=dict(arrowstyle="->", color="#555", lw=1.2))
    if label:
        ax.text((x1+x2)/2, (y1+y2)/2+0.12, label, ha="center",
                fontsize=7, color="#555")

# Outer accelerator box
ax.add_patch(FancyBboxPatch((2.8, 1.2), 6.5, 6.5, boxstyle="round,pad=0.15",
             facecolor="#f3f0fd", edgecolor="#7c5cbf", linewidth=2))
ax.text(6.05, 7.55, "SNN HW Accelerator Chiplet", ha="center", fontsize=10,
        fontweight="bold", color="#4a2d9c")

# Host CPU
box(0.2, 5.5, 2.0, 1.0, "Host CPU", "Apple M2", "#dce8f8", "#0c447c")

# SW Baseline
box(0.2, 3.5, 2.0, 1.0, "SW Baseline", "Train & Control", "#e0e0e0", "#444")

# Dispatch & Control
box(3.2, 6.5, 2.5, 0.9, "Dispatch & Control", "Spike scheduler", "#d4eee4", "#085041")

# LIF Compute Array
box(6.2, 6.5, 2.7, 0.9, "LIF Compute Array", "1024 PE units", "#fde8e0", "#712b13")

# On-chip SRAM
box(3.2, 5.0, 5.7, 0.9, "On-chip SRAM", "Neuron states · Weights · Spike buffers", "#fef3d8", "#633806")

# Spike Encoder
box(3.2, 3.5, 2.5, 0.9, "Spike Encoder", "Input preprocessing", "#d4eee4", "#085041")

# Output Decoder
box(6.2, 3.5, 2.7, 0.9, "Output Decoder", "Spike aggregation", "#d4eee4", "#085041")

# HBM Interface
box(3.2, 2.0, 5.7, 0.9, "HBM2e Interface", "460 GB/s · off-chip DRAM", "#dce8f8", "#0c447c")

# HBM Memory
box(4.2, 0.1, 3.7, 0.9, "HBM2e Memory", "Off-chip · 460 GB/s", "#dce8f8", "#0c447c")

# Arrows
arrow(2.2, 6.0, 3.2, 6.95, "PCIe")
arrow(2.2, 4.0, 3.2, 3.95, "Results")
arrow(5.7, 6.95, 6.2, 6.95)
arrow(4.45, 6.5, 4.45, 5.9)
arrow(7.55, 5.9, 7.55, 6.5)
arrow(4.45, 5.0, 4.45, 4.4)
arrow(7.55, 4.4, 7.55, 5.0)
arrow(6.05, 2.9, 6.05, 2.0)
arrow(6.05, 2.0, 6.05, 1.0)

import os
os.makedirs("project/m1", exist_ok=True)
plt.tight_layout()
plt.savefig("project/m1/system_diagram.png", dpi=150, bbox_inches="tight")
print("system_diagram.png saved!")