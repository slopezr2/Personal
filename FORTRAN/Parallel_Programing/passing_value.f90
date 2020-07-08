program passing_value
implicit none 
include '/usr/include/mpich-x86_64/mpif.h'

integer:: nproc,my_rank,ierror,value_send,value_receive,tag=1000,count_mpi=0
integer status(MPI_STATUS_SIZE) 

call MPI_INIT(ierror)

call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,ierror)


if (nproc>1) then
	if (my_rank==0 ) then
		value_send=8
		call MPI_SEND(value_send,1,MPI_INT,my_rank+1,tag,MPI_COMM_WORLD,ierror)
		call MPI_RECV(value_receive,1,MPI_INT,nproc-1,MPI_ANY_TAG,MPI_COMM_WORLD,status,ierror)
		call MPI_Get_count(status, MPI_INT, count_mpi, ierror)
	elseif (my_rank>0 .and. my_rank<nproc-1) then
		call MPI_RECV(value_receive,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,status,ierror)
		call MPI_SEND(value_receive,1,MPI_INT,my_rank+1,tag,MPI_COMM_WORLD,ierror)	
	elseif (my_rank==nproc-1) then
		call MPI_RECV(value_receive,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,status,ierror)
		call MPI_SEND(value_receive,1,MPI_INT,0,tag,MPI_COMM_WORLD,ierror)
	endif

elseif (nproc==1) then
	value_send=8
	value_receive=value_send
endif
if  (my_rank==0)then
	write(*,*) 'The total number of processors is ', nproc   
	write(*,*) 'The sended value was ', value_receive
	write(*,*) 'Total number of sended elements ',count_mpi
endif

call MPI_FINALIZE(ierror)

end program passing_value
