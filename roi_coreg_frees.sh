#!/bin/bash
# ROI parcellation and coregistration

# File name
export SUBJECTS_DIR=$PWD
FILE_MP2RAGE=MPRAGE.nii
FILE_MP2EPIU=MP2EPI_u.nii.gz
FILE_MP2EPIC=MP2EPI_c.nii.gz

# Recon-all for MP2RAGE
recon-all -i $FILE_MP2RAGE -s Sub01 -all -openmp 16 -sd .


# Co-registration for uncorrected
echo "Starting bbregister for MP2EPI_u..."
COST_U=$(bbregister --s Sub01 --mov $FILE_MP2EPIU --reg coreg_u.dat --t1 | tee /dev/stderr | grep "MinCost:" | awk '{print $2}')
echo "--------------------------------------------------"

# Co-registration for corrected
echo "Starting bbregister for MP2EPI_c..."
COST_C=$(bbregister --s Sub01 --mov $FILE_MP2EPIC --reg coreg_c.dat --t1 | tee /dev/stderr | grep "MinCost:" | awk '{print $2}')

echo ""
echo "=================================================="
echo "               BBREGISTER Result                  "
echo "=================================================="
echo "  * Coreg_u (Uncorrected) MinCost : $COST_U"
echo "  * Coreg_c (Corrected)   MinCost : $COST_C"
echo "=================================================="