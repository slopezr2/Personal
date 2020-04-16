program axpy
use omp_lib
implicit none
integer::i,N=800000000
real,allocatable,dimension(:)::x,y
real::alpha, start_time, stop_time
alpha=2
allocate(x(N))
allocate(y(N))

call cpu_time(start_time)




call OMP_set_num_threads(12)


!$OMP PARALLEL shared(N,y,x,alpha)
!$OMP DO schedule(static)
do i=1,N
	x(i)=i
	y(i)=i
	y(i)=alpha*x(i)+y(i)
enddo


!$OMP END DO

!$OMP END PARALLEL
call cpu_time(stop_time)
write(*,*) "Executing time: ",  stop_time - start_time, "seconds"

!write(*,*)"Vector y:", y


end program axpy
