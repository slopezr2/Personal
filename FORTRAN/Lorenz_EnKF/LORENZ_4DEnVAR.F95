program Lorenz_4DEnVAR
  !USE modulo_distribucion_normal
  use module_EnKF
  use module_matrix
  implicit none

  integer::n,m,tsim,Nen,dawindows,inner,fileidreal=1000
  integer::st_ass
  real*8,parameter::F=8
  real*8::sigmaobs
  integer::k,i,j,l,fileid     ! i for states, j for time, k for ensembles,l for inner steps
  real*8::realaux
  integer::intaux,flaq
  real*8,parameter :: dt=0.01
  real*8::tolerance,sparse
  real*8,allocatable,dimension(:,:,:):: xa,xb,Yb,xk
  real*8,allocatable,dimension(:,:)::xreal,Hobs,P,dXen,Robs,inR
  real*8,allocatable,dimension(:,:)::increment,inno,sum1,ident
  real*8,allocatable,dimension(:)::sum2,norma
  real*8,allocatable,dimension(:,:,:)::dY
  real*8,allocatable,dimension(:)::aux_vect,aux_vect2,y,xbmean,xamean,ymean
  integer,allocatable,dimension(:)::Hn_index,Hm_index
  

  Character(len=20)::filename

  !====Reading parameters from .in file====
  open(61,file='./DATA_4DEnVAR/parameters.in',status='old')
  read(61,*) n
  read(61,*) m
  read(61,*) Nen
  read(61,*) tsim
  read(61,*) dawindows
  read(61,*) st_ass
  read(61,*) inner
  read(61,*) tolerance
  read(61,*) sparse
  read(61,*) sigmaobs
  close(61)
  
  !==== Writing parameters for Python Visualization====
    open(61,file='./DATA_4DEnVAR/parameters_python.out',status='unknown')
    write(61,*) n
    write(61,*) m
    write(61,*) Nen
    write(61,*) tsim
    write(61,*) dawindows
    write(61,*) st_ass
    close(61)
  
  !===Matriz Initialization===
  allocate(xb(n,Nen,tsim))
  allocate(xa(n,Nen,tsim))
  allocate(Yb(m,Nen,tsim))
  allocate(xreal(n,tsim))
  allocate(Hobs(m,n))
  allocate(P(n,n))
  allocate(dXen(n,Nen))
  allocate(dY(m,Nen,tsim))
  allocate(Xamean(n))
  allocate(Xbmean(n))
  allocate(y(m))
  allocate(ymean(m))
  allocate(Robs(m,m))
  allocate(inR(m,m))
  allocate(Hn_index(n))
  allocate(Hm_index(m))
  allocate(increment(Nen,inner))
  allocate(inno(m,tsim))
  allocate(ident(Nen,Nen))
  allocate(norma(inner))
  Hobs=0
  Robs=0
  inR=0
  ident=0
  !===Random observed states===
  Hn_index=(/ (i,i=1,n) /)
  call randperm(n,m,Hn_index,Hm_index)
  do i=1,m
     Hobs(i,Hm_index(i))=1
     Robs(i,i)=sigmaobs**2
     inR(i,i)=(1/(sigmaobs**2))
     ident(i,i)=1.0
  end do
  deallocate(Hn_index)
  deallocate(Hm_index)
  !=== Ensemble initialization===
  CALL RANDOM_NUMBER(xreal(:,1))
  do k=1,Nen
     CALL RANDOM_NUMBER(xb(:,k,1))
     xb(:,k,1)=-(sparse/2)*xb(:,k,1)+xb(:,k,1)*sparse
  end do

  loop_time:do j=2,tsim
     !=== Real State and Ensemble Simulation===
     CALL Lorenz_96_One_Step(n,dt,xreal(:,j-1),F,xreal(:,j))
     loop_ensemble:do k=1,Nen
        CALL Lorenz_96_One_Step(n,dt,xb(:,k,j-1),F,xb(:,k,j))
        Yb(:,k,j)=prod_matvec(Hobs,xb(:,k,j))
     end do loop_ensemble
     call ensmean(Yb(:,:,j),ymean(:)) !Calculate the Ensemble mean, from module_EnKF
     call anomalies(Yb(:,:,j),ymean(:),dY(:,:,j)) !Calculate anomalies matrix dX, from module_EnKF
     if (j .EQ. st_ass) then
        call ensmean(xb(:,:,j),xbmean(:)) !Calculate the Ensemble mean, from module_EnKF
        call anomalies(xb(:,:,j),xbmean(:),dXen) !Calculate anomalies matrix dX, from module_EnKF
     end if
     
  end do loop_time

  !=====Analysis Step===
  !===Inner Loop===
   CALL RANDOM_NUMBER(increment(:,1))
   allocate(xk(n,tsim,inner))
   xk(:,st_ass,1)=xbmean+prod_matvec(dXen,increment(:,1))


   loop_time_analysis: do j=(st_ass+1),tsim
      CALL Lorenz_96_One_Step(n,dt,xk(:,j-1,1),F,xk(:,j,1))
      y=prod_matvec(Hobs,Xreal(:,j))
      inno(:,j)=y-prod_matvec(Hobs,xk(:,j,1))
   end do loop_time_analysis

   allocate(sum1(Nen,Nen))
   allocate(sum2(Nen))
   l=2
   norma(1)=tolerance
   flaq=0
   allocate(aux_vect(m))
   loop_inner:do while ((l .LE. inner) .AND. (norma(l-1) .GE. tolerance))
      sum1=0
      sum2=0
      do i=st_ass+1,st_ass+dawindows
         sum1=sum1+prod(prod(transpose(dY(:,:,i)),inR),dY(:,:,i))
         sum2=sum2+ prod_matvec(prod(transpose(dY(:,:,i)),inR),inno(:,i))
      end do
      increment(:,l)=prod_matvec(inv(ident+sum1),sum2)
      !=== Incremental===
      xk(:,st_ass,l)=xk(:,st_ass,l-1)+prod_matvec(dXen,increment(:,l))
      loop_time_analysis_inner: do j=(st_ass+1),tsim
         CALL Lorenz_96_One_Step(n,dt,xk(:,j-1,l),F,xk(:,j,l))
         y=prod_matvec(Hobs,Xreal(:,j))
         call random_number(aux_vect)
         inno(:,j)=y-prod_matvec(Hobs,xk(:,j,l))+aux_vect*sigmaobs**2
      end do loop_time_analysis_inner
      norma(l)=norm2(prod_matvec(dXen,increment(:,l)))
      if (norma(l) .LE. norma(l-1)) then
         flaq=flaq+1
      end if
      if (flaq .EQ. 2) then
         EXIT
      end if
      
      l=l+1
   end do loop_inner
   
   open(5000,file='./DATA_4DEnVAR/Xamean.dat',status='unknown')
   write(5000,*) ((xk(i,j,l-1),i=1,n),j=1,tsim) !El interno para filas
   close(5000)
   open(5001,file='./DATA_4DEnVAR/Xreal.dat',status='unknown')
   write(5001,*) ((xreal(i,j),i=1,n),j=1,tsim) !El interno para filas
   close(5001)

   
end program Lorenz_4DEnVAR
