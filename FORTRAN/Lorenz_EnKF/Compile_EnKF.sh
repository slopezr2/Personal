#! /bin/bash
gfortran -o Lorenz_EnKF_Execute ./MODULES/*.F95  LORENZ_EnKF.f95 ./functions/*.F90 -lblas -llapack 
./Lorenz_EnKF_Execute
rm Lorenz_EnKF_Execute


python leer.py
