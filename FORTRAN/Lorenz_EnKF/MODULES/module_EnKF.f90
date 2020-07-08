module module_EnKF
contains

  
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


end module module_EnKF
