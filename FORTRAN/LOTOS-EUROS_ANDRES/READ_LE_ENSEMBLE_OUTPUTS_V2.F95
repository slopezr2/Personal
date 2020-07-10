  !==Program to Read LE Ensemble Outputs===
  !==Andres Yarce, Santiago Lopez-Restrepo==

program read_le_ensemble_outputs
  use module_EnKF
  use module_matrix
  use netcdf
  implicit none

  integer::time,Ens,j,i,k
  integer::lat,lon,level,initial_day,dawindows,days_simulation
  real,allocatable,dimension(:,:,:,:,:)::aux(:,:,:,:,:) !Dimensions lon,lat,hist,noise,time
  real*8,allocatable,dimension(:,:)::xb(:,:),aux_y(:,:)
  real,allocatable,dimension(:,:,:)::Y_xb(:,:,:),Y(:,:,:) !Dimensions lon,lat,time
  character (len=500)::FILE_NAME,Path,FILE_NAME2,FILE_NAME3,runid
  integer :: ncid,varid,status,latid,lonid,levelid,timeid,lat_varid,n_cells_int,indi,pixelid,pixel_len,ilatid,ilonid
  integer,allocatable,dimension(:) :: nx_int(:),ny_int(:),pixel(:),ilat(:),ilon(:)
  real,allocatable,dimension(:)::latitude
  logical :: file_exists
  
  !=====Numero de Celdas====
  n_cells_int=28
	allocate(nx_int(n_cells_int))
	allocate(ny_int(n_cells_int))
	
	
	
!============ Read information about NC files,location and number of ensembles ============ Modify with the template of the real ensemble members
  open(61,file='./temp/Ensembles.in',status='old')
  read(61,"(A200)") Path
  read(61,*) Ens
  close(61)
