program dyadic
use omp_lib
implicit none
integer::i,N=1000,M=1000,O=1000,j,k
real,allocatable,dimension(:,:)::x,y,c
real::start_time, stop_time
allocate(x(N,M))
allocate(y(M,O))
allocate(c(N,O))
call cpu_time(start_time)




do i=1,N
	do j=1,M
		x(i,j)=i+j
	enddo
enddo


do i=1,M
	do j=1,O
		y(i,j)=i*j
	enddo
enddo



do i = 1,N
	do k = 1,O
		do j = 1,M
			C(i,k) =C(i,k)+ A(i,j) * B(j,k)
		enddo
	enddo
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
