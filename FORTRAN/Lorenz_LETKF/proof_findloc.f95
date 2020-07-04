
program LETKF_Lorenz
  USE modulo_distribucion_normal
  use module_EnKF
  use module_matrix
  implicit none
  integer::n,m,tsim,Nen,fileidreal=1000,mlocal
  real*8,parameter::F=8
  real*8,parameter::sigmaobs=0.001
  integer::k,i,j,l,fileid     ! i for states, j for time, k for ensembles, l for local components
  real*8::realaux,rho
  integer::intaux
  real*8,parameter :: dt=0.01
  real*8,allocatable,dimension(:,:,:):: xa,xb,xblocal
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
  read(61,*) rho
  close(61)
  
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
  allocate(P(2*rho+1,2*rho+1))
  allocate(dXen(2*rho+1,Nen))
  allocate(xblocal(2*rho+1,Nen))
  allocate(xamean(2*rho+1,tsim))
  allocate(xbmean(2*rho+1,tsim))
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
  

  !=== Ensemble initialization===
  CALL RANDOM_NUMBER(xreal(:,1))
  do k=1,Nen
     CALL RANDOM_NUMBER(xa(:,k,1))
     xa(:,k,1)=-1*xa(:,k,1)+xa(:,k,1)*2
  end do

  loop_time:do j=2,tsim
     !=== Real State Simulation===
     CALL Lorenz_96_One_Step(n,dt,xreal(:,j-1),F,xreal(:,j))
     loop_Ensemble1: do k=1,Nen
     !=== Forecast Step===
        CALL Lorenz_96_One_Step(n,dt,xa(:,k,j-1),F,xb(:,k,j))   
     end do loop_Ensemble1
     !=== Calculate local P matrix and obtain local observations===
     do i=1,n
        do k=1,N
					do l=1,rho
          	if (i-(rho-l+1) .le. 1) then
		        	xblocal(l,k,j)=xb(n+(i-(rho-l+1)),k,j)
            else
              xblocal(l,k,j)=xb(i-(rho-l+1),k,j)
            end
					 enddo
           xblocal(rho+1,k,j)=xb(i,k,j)
           do l=rho+2,2*rho+1
            if (i+l .ge. n) then
		        	xblocal(l,k,j)=xb((i+l-rho)-n,k,j)
            else
              xblocal(l,k,j)=xb(i+l-rho,k,j)
            endif
			     enddo
				enddo
        call ensmean(xblocal(:,:,j),xbmean(:,j)) !Calculate the Ensemble mean, from module_EnKF
     		call anomalies(xblocal(:,:,j),xbmean(:,j),dXen) !Calculate anomalies matrix dX, from module_EnKF
				P=prod(dXen,transpose(dXen)) !Calculate product between two matrix, from module_matrix
				!=== Obtain observations into local domain===
        


     enddo

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



end program LETKF_Lorenz

