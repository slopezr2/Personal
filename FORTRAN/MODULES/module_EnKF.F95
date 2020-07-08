module module_EnKF
contains

  
subroutine ensmean(Xen,Xmean)
    !===Calculate de Mean of a Matrix====
   implicit none
   integer :: nrens,j
   real,dimension(:,:), intent(in)  :: Xen
   real,dimension(size(Xen,2)),intent(out) :: Xmean
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
   real,dimension(:,:), intent(in)  :: Xen
   real,dimension(:,:),intent(in)::Xmean
   real,dimension(size(Xen,1),size(Xen,2)),intent(out)::dXen
   nrens=size(Xen,2)
   do j=1,nrens
      dXen(:,j)=Xen(:,j)-Xmean
   end do



end subroutine anomalies




end module module_EnKF
