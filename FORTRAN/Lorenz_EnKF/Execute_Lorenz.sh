#! /bin/bash
gfortran -o Lorenz_EnKF_Execute ./MODULES/*.f90  ./functions/*.f90 LORENZ_EnKF.f95  -lblas -llapack 
./Lorenz_EnKF_Execute
rm Lorenz_EnKF_Execute


python leer.py
