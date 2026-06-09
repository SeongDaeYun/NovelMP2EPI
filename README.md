# NovelMP2EPI
This repository includes custom scripts to evaluate the performance of MP2EPI distortion correction using simultaneously acquired reversed-PE data: 1) MATLAB script to plot GM/WM boundaries for visual inspection, 2) FreeSurfer script for ROI parcellation and co-registration, and 3) MATLAB script for subpixel line profile comparison.
---

## Included Scripts

### 1. Gray Matter (GM) and White Matter (WM) Boundary Plotting (MATLAB)
* **File name:** get_env_gm_wm.m
* **Description:** Plots GM/WM boundaries on uncorrected and corrected MP2EPI images for visual inspection of distortion correction performance. See the comments within the script for detailed instructions.
* **Usage:** Run the script in MATLAB with the MP2EPI data and their segmentation masks

### 2. ROI Parcellation and Co-registration (Bash/FreeSurfer)
* **File name:** roi_coreg_frees.sh
* **Description:** Performs cortical parcellation using recon-all and boundary-based registration via bbregister; the minimum cost (`mincost`) value evaluates alignment quality.
* **Usage:** Prior to running (./roi_coreg_frees.sh), set the filenames inside the script.

### 3. Subpixel-Resolution Line Profile Comparison (MATLAB)
* **File name:** cmp_subpx_prof.m
* **Description:** Extracts multi-line profiles (e.g., 10 lines) across a specified coordinate and plots the mean and standard deviation to compare alignment to MP2RAGE in subpixel resolution. See the comments within the script for detailed instructions.
