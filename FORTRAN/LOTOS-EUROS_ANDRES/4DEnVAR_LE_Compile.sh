#! /bin/bash

./4DEnVAR_LE_Configure.sh

#===Write runid, timerange and Ensemble files====
echo 'run.id             : '${runid}>${LE}/proj/eafit/000/rc/runid.rc



echo 'kf.nmodes             : '${Nens}> ${LE}/proj/eafit/000/rc/N_Ensembles.rc
echo ${LE_Outputs}>>${mydir}/temp/Ensembles.in
echo ${Nens}>>${mydir}/temp/Ensembles.in


if [ -f ${LE}/proj/eafit/000/rc/Restart.rc ]
then
	rm ${LE}/proj/eafit/000/rc/Restart.rc
fi
	
echo 'kf.restart.path               : /run/media/dirac/Datos/scratch/projects/4DEnVAR/'${runid}'/restart'>>${LE}/proj/eafit/000/rc/Restart.rc
echo 'kf.restart.key                :  model=LEKF;expid='${runid}>>${LE}/proj/eafit/000/rc/Restart.rc



#===Run Real State Simulation===
echo 'Running Model Real and Ensemble'

#====Compiling LOTOS-EUROS MODEL====
cd ${LE}
echo $LE 
./launcher

./launcher_inner


#==FORTRAN READ NC FILES==

cd ${mydir}
echo 'Reading LE outputs'
gfortran -o read_le_ensemble_output  READ_LE_ENSEMBLE_OUTPUTS_V2.F95 -I${mydir}/MODULES -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -I${mydir}/MODULES -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib  -I/usr/lib64/gfortran/modules -ffree-line-length-none -ffixed-line-length-none -fimplicit-none


#==FORTRAN 4DEnVAR Method



gfortran -c 4DEnVAR_Method_V3.F95 modulo_distribucion_normal.F95 module_matrix.F95 module_EnKF.F95  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib -I/usr/lib64/gfortran/modules

gfortran -o 4DEnVAR_method 4DEnVAR_Method_V3.o modulo_distribucion_normal.o module_matrix.o module_EnKF.o  -lblas -llapack  -I${NETCDF_FORTRAN_HOME}/include -L${NETCDF_FORTRAN_HOME}/lib -lnetcdff -Wl,-rpath -Wl,${NETCDF_FORTRAN_HOME}/lib -L${NETCDF_HOME}/lib -lnetcdf -Wl,-rpath -Wl,${NETCDF_HOME}/lib -I/usr/lib64/gfortran/modules





