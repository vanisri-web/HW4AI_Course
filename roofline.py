import numpy as np
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

x = np.logspace(-2, 4, 3000)
fig, ax = plt.subplots(figsize=(11, 7))

ax.loglog(x, np.minimum(100*x, 1500), color="blue", lw=2.5, label="Apple M2 CPU roofline")
ax.loglog(x, np.minimum(600*x, 6000), color="red", lw=2.5, ls="-.", label="SNN HW Accelerator roofline")

ax.scatter(13.06, 1306, s=220, color="blue", marker="o", zorder=6, label="LIF SW kernel (memory-bound)")
ax.scatter(59.97, 6000, s=220, color="red", marker="*", zorder=6, label="LIF HW kernel (compute-bound)")

ax.annotate("LIF fwd SW\nAI=13.06 F/B\n1306 GFLOP/s\nMEMORY-BOUND", xy=(13.06,1306), xytext=(1,3000), fontsize=9, color="blue", fontweight="bold", arrowprops=dict(arrowstyle="->", color="blue"))
ax.annotate("LIF fwd HW\nAI=59.97 F/B\n6000 GFLOP/s\nCOMPUTE-BOUND", xy=(59.97,6000), xytext=(8,800), fontsize=9, color="red", fontweight="bold", arrowprops=dict(arrowstyle="->", color="red"))

ax.axvline(15, color="blue", lw=1, ls="--", alpha=0.5)
ax.axvline(10, color="red", lw=1, ls="--", alpha=0.5)

ax.annotate("Ridge SW (15 F/B)", xy=(15,1500), xytext=(20,800), fontsize=8, color="blue", arrowprops=dict(arrowstyle="->", color="blue"))
ax.annotate("Ridge HW (10 F/B)", xy=(10,6000), xytext=(20,3000), fontsize=8, color="red", arrowprops=dict(arrowstyle="->", color="red"))

ax.set_xlabel("Arithmetic Intensity (FLOP/byte)", fontsize=12)
ax.set_ylabel("Attainable Performance (GFLOP/s)", fontsize=12)
ax.set_title("Roofline Model - SNN LIF Layer\nApple M2 CPU vs SNN HW Accelerator", fontsize=13, fontweight="bold")
ax.set_xlim(0.01, 10000)
ax.set_ylim(1, 20000)
ax.grid(True, which="both", alpha=0.25, ls="--")
ax.legend(loc="upper left", fontsize=8)

plt.tight_layout()
import os
os.makedirs("codefest/cf02/profiling", exist_ok=True)
plt.savefig("codefest/cf02/profiling/roofline_project.png", dpi=150, bbox_inches="tight")
print("done")