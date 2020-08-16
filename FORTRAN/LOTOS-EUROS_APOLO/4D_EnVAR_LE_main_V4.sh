#! /bin/bash

. 4DEnVAR_LE_Configure.sh

#====Read LE Ensemble outputs====

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

#==FORTRAN READ NC FILES==

cd ${mydir}
./read_le_ensemble_output
#==FORTRAN 4DEnVAR Method
./4DEnVAR_method




