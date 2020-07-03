# 3D-spatial-analysis-cell-nuclei
3D spatial analysis of cell/nuclei represented by their centroids

## Folders

**1. Complete Spatial Randomness test**
* Ripley's K/L function. The CSR test is performed using Ripley's K/L functions in **calcEnv.R** script, using the [spatstat package](https://spatstat.org/).
* Visualization. The visualization is performed using the **Kenvplot_all.m** script in MATLAB.
  Supporting files to this script are:
  * Kenvplot.m
  * envelope.m
  * mtit.m
  * natsort.m
  * plotopt.m
  * plotshaded.m

**2. Nuclei Spatial Distributions**
* Inter-Nuclei, and Nearest-Neighbour Distance distributions
* Kullback-Leiber divergence between two distance distributions
* Visualization

These three steps are implemented in the **dist_all.m** script in MATLAB. Supporting files to this script are:
* calc_ind_knd.m
* calc_dist_var.m
* KLDiv.m
* mtit.m
* natsort.m
* plotopt.m

