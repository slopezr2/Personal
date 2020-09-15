#! /bin/bash

#============== Script 4DEnVar for the LOTOS-EUROS  =======================
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
mydir='/home/ayarceb/4DENVAR/Personal/FORTRAN/LOTOS-EUROS_APOLO'

#===Path LOTOS-EUROS MODEL (OJO carpeta de LEKF)===
LE='/home/ayarceb/4DENVAR/Version_WRF_04_2020/lekf_4DEnVAR/lekf/v3.0.003-beta'

#===Path where netcdf-fortran and netcdf is installed===
#OPT=${HOME}'/opt'
#NETCDF_FORTRAN_HOME='/usr/lib64'
##NETCDF_HOME=${OPT}'/netcdf/4.4.0'
#NETCDF_HOME=${OPT}'/home/dirac/miniconda3/pkgs/libnetcdf-4.7.3-nompi_h9f9fd6a_101'


OPT=${HOME}'/opt'
NETCDF_FORTRAN_HOME='/share/apps/netcdf-fortran/4.4.3/gcc-5.4.0'
#NETCDF_HOME=${OPT}'/netcdf/4.4.0'
NETCDF_HOME='/share/apps/netcdf-fortran/4.4.3/gcc-5.4.0'


#===Run ID====
runid='Test_4DENVAR_3_ensembles_11'

#===Date of simulations====
if [ -f ${LE}/proj/eafit/000/rc/timerange.rc ]
then
	rm ${LE}/proj/eafit/000/rc/timerange.rc
	
fi	
start_date=20190201 # Recordar modificar
#=====Days to be simulated======

days_simulation=3   # Recordar modificar

#===Recordar ver parametro de duracion de la vebtana de asimilacion, inicio de la ventana de asimilacion (./DATA_4DEnVAR/parameters.in)y fecha del archivo Lotos_euros_inner


echo 'timerange.start     :  2019-02-01 00:00:00'>>${LE}/proj/eafit/000/rc/timerange.rc
echo 'timerange.end       :  2019-02-04 00:00:00'>>${LE}/proj/eafit/000/rc/timerange.rc

echo ${start_date}>${mydir}/DATA_4DEnVAR/startdate.in
echo ${days_simulation}>>${mydir}/DATA_4DEnVAR/startdate.in

echo ${runid}>${mydir}/DATA_4DEnVAR/runid.in
#===Number of Ensembles===
Nens=30


#===Parameter rho====
rho=0.1


echo ${rho}>${mydir}/DATA_4DEnVAR/rho.dat



#===Path LOTOS-EUROS Ensemble Outputs===
LE_Outputs='/scratch/ayarceb/projects/LOTOS-EUROS/projects/4DEnVAR/'${runid}'/output'
LE_Run='/scratch/ayarceb/projects/LOTOS-EUROS/projects/4DEnVAR/'${runid}'/run'
LE_Run_Inner='/scratch/ayarceb/projects/LOTOS-EUROS/projects/4DEnVAR_inner/Xk/run'


#==================================================================================
# 			      End Modified by user
#==================================================================================


