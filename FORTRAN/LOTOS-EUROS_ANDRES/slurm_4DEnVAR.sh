#!/bin/bash
#SBATCH --partition=longjobs
#SBATCH --nodes=1
#SBATCH --ntasks=32
#SBATCH --time=4-23:59:00
#SBATCH --job-name=LE_WRF_20
#SBATCH -o result_%x_%j.out      # File to which STDOUT will be written
#SBATCH -e result_%x_%j.err      # File to which STDERR will be written
#SBATCH --mail-type=ALL
#SBATCH --mail-user=slopezr2@eafit.edu.co

module load python/3.6.5_miniconda-4.5.1
module load gcc/5.4.0
module load netcdf-fortran/4.4.3_gcc-5.4.0
module load udunits/2.2.26_gcc-5.4.0
module load ncl/2.1.18_intel-2017_update-1

./4D_EnVAR_LE_main_V4.sh
