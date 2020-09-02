#! /bin/bash

. 4DEnVAR_LE_Configure.sh

#====Read LE Ensemble outputs==== NO OLVIDAR COMENTAR Y DESCOMENTAR SI LOS ENSAMBLES YA CORRIERON

cd ${LE_Run}
./lekf.x lekf.rc

#==Merging LE DC for each ensemble member ==
echo 'Merging LE Ensembles DC'
cd ${LE_Outputs}
let "j=0"
for i in $(ls LE_${runid}_dc_${start_date}_xi**a.nc)
	do
	let "j=j+1"
	if [ $j -lt 10 ]
	then
		ncks -O -h --mk_rec_dmn time LE_${runid}_dc_${start_date}_xi0${j}a.nc  Merge_x0${j}.nc
		mv LE_${runid}_dc_${start_date}_xi0${j}a.nc ..
		ncrcat -O -h Merge_x0${j}.nc LE_${runid}_dc_2*_xi0${j}a.nc Ens_x0${j}.nc

	else
		ncks -O -h --mk_rec_dmn time LE_${runid}_dc_${start_date}_xi${j}a.nc  Merge_x${j}.nc
		mv LE_${runid}_dc_${start_date}_xi${j}a.nc ..
		ncrcat -O -h Merge_x${j}.nc LE_${runid}_dc_2*_xi${j}a.nc Ens_x${j}.nc
	fi
done 

#==Merging LE DC for each ensemble member ==

#module unload netcdf/4.4.0_gcc-5.4.0
#module load cdo/1.9.3_gcc-5.4.0


#echo 'Merging LE Ensembles DC'
#cd ${LE_Outputs}
#let "j=0"
#for i in $(ls LE_${runid}_dc_${start_date}_xi**a.nc)
#        do
#	let "j=j+1"
#        if [ $j -lt 10 ]
#        then
#            	cdo -select,name=dc LE_${runid}_dc_2*_xi0${j}a.nc Ens_x0${j}.nc
#        else
#                cdo -select,name=dc LE_${runid}_dc_2*_xi${j}a.nc Ens_x${j}.nc
#        fi
#done

#module unload cdo/1.9.3_gcc-5.4.0
module load python/3.6.5_miniconda-4.5.1
module load gcc/5.4.0
module load netcdf-fortran/4.4.3_gcc-5.4.0
module load udunits/2.2.26_gcc-5.4.0
module load ncl/2.1.18_intel-2017_update-1
module load lapack/3.5.0_gcc-5.4.0
module unload netcdf/4.4.0_gcc-5.4.0
module load nco/4.9.3_gcc-5.4.0


#==FORTRAN READ NC FILES==

cd ${mydir}
./read_le_ensemble_output
#==FORTRAN 4DEnVAR Method
./4DEnVAR_method




