program random_parallel
implicit none
include '/usr/include/mpich-x86_64/mpif.h'
integer::i,flag=0,j
real,allocatable,dimension(:)::a,aux
real::rnumber,eps=1e-20
real :: start_time, stop_time
!Parallel Variables
integer:: nproc,my_rank,ierror,tag=1000,count_mpi=0
integer status(MPI_STATUS_SIZE)
integer request_send,request_recv 


!Parallel Initialization
call MPI_INIT(ierror)
!Processes and rank information
call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,ierror)
i=1

if (my_rank==0) then
	call cpu_time(start_time)
	write(*,*) "Initialization"
	allocate(a(20+nproc*10)) 
endif
allocate(aux(nproc))

do while (flag==0) 
	CALL RANDOM_NUMBER(rnumber)
	if (my_rank==0) then
	 	call MPI_GATHER(aux,1,MPI_REAL,rnumber,1,MPI_REAL,0,MPI_COMM_WORLD,ierror)

		do j=1,nproc
			if (aux(j)<eps) then
				a(i)=aux(j)
				i=i+1
			endif

		end do 	

		if (i>10) then
			flag=1
		endif
	elseif (my_rank>0) then	
		call MPI_GATHER(aux,1,MPI_REAL,rnumber,1,MPI_REAL,0,MPI_COMM_WORLD,ierror) 
	endif
	call MPI_BCAST(flag,1,MPI_INTEGER,0,MPI_COMM_WORLD,ierror)
end do


if (my_rank==0) then
	call cpu_time(stop_time)
	write(*,*) "Executing time: ",  stop_time - start_time, "seconds"
	write(*,*) "Number of random numbers: ", i
	write(*,*) "Random numbers: ", a(1:i) 
endif


call MPI_FINALIZE(ierror)
end program random_parallel
