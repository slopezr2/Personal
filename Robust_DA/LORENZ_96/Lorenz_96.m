function [x,t]=Lorenz_96(tsim,dt,x0,F)
n=length(x0);  %Number of states
dx=zeros(n,1);
t=zeros(1,tsim);
x=zeros(n,tsim);
x(:,1)=x0;
for k=2:tsim
    %===Model Dynamics===
    dx(1) = (x(2,k-1)-x(n-1,k-1))*x(n,k-1)-x(1,k-1)+F;
    dx(2) = (x(3,k-1)-x(n,k-1))*x(1,k-1)-x(2,k-1)+F;
    i = 3:n-1;
    f = F*ones(n,tsim);
    dx(i) = (x(i+1,k-1)-x(i-2,k-1)).*x(i-1,k-1)-x(i,k-1)+f(i,k-1);
    dx(n) = (x(1,k-1)-x(n-2,k-1))*x(n-1,k-1)-x(n,k-1)+F;
    %=== Numerical Integration (Euler)
    x(:,k)=x(:,k-1)+dx*dt;
    t(k)=t(k-1)+dt;
end

end