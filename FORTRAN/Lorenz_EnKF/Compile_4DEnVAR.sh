#! /bin/bash
gfortran -o Lorenz_EnKF_Execute modulo_distribucion_normal.F90 module_matrix.f90 module_EnKF.f90 Lorenz_96_one_Step.f90  LORENZ_4DEnVAR.F95 -lblas -llapack 

#gfortran -o Lorenz_EnKF_Execute ./MODULES/*.o   ./functions/*.o   LORENZ_4DEnVAR.o -lblas -llapack
#./Lorenz_EnKF_Execute
#rm Lorenz_EnKF_Execute


#python leer.py
