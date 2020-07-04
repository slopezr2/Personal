program random_parallel
implicit none
include '/usr/include/mpich-x86_64/mpif.h'
integer::i,flag=0,j,n=1,seed
real,allocatable,dimension(:)::a
real::rnumber,eps=1e-7,rnumbe
r1
real :: start_time, stop_time
!Parallel Variables
integer:: nproc,my_rank,ierror,tag=1000,count_mpi=0
integer status(MPI_STATUS_SIZE)
integer:: request_send,request_recv 


!Parallel Initialization
call MPI_INIT(ierror)
!Processes and rank information
call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,ierror)
i=1


if (my_rank==0) then
	call cpu_time(start_time)
	write(*,*) "Initialization"
	allocate(a(10+nproc*10)) 
endif
call RANDOM_SEED()
do while (flag==0) 
	if (my_rank==0) then
		call MPI_IRECV(rnumber,1,MPI_REAL,MPI_ANY_SOURCE,MPI_ANY_TAG,MPI_COMM_WORLD,request_recv,ierror)
		call MPI_WAIT(request_recv,status)
		a(i)=rnumber
		i=i+1
		if (i>10) then
			call cpu_time(stop_time)
			write(*,*) "Executing time: ",  stop_time - start_time, "seconds"
			write(*,*) "Number of random numbers: ", i-1
			write(*,*) "Random numbers: ", a(1:i-1) 
			CALL MPI_Abort(MPI_COMM_WORLD,2,ierror)
			exit
		endif
	elseif (my_rank>0) then
	CALL RANDOM_NUMBER(rnumber)
		if (rnumber<eps) then
			call MPI_ISEND(rnumber,1,MPI_REAL,0,tag,MPI_COMM_WORLD,request_send,ierror)
			call MPI_WAIT(request_send,status)
		endif		
			
	endif
	!call MPI_BCAST(flag,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierror)
end do

call MPI_FINALIZE(ierror)




end program random_parallel
