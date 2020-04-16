module module_EnKF
use netcdf
contains


subroutine create_DC_NC(Xk,lat,lon,time)
!===Create a NC file with DC for LE forecast simulation====
   implicit none
   integer,intent(in)  :: lat,lon,time
   real*8,dimension(:), intent(inout)::Xk(lat*lon)
   real*8,dimension(:,:)::DC(lon,lat)
   real*8,dimension(:)::latitude(lat),longitude(lon),time_var(time)
   real*8,dimension(:,:,:,:,:)::DC_nc(lon,lat,1,1,time)
   integer::ncid,lat_dimid,lon_dimid,time_dimid,noise_dimid,hist_dimid,name_dimid
   integer::lat_varid,lon_varid,time_varid,dc_varid,noise_varid	,status
   integer::i
   character (len=100)::FILE_NAME,Path
    
	open(61,file='./temp/Ensembles.in',status='old')
	read(61,"(A200)") Path
    close(61)
    FILE_NAME=trim(path)//'/Ens_x01.nc'

    status = nf90_open(path = FILE_NAME, mode = nf90_nowrite, ncid = ncid)
    ! Get the varid of the data variable, based on its name.
    status= nf90_inq_varid(ncid, "latitude", lat_varid)
	status= nf90_inq_varid(ncid, "longitude", lon_varid)
	status= nf90_inq_varid(ncid, "time", time_varid)
    !Read the data.
    status=nf90_get_var(ncid, lat_varid, latitude)
	status=nf90_get_var(ncid, lon_varid, longitude)
	status=nf90_get_var(ncid, time_varid, time_var)
    status =nf90_close(ncid)

!===Create new DC file====
   status = nf90_create('./data/DC_inner_20190201.nc',NF90_CLOBBER, ncid)
!=== Define dimensions===
   status = nf90_def_dim(ncid, "latitude", lat, lat_dimid)
   status = nf90_def_dim(ncid, "longitude", lon, lon_dimid)
   status = nf90_def_dim(ncid, "noise", 1, noise_dimid)
   status = nf90_def_dim(ncid, "hist", 1, hist_dimid)
   status = nf90_def_dim(ncid, "time", time, time_dimid)
   status = nf90_def_dim(ncid, "namelen", 32, name_dimid)
!=== Define variables===
   status = nf90_def_var(ncid, "latitude", NF90_REAL8, (/ lat_dimid/), lat_varid)
   status = nf90_put_att(ncid, lat_varid, "standard_name", 'latitude')
   status = nf90_put_att(ncid, lat_varid, "units", 'degrees_north')
   status = nf90_put_att(ncid, lat_varid, "_CoordinateAxisType", 'Lat')

   status = nf90_def_var(ncid, "longitude", NF90_REAL8, (/lon_dimid/), lon_varid)
   status = nf90_put_att(ncid, lon_varid, "standard_name", 'longitude')
   status = nf90_put_att(ncid, lon_varid, "units", 'degrees_east')
   status = nf90_put_att(ncid, lon_varid, "_CoordinateAxisType", 'Lon')	

   status = nf90_def_var(ncid, "time", NF90_REAL8, (/ time_dimid/), time_varid)
   status = nf90_put_att(ncid, time_varid, "standard_name", 'time')
   status = nf90_put_att(ncid, time_varid, "long_name", 'time')
   status = nf90_put_att(ncid, time_varid, "units", 'seconds since 2019-01-01 00:00:00 UTC')
   status = nf90_put_att(ncid, time_varid, "calendar", 'standard')
   status = nf90_put_att(ncid, time_varid, "_CoordinateAxisType", 'Time')	

   status = nf90_def_var(ncid, "noise_name", NF90_CHAR, (/name_dimid, noise_dimid/), noise_varid)

   status = nf90_def_var(ncid, "dc", NF90_REAL8, (/ lon_dimid,lat_dimid,noise_dimid,hist_dimid,time_dimid/), dc_varid)
   
   status = nf90_enddef(ncid)
!=== Write Data===
    status =nf90_put_var(ncid, lat_varid, latitude)
    status =nf90_put_var(ncid, lon_varid, longitude)
	status =nf90_put_var(ncid, time_varid, time_var)
	DC=reshape(Xk,(/lon,lat/))
    do i=1,time
		DC_nc(:,:,1,1,i)=DC	
    enddo
	status =nf90_put_var(ncid, dc_varid, DC_nc)
	status =nf90_put_var(ncid, noise_varid, 'NOx_emis                        ')
	status =nf90_close(ncid)

end subroutine create_DC_NC
  
subroutine ensmean(Xen,Xmean)
    !===Calculate de Mean of a Matrix====
   implicit none
   integer :: nrens,j
   real*8,dimension(:,:), intent(in)  :: Xen
   real*8,dimension(size(Xen,2)),intent(out) :: Xmean
   nrens=size(Xen,2)
   
   Xmean(:)=Xen(:,1)
   do j=2,nrens
      Xmean(:)=Xmean(:)+Xen(:,j)
   enddo
   Xmean=(1.0/real(nrens))*Xmean

end subroutine ensmean


subroutine anomalies(Xen,Xmean,dXen)

   !===Calculate de Anomalies Matrix====
   implicit none
   integer :: nrens,j
   real*8,dimension(:,:), intent(in)  :: Xen
   real*8,dimension(:),intent(in)::Xmean
   real*8,dimension(size(Xen,1),size(Xen,2)),intent(out)::dXen
   nrens=size(Xen,2)
   do j=1,nrens
      dXen(:,j)=(Xen(:,j)-Xmean(:))
   end do
   dXen=(1.0/sqrt(real(nrens-1)))*dXen


end subroutine anomalies

subroutine Analysis_EnKF(Xben,P,H,R,sigmaobs,y,Xaen)
  use module_matrix
  implicit none
  real*8,dimension(:,:),intent(in)::Xben,P,H,R
  real*8,dimension(:),intent(in)::y
  real*8,intent(in)::sigmaobs
  real*8,dimension(size(Xben,1),size(Xben,2)),intent(out)::Xaen
  real*8,dimension(size(Xben,1))::z
  real*8,dimension(size(y,1))::v,d
  real*8,dimension(size(Xben,1),size(H,1))::Kalman,PHT
  real*8,dimension(size(H,1),size(H,1))::A
  integer ::k

  PHT=prod(P,transpose(H))
  A=prod(H,PHT)
  A=A+R
  A=inv(A)
  Kalman=prod(PHT,A)

  do k=1,size(Xben,2)
     call RANDOM_NUMBER(v(:))
     z(:)= prod_matvec(H(:,:), Xben(:,k))
      d(:)=y(:)-z(:)+  (sigmaobs)*v(:)
     Xaen(:,k)=Xben(:,k)+prod_matvec(Kalman,d)
  end do

  
end subroutine Analysis_EnKF



  subroutine check(status)
    integer, intent ( in) :: status
    
    if(status /= nf90_noerr) then 
      !print *, trim(nf90_strerror(status))
      stop "Stopped"
    end if
  end subroutine check




end module module_EnKF
