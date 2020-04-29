  subroutine Lorenz_96_One_Step(n,dt,x0,F,X)
    integer,intent(in)::n
    real*8,intent(in)::dt,F
    real*8,dimension(n),intent(in)::x0
    real*8,dimension(n),intent(out)::X
    real*8,dimension(n)::dx

    dx(1) = (x0(2)-x0(n-1))*x0(n)-x0(1)+F
    dx(2) = (x0(3)-x0(n))*x0(1)-x0(2)+F
    do i=3,n-1
      dx(i) = (x0(i+1)-x0(i-2))*x0(i-1)-x0(i)+F
    end do
    dx(n) = (x0(1)-x0(n-2))*x0(n-1)-x0(n)+F
    x=x0+dx*dt


  end subroutine Lorenz_96_One_Step
