#! /bin/bash

#============== Script for make a single LOTOS-EUROS run =======================
# Andres Yarce Botero-Santiago Lopez-Restrepo
# Based in the Paper: "A review of operational methods of variational 
# and ensemble-variational data assimilation" R.N. Bannister
#
#==========================================================================
#  The true run was created with    Emis_Fact=0.5
#                                   Depo_Vd=1
#  stored in no2_column_True.mat  (in the code with recent the true is one ensamble member not perturbed)
#==========================================================================
#  First background created with    Emis_Fact= 1.5
#                                   Depo_Vd=1
#==========================================================================
#  To choice:
#
#  Parameter perturbation             pertu=1   (with Vd=1 only emissions perturbed)
#  Initial condition  perturbation    pertu=0
# =========================================================================


#==================================================================================
# 					Modified by user
#==================================================================================


#===Path where the program is running===
mydir='/run/media/dirac/Datos/Reciente_Dropbox/users/arjo/lotos-euros/Repositorio_Personal_Slopez/Personal/FORTRAN/Single_RUN_LE'

#===Path LOTOS-EUROS MODEL (OJO carpeta de LEKF)===
LE='/run/media/dirac/Datos/Reciente_Dropbox/users/arjo/lotos-euros/Single_RUN/lekf_4DEnVAR/lekf/v3.0.003-beta'

#===Path where netcdf-fortran and netcdf is installed===
OPT=${HOME}'/opt'
NETCDF_FORTRAN_HOME='/usr/lib64'
#NETCDF_HOME=${OPT}'/netcdf/4.4.0'
NETCDF_HOME=${OPT}'/home/dirac/miniconda3/pkgs/libnetcdf-4.7.3-nompi_h9f9fd6a_101'
#===Run ID====
runid='Experiment_Arjo_15_days_0.54'

#===Date of simulations====
if [ -f ${LE}/proj/eafit/000/rc/timerange.rc ]
then
	rm ${LE}/proj/eafit/000/rc/timerange.rc
	
fi	
start_date=20190201 # Recordar modificar
#=====Days to be simulated======

days_simulation=3   # Recordar modificar

#===Recordar ver parametro de duracion de la vebtana de asimilacion, inicio de la ventana de asimilacion (./DATA_4DEnVAR/parameters.in)y fecha del archivo Lotos_euros_inner


echo 'timerange.start     :  2019-01-15 00:00:00'>>${LE}/proj/eafit/000/rc/timerange.rc
echo 'timerange.end       :  2019-01-31 00:00:00'>>${LE}/proj/eafit/000/rc/timerange.rc

echo ${start_date}>${mydir}/DATA_4DEnVAR/startdate.in
echo ${days_simulation}>>${mydir}/DATA_4DEnVAR/startdate.in

echo ${runid}>${mydir}/DATA_4DEnVAR/runid.in
#===Number of Ensembles===
Nens=2


#===Remove all temporal files====
if [ -d ${mydir}/temp ]
then
	rm ${mydir}/temp/*
fi
#===Path LOTOS-EUROS Ensemble Outputs===
LE_Outputs='/run/media/dirac/Datos/scratch/projects/LOTOS-EUROS/'${runid}'/output'

#==================================================================================
# 			      End Modified by user
#==================================================================================


#===Write runid, timerange and Ensemble files====
echo 'run.id             : '${runid}>${LE}/proj/eafit/000/rc/runid.rc



echo 'kf.nmodes             : '${Nens}> ${LE}/proj/eafit/000/rc/N_Ensembles.rc
echo ${LE_Outputs}>>${mydir}/temp/Ensembles.in
echo ${Nens}>>${mydir}/temp/Ensembles.in


if [ -f ${LE}/proj/eafit/000/rc/Restart.rc ]
then
	rm ${LE}/proj/eafit/000/rc/Restart.rc
fi
	
echo 'kf.restart.path               : /run/media/dirac/Datos/scratch/projects/LOTOS-EUROS/'${runid}'/restart'>>${LE}/proj/eafit/000/rc/Restart.rc
echo 'kf.restart.key                :  model=LEKF;expid='${runid}>>${LE}/proj/eafit/000/rc/Restart.rc



#===Run Real State Simulation===
echo 'Running single LOTO-EUROS model'

#====Run LOTOS-EUROS MODEL====
cd ${LE}

./launcher


