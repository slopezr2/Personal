#! /bin/bash
gfortran -o Lorenz_4DEnVAR_Execute ./MODULES/*.f90  LORENZ_4DEnVAR.F95 ./functions/*.f90 -lblas -llapack 
#./Lorenz_EnKF_Execute
#rm Lorenz_EnKF_Execute


#python leer.py
