
program EnKF_Lorenz
  USE modulo_distribucion_normal
  use module_EnKF
  use module_matrix
  implicit none
  !integer,parameter::n=40,m=20,tsim=1000,Nen=30,fileidreal=1000
  integer::n,m,tsim,Nen,fileidreal=1000
  real*8,parameter::F=8
  real*8,parameter::sigmaobs=0.001
  integer::k,i,j,fileid     ! i for states, j for time, k for ensembles
  real*8::realaux
  integer::intaux
  real*8,parameter :: dt=0.01
  real*8,allocatable,dimension(:,:,:):: xa,xb
  real*8,allocatable,dimension(:,:)::xreal,Hobs,P,dXen,Robs
  real*8,allocatable,dimension(:,:)::xbmean,xamean
  real*8,allocatable,dimension(:)::aux_vect,aux_vect2,y
  integer,allocatable,dimension(:)::Hn_index,Hm_index
  
  Character(len=20)::filename

  !====Reading parameters from .in file====
  open(61,file='./Data/parameters.in',status='old')
  read(61,*) n
  read(61,*) m
  read(61,*) Nen
  read(61,*) tsim
  
  !==== Writing parameters for Python Visualization====
    open(61,file='./Data/parameters_python.dat.out',status='unknown')
    write(61,*) n
    write(61,*) m
    write(61,*) Nen
    write(61,*) tsim
    
    close(61)
  
  !===Matriz Initialization===
  allocate(xb(n,Nen,tsim))
  allocate(xa(n,Nen,tsim))
  allocate(xreal(n,tsim))
  allocate(Hobs(m,n))
  allocate(P(n,n))
  allocate(dXen(n,Nen))
  allocate(Xamean(n,tsim))
  allocate(Xbmean(n,tsim))
  allocate(y(m))
  allocate(Robs(m,m))
  allocate(Hn_index(n))
  allocate(Hm_index(m))
  Hobs=0
  Robs=0
  !===Random observed states===
  Hn_index=(/ (i,i=1,n) /)
  call randperm(n,m,Hn_index,Hm_index)
  do i=1,m
     Hobs(i,Hm_index(i))=1
     Robs(i,i)=sigmaobs**2
  end do
  
  !call r8mat_print(m,n,Hobs,'Observation Matrix')

  !=== Ensemble initialization===
  CALL RANDOM_NUMBER(xreal(:,1))
  do k=1,Nen
     CALL RANDOM_NUMBER(xa(:,k,1))
     xa(:,k,1)=-1*xa(:,k,1)+xa(:,k,1)*2
  end do

  loop_time:do j=2,tsim
     !=== Real State Simulation===
     CALL Lorenz_96_One_Step(n,dt,xreal(:,j-1),F,xreal(:,j))
! go to 100
     !open(fileidreal,file='./Data/Real_AUX_.dat',status='unknown')
     !write(fileidreal,*) (xreal(i,j),i=1,n)
     !close(fileidreal)


     loop_Ensemble1: do k=1,Nen
        !=== Forecast Step===
        CALL Lorenz_96_One_Step(n,dt,xa(:,k,j-1),F,xb(:,k,j))
        !===Se escriben archivos de salida simulando un modelo externo===
        !fileid=100+k
        !CALL str(k,filename)       
        !open(fileid,file='./Data/Ensemble_AUX_'//trim(filename)//'.dat',status='unknown')
        !write(fileid,*) (xb(i,k,j),i=1,n)
        !close(fileid)      
     end do loop_Ensemble1

     !=== Leer estados de cada ensamble desde archivos simulando un modelo exter===    
     !loop_Ensemble2: do k=1,Nen
        !fileid=100+k
        !CALL str(k,filename)       
        !open(fileid,file='./Data/Ensemble_AUX_'//trim(filename)//'.dat',status='old')
        !read(fileid,*)(xb(i,k,j),i=1,n)
        !close(fileid)       
     !end do loop_Ensemble2

     call ensmean(xb(:,:,j),xbmean(:,j)) !Calculate the Ensemble mean, from module_EnKF
     call anomalies(xb(:,:,j),xbmean(:,j),dXen) !Calculate anomalies matrix dX, from module_EnKF
     P=prod(dXen,transpose(dXen)) !Calculate product between two matrix, from module_matrix
     !=== Observations===
     y=prod_matvec(Hobs,Xreal(:,j))   !Calculate product between a matrix and a vector in that order, from module_matrix
     call Analysis_EnKF(xb(:,:,j),P,Hobs,Robs,sigmaobs,y,xa(:,:,j)) !Analysis Step, from module_EnKF
     call ensmean(xa(:,:,j),xamean(:,j)) !Calculate the Ensemble mean, from module_EnKF
!100  continue
  end do loop_time


  !===Imprimir Resultados===


  open(5000,file='./Data/Xamean.dat',status='unknown')
  write(5000,*) ((xamean(i,j),i=1,n),j=1,tsim) !El interno para filas
  close(5000)
  open(5001,file='./Data/Xreal.dat',status='unknown')
  write(5001,*) ((xreal(i,j),i=1,n),j=1,tsim) !El interno para filas
  close(5001)



end program EnKF_Lorenz

