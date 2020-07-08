program calculate_pi
use omp_lib
implicit none
integer::i,steps=100000,M_pi,N,thread_id
real::x,y

M_pi=0

call OMP_set_num_threads(12)


!$OMP PARALLEL private(x,y,thread_id) &
!$OMP  shared(N) &
!$OMP reduction( + : M_pi )

thread_id = OMP_GET_THREAD_NUM()
PRINT *, "Hello from process: ", thread_id
N=OMP_get_num_threads()
!$OMP DO
do i=1,steps
       CALL RANDOM_NUMBER(x)
       CALL RANDOM_NUMBER(y)


        if (x*x + y*y < 1.0) then
            M_pi=M_pi+1
   	endif

end do
!$OMP END DO

!$OMP END PARALLEL

write(*,*) N
write(*,*)"Pi is:", 4*real(M_pi)/real(steps)


end program calculate_pi
