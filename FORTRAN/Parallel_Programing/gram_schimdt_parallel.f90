program gram_schimdt_parallel
implicit none
include '/usr/include/mpich-x86_64/mpif.h'

integer::i,data,N = 12,j,k,Np,aux_comm=1
real*4::t
real*4,allocatable,dimension(:,:)::a
real*4,allocatable,dimension(:)::c

!Parallel Variables
integer:: nproc,my_rank,ierror,tag=1000,count_mpi=0
integer status(MPI_STATUS_SIZE)
integer request_send,request_recv 

!Parallel Initialization
call MPI_INIT(ierror)

!Processes and rank information
call MPI_COMM_SIZE(MPI_COMM_WORLD,nproc,ierror)
call MPI_COMM_RANK(MPI_COMM_WORLD,my_rank,ierror)

Np=N/nproc
allocate(a(Np,N))
allocate(c(N))



	do j=1,N
		do i=1,Np!+(my_rank*Np),(Np*(my_rank+1))
	      		a(i,j)=abs(i +my_rank*Np -j)
		end do
	end do






do j=1,N !Columns
	do k=1,j 
		c(k)=0.0
		do i=1,Np
			c(k)=c(k) + a(i,k)*a(i,j)
		end do
    end do
 
    do k=1,j
		do i=1,Np
			a(i,j)=a(i,j)-c(k)*a(i,k)
		end do
    end do 
    
    t=0.0

	do i=1,Np
		t=t+a(i,j)*a(i,j)
	end do
	
	t=sqrt(t)

	if (t<=0.0) then
		write(*,*) "Error =: Singular matrix"
		exit
	endif
	
	t=1.0/t
	
	do i=1,Np
		a(i,j)=a(i,j)*t
	end do

end do




if (my_rank==0) then
	do i=1,Np
		write(*,*) a(i,:)
	end do
	!call MPI_SEND(aux_comm,1,MPI_INT,my_rank+1,tag,MPI_COMM_WORLD,ierror)
elseif (my_rank>0 .and. my_rank<nproc-1)  then
	!call MPI_RECV(aux_comm,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,status,ierror)
	do i=1,Np
		write(*,*) a(i,:)
	end do
    !call MPI_SEND(aux_comm,1,MPI_INT,my_rank+1,tag,MPI_COMM_WORLD,ierror)
elseif (my_rank==nproc-1) then
	!call MPI_RECV(aux_comm,1,MPI_INT,my_rank-1,MPI_ANY_TAG,MPI_COMM_WORLD,status,ierror)
	do i=1,Np
		write(*,*) a(i,:)
	end do
endif


deallocate(a)
deallocate(c)
call MPI_FINALIZE()

end program gram_schimdt_parallel