!============ Read Initial time and Assimilation Windows and runid======
  open(61,file='./DATA_4DEnVAR/parameters.in',status='old')
  read(61,*) dawindows
  close(61)
  
  open(61,file='./DATA_4DEnVAR/startdate.in',status='old')
  read(61,*) initial_day
  read(61,*) days_simulation
  close(61)
  
  open(61,file='./DATA_4DEnVAR/runid.in',status='old')
  read(61,*) runid
  close(61)
  
  
  loop_Read_Ens: do j=1,Ens
  	if (j < 10) then            
	    write (FILE_NAME2,'(i1)') j ! converting integer to string using a 'internal file'
	    FILE_NAME=trim(path)//"/Ens_x0"//trim(FILE_NAME2)//'.nc'
    else            
	    write (FILE_NAME2,'(i2)') j ! converting integer to string using a 'internal file'	   
	    FILE_NAME=trim(path)//"/Ens_x"//trim(FILE_NAME2)//'.nc'
    endif
    write(*,*) 'Writing Ensemble '//trim(FILE_NAME2)
    !Get for the dimensions ID 
    status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
    status = nf90_inq_dimid(ncid, "latitude", latid)
    status = nf90_inq_dimid(ncid, "longitude", lonid)     
    status = nf90_inquire(ncid, unlimiteddimid = timeid)

    !Get dimensions length
    status = nf90_inquire_dimension(ncid, latid, len = lat)
    status = nf90_inquire_dimension(ncid, lonid, len = lon)
    status = nf90_inquire_dimension(ncid, timeid, len = time)

    !Write dimensions in file for next scripts
    if (j .eq. 1) then
			allocate(aux(lon,lat,1,1,time))
	    allocate(xb(n_cells_int,time))
    	allocate(latitude(lat))
		  open(61,file='./data/dimensions.dat',status='unknown')
			write(61,*)lat
			write(61,*)lon
			write(61,*)time
			close(61)
    endif

    ! Get the varid of the data variable, based on its name.
    status= nf90_inq_varid(ncid, "dc", varid)
    status= nf90_inq_varid(ncid, "latitude", lat_varid)
    !Read the data.
    status=nf90_get_var(ncid, lat_varid, latitude)
    ! Read the data.
    status=nf90_get_var(ncid, varid, aux)
    !Santiago Medellin (45,46) (46,47) (67,70) (70,80)
    !Escribir los nx_int y ny_int en archivos  
    nx_int=(/54,43,16,75,59,83,89,104,55,53,54,55,55,54,43,44,44,16,17,74,75,60,60,83,89,105,56,57/)
    ny_int=(/36,111,90,85,32,12,42,56,36,36,37,37,35,35,112,112,111,89,89,84,84,32,33,11,41,56,38,37/)


    do k=1,n_cells_int
  		xb(k,:)=aux(nx_int(k),ny_int(k),1,1,:)  
    enddo
    status= nf90_close(ncid) 
    if (j<10) then
    	open(61,file='./data/Ens_x0'//trim(FILE_NAME2)//'.dat',status='unknown')
    else
	  	open(61,file='./data/Ens_x'//trim(FILE_NAME2)//'.dat',status='unknown')
    endif
    write(61,*) xb(:,:)
    close(61)
  end do loop_Read_Ens

! ============ Read information about NC files of Ensemble outputs Revisar formato de salida satelites, preguntar al nc por numero de observaciones============
	allocate(Y_xb(lon,lat,days_simulation))
	loop_Read_Y_Ens: do j=1,Ens
		loop_days:  do i=0,days_simulation-1	   
		if (j < 10) then
			write (FILE_NAME2,'(i1)') j ! converting integer to string using a 'internal file'
			write (FILE_NAME3,'(i8)') i+initial_day        
			FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1800_xi0"//trim(FILE_NAME2)//'a.nc'
		else            
			write (FILE_NAME2,'(i2)') j ! converting integer to string using a 'internal file'
			write (FILE_NAME3,'(i8)') i+initial_day 	   
			FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1800_xi"//trim(FILE_NAME2)//'a.nc'
		endif
		write(*,*) FILE_NAME
		write(*,*) 'Writing Ensemble output '//trim(FILE_NAME2)//' Day '//trim(FILE_NAME3)
	  !Get for the dimensions ID 
		status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
		status = nf90_inq_dimid(ncid, "pixel", pixelid)
		!Get dimensions length
		status = nf90_inquire_dimension(ncid, pixelid, len = pixel_len) 
        write(*,*) 'Pixel Len ', pixel_len
		! Get the varid of the data variable, based on its name.
		status= nf90_inq_varid(ncid, "y", varid) 
        write(*,*) 'Status varid y',status
		allocate(aux_y(1,pixel_len))
		allocate(ilat(pixel_len))
        allocate(ilon(pixel_len))
		! Read the data.
aux_y=1
		status=nf90_get_var(ncid, varid, aux_y)
        write(*,*) 'Status Lectura ',status
        
		status= nf90_close(ncid)
		! Get ilonid and ilatid
		FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1800.nc"
        
		status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
        status= nf90_inq_varid(ncid, "ilat", ilatid)
        status= nf90_inq_varid(ncid, "ilon", ilonid)
		! Read the data.
		status=nf90_get_var(ncid, ilatid, ilat)
        write(*,*) 'Status ilat ',status
        write(*,*) 'max ilat', maxval(ilat)
		status=nf90_get_var(ncid, ilonid, ilon)
		status= nf90_close(ncid)	  
		Y_xb=0.0
		do k=1,pixel_len
            if (aux_y(1,k) .ge. 0) then
			    Y_xb(ilon(k),ilat(k),i+1)=aux_y(1,k)
            endif
		enddo
		deallocate(aux_y)
		deallocate(ilat)
        deallocate(ilon)
		!=Check if exists other satelite file for the same day
		if (j < 10) then
			write (FILE_NAME2,'(i1)') j ! converting integer to string using a 'internal file'
			write (FILE_NAME3,'(i8)') i+initial_day        
			FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1900_xi0"//trim(FILE_NAME2)//'a.nc'
		else            
			write (FILE_NAME2,'(i2)') j ! converting integer to string using a 'internal file'
			write (FILE_NAME3,'(i8)') i+initial_day 	   
			FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1900_xi"//trim(FILE_NAME2)//'a.nc'
		endif
		INQUIRE(FILE=FILE_NAME, EXIST=file_exists)
		if (file_exists) then
			status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
			status = nf90_inq_dimid(ncid, "pixel", pixelid)
			!Get dimensions length
			status = nf90_inquire_dimension(ncid, pixelid, len = pixel_len)
			! Get the varid of the data variable, based on its name.
			status= nf90_inq_varid(ncid, "y", varid)
		    
			allocate(aux_y(1,pixel_len))
			allocate(ilat(pixel_len))
    	allocate(ilon(pixel_len))
			! Read the data.
			status=nf90_get_var(ncid, varid, aux_y)
			status= nf90_close(ncid)
			! Get ilonid and ilatid
			FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1900.nc"
			status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
		  status= nf90_inq_varid(ncid, "ilat", ilatid)
		  status= nf90_inq_varid(ncid, "ilon", ilonid)
			! Read the data.
			status=nf90_get_var(ncid, ilatid, ilat)
			status=nf90_get_var(ncid, ilonid, ilon)
			status= nf90_close(ncid)
			do k=1,pixel_len
              if (aux_y(1,k) .ge. 0) then
			      if (Y_xb(ilon(k),ilat(k),i+1) .NE. 0.0) then
					    Y_xb(ilon(k),ilat(k),i+1)=(aux_y(1,k)+ Y_xb(ilon(k),ilat(k),i))/2
			      else
					    Y_xb(ilon(k),ilat(k),i+1)=aux_y(1,k)
			      endif
               endif
			enddo
			deallocate(aux_y)
			deallocate(ilat)
    	    deallocate(ilon)
		endif
	enddo loop_days
	if (j<10) then
		open(61,file='./data/Y_Ens_x0'//trim(FILE_NAME2)//'.dat',status='unknown')
	else
		open(61,file='./data/Y_Ens_x'//trim(FILE_NAME2)//'.dat',status='unknown')
	endif
	write(61,*) Y_xb(:,:,:)
	close(61)
	write(*,*) 'max Y_xb',i+1,'=',(maxval(Y_xb))
enddo loop_Read_Y_Ens

! ============ Read information about NC files of observations ============ Modify with the template of the real observations
allocate(Y(lon,lat,days_simulation))
loop_days_y:  do i=0,days_simulation-1
	write (FILE_NAME3,'(i8)') i+initial_day 	   
	FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1800.nc"
	write(*,*) 'Writing Observations for Day '//trim(FILE_NAME3)
	status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
	status = nf90_inq_dimid(ncid, "pixel", pixelid)
	!Get dimensions length
	status = nf90_inquire_dimension(ncid, pixelid, len = pixel_len) 
	! Get the varid of the data variable, based on its name.
	status= nf90_inq_varid(ncid, "yr", varid) 
	status= nf90_inq_varid(ncid, "ilat", ilatid)
	status= nf90_inq_varid(ncid, "ilon", ilonid)
	allocate(aux_y(1,pixel_len))
	allocate(ilat(pixel_len))
	allocate(ilon(pixel_len))
	! Read the data.
	status= nf90_get_var(ncid, varid, aux_y)
    write(*,*) 'Status Lectura ',status
   
	status= nf90_get_var(ncid, ilatid, ilat)
	status= nf90_get_var(ncid, ilonid, ilon)	
	status= nf90_close(ncid)
	Y=0.0
	do k=1,pixel_len
        if (aux_y(1,k) .ge. 0) then
		    Y(ilon(k),ilat(k),i+1)=aux_y(1,k) 
        endif
	enddo
	deallocate(aux_y)
	deallocate(ilat)
	deallocate(ilon)
	!=Check if exists other satelite file for the same day
	FILE_NAME=trim(path)//"/LE_"//trim(runid)//"_tropomi-no2_"//trim(FILE_NAME3)//"_1900.nc"
	INQUIRE(FILE=FILE_NAME, EXIST=file_exists)
	if (file_exists) then
		status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
		status = nf90_inq_dimid(ncid, "pixel", pixelid)
		!Get dimensions length
		status = nf90_inquire_dimension(ncid, pixelid, len = pixel_len)
		! Get the varid of the data variable, based on its name.
		status= nf90_inq_varid(ncid, "yr", varid)
	  status= nf90_inq_varid(ncid, "ilat", ilatid)
		status= nf90_inq_varid(ncid, "ilon", ilonid) 
		allocate(aux_y(1,pixel_len))
		allocate(ilat(pixel_len))
  	allocate(ilon(pixel_len))
		! Read the data.
		status=nf90_get_var(ncid, varid, aux_y)
		status=nf90_get_var(ncid, ilatid, ilat)
		status=nf90_get_var(ncid, ilonid, ilon)
		status= nf90_close(ncid)
		do k=1,pixel_len
          if (aux_y(1,k) .ge. 0) then
		      if (Y(ilon(k),ilat(k),i+1) .NE. 0.0) then
				    Y(ilon(k),ilat(k),i+1)=(aux_y(1,k)+ Y(ilon(k),ilat(k),i+1))/2
			    else
				    Y(ilon(k),ilat(k),i+1)=aux_y(1,k)
			    endif
              endif
		enddo
		deallocate(aux_y)
		deallocate(ilat)
  	deallocate(ilon)
	endif
enddo loop_days_y
open(61,file='./data/Y.dat',status='unknown')
write(61,*) Y(:,:,:)
close(61)
 write(*,*) 'max Y observation = ', (maxval(Y))
deallocate(Y)



!===Write nx_int, ny_int for next scripts===
open(61,file='./data/cells_DC.dat',status='unknown')
write(61,*) n_cells_int
write(61,*) nx_int
write(61,*) ny_int
close(61)

  

end program read_le_ensemble_outputs
