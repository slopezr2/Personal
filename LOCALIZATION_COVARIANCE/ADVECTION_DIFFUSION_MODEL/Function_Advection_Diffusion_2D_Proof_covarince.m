% Advection Diffusion code
%%  Clean
% clc;clear all;%close all

function [X]=Function_Advection_Diffusion_2D_Proof_covarince(N,Tnum)
%% ====Ensemble configuration====
% N=10;




%% ----------- Parameters ----------------
Xnum=20;                % number of gridpoints in x direction
Ynum=20;                % number of gridpoints in y direction
% Tnum=1000;              % number of time steps
Xlarge=1;               % large total in x
Ylarge=1;               % large total in y
dx=Xlarge/(Xnum-1);      % grid size x
dy=Ylarge/(Ynum-1);      % grid size y
dt=0.001;
Dx=1.0e-04*ones(Xnum,Ynum);  % Diffusivity coefficient in x
Dx_mountain=1e-4;
Dy_mountain=1e-4;
Dx(5:15,9)=Dx_mountain;
Dx(5:15,15)=Dx_mountain;
Dx(5,9:15)=Dx_mountain;
Dx(15,9:15)=Dx_mountain;
Dy=1.0e-04*ones(Xnum,Ynum);               % Diffusivity coefficient in y
Dy(5:15,9)=Dy_mountain;
Dy(5:15,15)=Dy_mountain;
Dy(5,9:15)=Dy_mountain;
Dy(15,9:15)=Dy_mountain;
Ux=1*ones(Xnum,Ynum);
Uy=1*ones(Xnum,Ynum);
Ux_mountain=1;
Uy_mountain=1;
Ux(:,5)=Ux_mountain;
Ux(:,15)=Ux_mountain;
Ux(9,:)=Ux_mountain;
Ux(15,:)=Ux_mountain;
Uy=1*ones(Xnum,Ynum);
Uy(:,5)=Uy_mountain;
Uy(:,15)=Uy_mountain;
Uy(9,:)=Uy_mountain;
Uy(15,:)=Uy_mountain;
C0=2;                   % Species initial concentration fixed
Cinf= 0;               % Species boundary concentration fixed
x=0:dx:Xlarge;           % vector of positions x
y=0:dy:Ylarge;           % vector of positions y

%% Calcule of parameters 
X=zeros(Xnum*Ynum,Tnum,N);


%%  %Initialize concentrations in the C(x,t) matrix and plot measurements
C=zeros(Xnum,Ynum,Tnum);        

%% Boundary conditions



%% Iteration based on forward integration scheme
for en=1:N
    pertur=randn(1,1);
    for k=2:Tnum

      C(1,12,:)=C0;  

    
        for i=1:Xnum
        for j=2:Ynum-1
            Lambday=Dy(i,j)*dt/((dy)^2);
            Gammay=Uy(i,j)*dt/dy;
            Lambdax=Dx(i,j)*dt/((dx)^2);
            Gammax=Ux(i,j)*dt/dx;
            C(i,j,k+1)=C(i,j,k)+ Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j+1,k)-C(i,j,k));
        end
        end
    aux=squeeze(C(:,:,k));
    aux2(:,k)=aux(:);


    end
    X(:,:,en)=aux2;
    
end

