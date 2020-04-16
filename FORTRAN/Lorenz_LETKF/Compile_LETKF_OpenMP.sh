#! /bin/bash
gfortran -o Lorenz_LETKF_Execute_OpenMP modulo_distribucion_normal.F90 module_matrix.f90 module_EnKF.f90  Lorenz_96_one_Step.f90 str.f90 LORENZ_LETKF_OpenMP.f95 -lblas -llapack  -Wno-all -fopenmp

./Lorenz_LETKF_Execute_OpenMP



python leer.py
