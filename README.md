# 3D-spatial-analysis-cell-nuclei
3D spatial analysis of cell/nuclei represented by their centroids

**Citing**: If you use this code or data, please [cite this article]( ) (to be added) in your publications. :)   

**Contact**: For any questions or comments feel free to contact me at this emai address: nikolaos.dimitriou@mail.mcgill.ca

## Folders

**1. Complete Spatial Randomness test**
* Ripley's K/L function. The CSR test is performed using Ripley's K/L functions in **calcEnv.R** script, using the [spatstat package](https://spatstat.org/).
* Visualization. The visualization is performed using the **Kenvplot_all.m** script in MATLAB. 
  Supporting files to this script are:
  * *Kenvplot.m*: Plots the summary K-function for a three-dimensional point pattern. 
  * *envelope.m*: Plots the envelope of the summary K-function for three-dimensional point patterns from all the samples.
  * *mtit.m*: Creates a major title above all subplots. ([link](https://www.mathworks.com/matlabcentral/fileexchange/3218-mtit-a-pedestrian-major-title-creator))
  * *natsort.m*: Natural-Order Filename Sort. ([link](https://www.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort))
  * *plotopt.m*: Natural-Order Filename Sort. ([link](https://www.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort))
  * *plotshaded.m*: Sahdes the envelope of K-Function. Adopted from [Jakob Voigts](http://jvoigts.scripts.mit.edu/blog/nice-shaded-plots/)

**2. Nucleic Spatial Distributions**
* Inter-Nuclei, and Nearest-Neighbour Distance distributions
* Cosine similarity between two distance distributions of different time-points
* Visualization

These three steps are implemented in the **dist_all_s1.m** script in MATLAB. Supporting files to this script are:
* *calc_ind_knd.m*: Computes the Inter-Nucleic and the Nearest Neighbor distance distributions and saves both distances and kernel smoothed distributions.
* *calc_dist_var.m*: Computes the variations between distributions of two different time-points using the Cosine similarity measure and saves them.
* *cosine_sim.m*: Function for the Cosine-similarity measure. Invoked by *calc_dist_var.m*.
* *violinplot.m*: Plots the cosine-similarity between distributions of two different time-points. ([link](https://github.com/bastibe/Violinplot-Matlab))
* *Violin.m*: Invoked by *violinplot.m*. ([link](https://github.com/bastibe/Violinplot-Matlab))
* *mtit.m*: Creates a major title above all subplots. ([link](https://www.mathworks.com/matlabcentral/fileexchange/3218-mtit-a-pedestrian-major-title-creator))
* *plotopt.m*: Plot options


**3. Points to density**
* The **points2density.m** script imports the coordinates of the centroids of the segmented nuclei and calculates their spatial density profiles using the [Adaptive kernel density estimator via diffusion](https://people.smp.uq.edu.au/DirkKroese/ps/AOS799.pdf).

Supporting files to this script are:
* *akde.m*: Script for adaptive kernel density estimation for high dimensions. ([link](https://www.mathworks.com/matlabcentral/fileexchange/58312-kernel-density-estimator-for-high-dimensions))
* *natsort.m*: Natural-Order Filename Sort. ([link](https://www.mathworks.com/matlabcentral/fileexchange/47434-natural-order-filename-sort))

**4. Coordinates of centroids of segmented nuclei**
* This directory contains the 3D coordinates of centroids of segmented nuclei from 6 datasets, for each time-point D#. The nuclei were segmented using the
pipeline found in [this](https://github.com/NMDimitriou/3D-Preprocessing-Nuclei-Segmentation) repository.

