
program LETKF_Lorenz_openMP
  USE modulo_distribucion_normal
  use module_EnKF
  use module_matrix
  use omp_lib
  implicit none
  integer::n,m,tsim,Nen,fileidreal=1000
  real*8,parameter::F=8
  real*8,parameter::sigmaobs=0.001
  integer::k,i,ii,j,l,fileid     ! i for states, ii local observations j for time, k for ensembles, l for local components
  real*8::realaux
  integer::intaux,mlocal,rho
  real*8,parameter :: dt=0.01
  real*8,allocatable,dimension(:,:,:):: xa,xb,xblocal,xalocal
  real*8,allocatable,dimension(:,:)::xreal,Hobs,P,dXen,Robs
  real*8,allocatable,dimension(:,:)::xbmean,xamean
  real*8,allocatable,dimension(:)::aux_vect,aux_vect2,y,xreal_local
  integer,allocatable,dimension(:)::Hn_index,Hm_index,local_index
  real::start_time, stop_time
  Character(len=20)::filename
  call OMP_set_num_threads(5)  	 	
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
  allocate(P(2*rho+1,2*rho+1))
  allocate(dXen(2*rho+1,Nen))
  allocate(xblocal(2*rho+1,Nen,tsim))
  allocate(xalocal(2*rho+1,Nen,tsim))
  allocate(xamean(2*rho+1,tsim))
  allocate(xbmean(2*rho+1,tsim))
  allocate(local_index(2*rho+1))
  allocate(xreal_local(2*rho+1))
  allocate(Hn_index(n))
  allocate(Hm_index(m))
  !===Random observed states===
  Hn_index=(/ (i,i=1,n) /)
  call randperm(n,m,Hn_index,Hm_index)


  
  !=== Ensemble initialization===
  CALL RANDOM_NUMBER(xreal(:,1))
  do k=1,Nen
     CALL RANDOM_NUMBER(xa(:,k,1))
     xa(:,k,1)=-1*xa(:,k,1)+xa(:,k,1)*2
  end do
call cpu_time(start_time)
  loop_time:do j=2,tsim
     !=== Real State Simulation===
     CALL Lorenz_96_One_Step(n,dt,xreal(:,j-1),F,xreal(:,j))
     loop_Ensemble1: do k=1,Nen
     !=== Forecast Step===
        CALL Lorenz_96_One_Step(n,dt,xa(:,k,j-1),F,xb(:,k,j))   
     end do loop_Ensemble1
     !=== Calculate local P matrix and obtain local observations===

!$OMP PARALLEL FIRSTPRIVATE(Hobs,Robs,y,mlocal,P,dXen,xblocal,xalocal,xreal_local,local_index)
!$OMP DO schedule(static)
     loop_each_state_component:do i=1,n 
     	do k=1,Nen
	 			do l=1,rho
     			if (i-(rho-l+1) .le. 1) then
     				xblocal(l,k,j)=xb(n+(i-(rho-l+1)),k,j)
     				xreal_local(l)=xreal(n+(i-(rho-l+1)),j)
						local_index(l)=n+(i-(rho-l+1))
     			else
     				xblocal(l,k,j)=xb(i-(rho-l+1),k,j)
						local_index(l)=(i-(rho-l+1))
						xreal_local(l)=xreal((i-(rho-l+1)),j)
     			endif
	 			enddo
   			xblocal(rho+1,k,j)=xb(i,k,j)
				local_index(rho+1)=i
				xreal_local(rho+1)=xreal(i,j)
     		do l=rho+2,2*rho+1
     			if (i+l .ge. n) then
	   				xblocal(l,k,j)=xb((i+l-rho)-n,k,j)
						local_index(l)=((i+l-rho)-n)
						xreal_local(l)=xreal((i+l-rho)-n,j)
     			else
     				xblocal(l,k,j)=xb(i+l-rho,k,j)
     				local_index(l)=(i+l-rho)
     				xreal_local(l)=xreal((i+l-rho),j)
     			endif
	 			enddo
	 		enddo

     	call ensmean(xblocal(:,:,j),xbmean(:,j)) !Calculate the Ensemble mean, from module_EnKF
     	call anomalies(xblocal(:,:,j),xbmean(:,j),dXen) !Calculate anomalies matrix dX, from module_EnKF
	 		P=prod(dXen,transpose(dXen)) !Calculate product between two matrix, from module_matrix
	 		!=== Obtain observations into local domain===
      mlocal=0 
      !==First obtain number of observations==
      do ii=1,m
      	do l=1,2*rho+1
      		if (Hm_index(ii) .eq. local_index(l)) then
      			mlocal=mlocal+1
      		endif
      	enddo 	
  		enddo
  		if (mlocal .eq. 0) then
  		   xa(i,:,j)=xblocal(rho+1,:,j)
  		else
				allocate(Hobs(mlocal,2*rho+1))
				allocate(Robs(mlocal,mlocal))
				allocate(y(mlocal))
				Hobs=0
				Robs=0
				y=0
				mlocal=0
				do ii=1,m
		    	do l=1,2*rho+1
		    		if (Hm_index(ii) .eq. local_index(l)) then
		    			mlocal=mlocal+1
		    			Hobs(mlocal,l)=1
		    			Robs(mlocal,mlocal)=sigmaobs**2
		    		endif
		    	enddo 	
				enddo 
				y=prod_matvec(Hobs,xreal_local)   !Calculate product between a matrix and a vector in that order, from module_matrix
		    call Analysis_EnKF(xblocal(:,:,j),P,Hobs,Robs,sigmaobs,y,xalocal(:,:,j)) !Analysis Step, from module_EnKF
		    xa(i,:,j)=xalocal(rho+1,:,j)
      endif
      deallocate(Hobs)
  		deallocate(Robs)
  		deallocate(y)	
  	enddo loop_each_state_component
!$OMP END DO
!$OMP END PARALLEL
    call ensmean(xa(:,:,j),xamean(:,j)) !Calculate the Ensemble mean, from module_EnKF

  enddo loop_time

call cpu_time(stop_time)
write(*,*) "Executing time: ",  stop_time - start_time, "seconds"
!  !===Imprimir Resultados===

  open(5000,file='./Data/Xamean.dat',status='unknown')
  write(5000,*) ((xamean(i,j),i=1,n),j=1,tsim) !El interno para filas
  close(5000)
  open(5001,file='./Data/Xreal.dat',status='unknown')
  write(5001,*) ((xreal(i,j),i=1,n),j=1,tsim) !El interno para filas
  close(5001)



end program LETKF_Lorenz_openMP

