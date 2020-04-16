program histogram
use omp_lib
implicit none
integer::i,int_value,N=1000000,M=10
real::values
integer,allocatable,dimension(:)::hist_M
real :: start_time, stop_time

allocate(hist_M(M))

hist_M=0
call OMP_set_num_threads(12)
call cpu_time(start_time)

!$OMP PARALLEL  &
!$OMP  shared(N,hist_M ) &
!$OMP private(values,int_value) 
!$OMP DO
do i=1,N
	CALL RANDOM_NUMBER(values)
	values=values*M
	int_value=int(values)

!$OMP ATOMIC
	hist_M(int_value+1)=hist_M(int_value+1)+1

end do
!$OMP END DO
!$OMP END PARALLEL
call cpu_time(stop_time)

write(*,*)"The histogram is:", hist_M
write(*,*) "Executing time: ",  stop_time - start_time, "seconds"
deallocate(hist_M)

end program histogram
