#! /bin/bash

. 4DEnVAR_LE_Configure.sh

module load python/3.6.5_miniconda-4.5.1
module load gcc/5.4.0
module load netcdf-fortran/4.4.3_gcc-5.4.0
module load udunits/2.2.26_gcc-5.4.0
module load ncl/2.1.18_intel-2017_update-1
module load lapack/3.5.0_gcc-5.4.0
module unload netcdf/4.4.0_gcc-5.4.0 
module load nco/4.9.3_gcc-5.4.0

#===Write runid, timerange and Ensemble files====
echo 'run.id             : '${runid}>${LE}/proj/eafit/000/rc/runid.rc



echo 'kf.nmodes             : '${Nens}> ${LE}/proj/eafit/000/rc/N_Ensembles.rc
echo ${LE_Outputs}>> ${mydir}/temp/Ensembles.in
echo ${Nens}>>${mydir}/temp/Ensembles.in


if [ -f ${LE}/proj/eafit/000/rc/Restart.rc ]
then
	rm ${LE}/proj/eafit/000/rc/Restart.rc
fi
	
echo 'kf.restart.path               : /run/media/dirac/Datos/scratch/projects/4DEnVAR/'${runid}'/restart'>>${LE}/proj/eafit/000/rc/Restart.rc
echo 'kf.restart.key                :  model=LEKF;expid='${runid}>>${LE}/proj/eafit/000/rc/Restart.rc



#===Run Real State Simulation===
echo 'Compiling LOTOS-EUROS Model'

#====Compiling LOTOS-EUROS MODEL====
cd ${LE}
echo $LE 
./launcher

./launcher_inner


#==FORTRAN READ NC FILES==

cd ${mydir}
echo 'Reading LE outputs'

gfortran -c READ_LE_ENSEMBLE_OUTPUTS_V2.F95 modulo_distribucion_normal.F95 module_matrix.F95 module_EnKF.F95  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -lexpat
echo 'Reading LE outputs 2'
gfortran -o read_le_ensemble_output  READ_LE_ENSEMBLE_OUTPUTS_V2.o  modulo_distribucion_normal.o module_matrix.o module_EnKF.o  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -lnetcdff -lnetcdf -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib -I/usr/lib64/gfortran/modules -lexpat


#==FORTRAN 4DEnVAR Method

gfortran -c 4DEnVAR_Method_V3.F95 modulo_distribucion_normal.F95 module_matrix.F95 module_EnKF.F95  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib -I/usr/lib64/gfortran/modules -lexpat -g -fcheck=all -Wall -fbacktrace
echo 'Reading LE outputs 3'
gfortran -o 4DEnVAR_method 4DEnVAR_Method_V3.o modulo_distribucion_normal.o module_matrix.o module_EnKF.o  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib -I/usr/lib64/gfortran/modules -lexpat -g -fcheck=all -Wall -fbacktrace
echo 'Reading LE outputs 4'





