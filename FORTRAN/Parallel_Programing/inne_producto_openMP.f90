program inner
use omp_lib
implicit none
integer::i,N=1000
real,allocatable,dimension(:)::x,y
real::start_time, stop_time,inner_prod
allocate(x(N))
allocate(y(N))
call cpu_time(start_time)




call OMP_set_num_threads(12)


!$OMP PARALLEL shared(N,y,x) &
!$OMP reduction( + : inner_prod )
!$OMP DO schedule(static)
do i=1,N
	x(i)=i
	y(i)=i*i
	inner_prod=inner_prod+(x(i)*y(i))
enddo

!$OMP END DO
!$OMP END PARALLEL
call cpu_time(stop_time)
write(*,*) "Executing time: ",  stop_time - start_time, "seconds"

write(*,*)"Inner Product:", inner_prod


end program inner
