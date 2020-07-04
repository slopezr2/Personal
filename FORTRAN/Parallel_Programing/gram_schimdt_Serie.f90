program gram_schimdt_serie
implicit none
include '/usr/include/mpich-x86_64/mpif.h'




integer::i,data,N = 10,j,k
real::t
real,allocatable,dimension(:,:)::a
real,allocatable,dimension(:)::c



allocate(a(N,N))
allocate(c(N))

write(*,*)"Initializing the matrix"


do j=1,N
	do i=1,N
      		a(i,j)=abs(i-j)
	end do
    write(*,*)a(i,:)
end do


do j=1,N
	do k=1,j
		c(k)=0.0
		do i=1,N
			c(k)=c(k) + a(i,k)*a(i,j)

		end do
    end do
    
    do k=1,j
		do i=1,N
			a(i,j)=a(i,j)-c(k)*a(i,k)
		end do
    end do 
    
    t=0.0

	do i=1,N
		t=t+a(i,j)*a(i,j)
	end do
	
	t=sqrt(t)

	if (t<=0.0) then
		write(*,*) "Error =: Singular matrix"
		exit
	endif
	
	t=1.0/t
	
	do i=1,N
		a(i,j)=a(i,j)*t
	end do

end do

write(*,*) "Done"

do i=1,N
	write(*,*) a(i,:)
end do


end program gram_schimdt_serie
