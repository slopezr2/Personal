program dyadic
use omp_lib
implicit none
integer::i,N=10000,j
real,allocatable,dimension(:)::x,y
real,allocatable,dimension(:,:)::c
real::start_time, stop_time
allocate(x(N))
allocate(y(N))
allocate(c(N,N))
call cpu_time(start_time)

do i=1,N
	x(i)=i
	y(i)=i*i
enddo


call OMP_set_num_threads(12)


!$OMP PARALLEL shared(N,y,x,c) 
!$OMP DO schedule(static) collapse(2)
do i=1,N
	do j=1,N
		c(i,j)=x(i)*y(j)
	enddo
enddo

!$OMP END DO
!$OMP END PARALLEL
call cpu_time(stop_time)
write(*,*) "Executing time: ",  stop_time - start_time, "seconds"
deallocate(x,y,c)
!do i=1,N
!	write(*,*)c(i,:)
!enddo

end program dyadic
