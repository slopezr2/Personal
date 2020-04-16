program array_shift_parallel
implicit none
include '/usr/include/mpich-x86_64/mpif.h'
integer::i,N=16,sizeproce,aux
integer,allocatable,dimension(:)::a,b
!Parallel Variables
integer:: nproc,my_rank,ierror,tag=1000,count_mpi=0
integer status(MPI_STATUS_SIZE)
integer request_send,request_recv 

!Generate a
a=(/(i, i=1,N, 1)/)
allocate(b(N))
!Parallel Initialization
call MPI_INIT(ierror)
!Processes and rank information
call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,ierror)

if (my_rank==0) then
	write(*,*) "Vector", a(1:N) 
endif

!Validate if array size can be divided in the number of processors
if (mod(N,nproc)==0) then
	sizeproce=N/nproc
	if (my_rank==0) then
		call MPI_IRECV(aux,1,MPI_INT,nproc-1,MPI_ANY_TAG,MPI_COMM_WORLD,request_recv,ierror)
		call MPI_ISEND(a(sizeproce),1,MPI_INT,1,tag,MPI_COMM_WORLD,request_send,ierror)
		do i=sizeproce,2,-1
			a(i)=a(i-1)
		end do
		call MPI_WAIT(request_send,status,ierror)
		call MPI_WAIT(request_recv,status,ierror)
		a(1)=aux
		call MPI_GATHER(a(1:sizeproce),sizeproce,MPI_INT,b,sizeproce,MPI_INT,0,MPI_COMM_WORLD) 	
	elseif (my_rank>0 .and. my_rank<nproc-1)  then
        	call MPI_IRECV(aux,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,request_recv,ierror)
		call MPI_ISEND(a(sizeproce*(my_rank+1)),1,MPI_INT,my_rank+1,tag,MPI_COMM_WORLD,request_send,ierror)
		do i=sizeproce*(my_rank+1),sizeproce*my_rank +2,-1
			a(i)=a(i-1)
		end do
		call MPI_WAIT(request_recv,status,ierror)
		a(sizeproce*my_rank +1)=aux
		call MPI_WAIT(request_send,status,ierror)
		call MPI_GATHER(a(sizeproce*my_rank +1:sizeproce*(my_rank+1)),sizeproce,MPI_INT,b,sizeproce,MPI_INT,0,MPI_COMM_WORLD)     
	elseif (my_rank==nproc-1) then
                call MPI_IRECV(aux,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,request_recv,ierror)
		call MPI_ISEND(a(N),1,MPI_INT,0,tag,MPI_COMM_WORLD,request_send,ierror)
		do i=N,sizeproce*my_rank +2,-1
			a(i)=a(i-1)
		end do
		call MPI_WAIT(request_recv,status,ierror)
		a(sizeproce*my_rank +1)=aux
		call MPI_WAIT(request_send,status,ierror)
		call MPI_GATHER(a(sizeproce*my_rank +1:N),sizeproce,MPI_INT,b,sizeproce,MPI_INT,0,MPI_COMM_WORLD)  
	endif


endif





if (my_rank==0) then
	write(*,*) "Vector", b 
endif

end program array_shift_parallel
