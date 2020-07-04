program calculate_pi
implicit none
integer::i,steps=10000,M
real::x,y


do i=1,steps
       CALL RANDOM_NUMBER(x)
       CALL RANDOM_NUMBER(y)

        if (x*x + y*y < 1.0) then
            M=M+1
   	endif
end do




end program calculate_pi
