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
* Cosine similarity between two distance distributions of different time-points
* Visualization

These three steps are implemented in the **dist_all.m** script in MATLAB. Supporting files to this script are:
* calc_ind_knd.m
* calc_dist_var.m
* cosine_sim.m
* violinplot.m
* Violin.m
* mtit.m
* natsort.m
* plotopt.m


**3. Points to density**
* The **points2density.m** script imports the coordinates of the centroids of the segmented nuclei and calculates their spatial density profiles using the [Adaptive kernel density estimator via diffusion](https://people.smp.uq.edu.au/DirkKroese/ps/AOS799.pdf).

**Citing**: If you use this code, please [cite this article]( ) (to be added) in your publications. :)   

**Contact**: For any questions or comments feel free to contact me at this emai address: nikolaos.dimitriou@mail.mcgill.ca
