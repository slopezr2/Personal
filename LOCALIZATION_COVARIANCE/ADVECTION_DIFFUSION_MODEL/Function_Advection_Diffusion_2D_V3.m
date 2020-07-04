% Advection Diffusion code
%%  Clean
% clc;clear all;%close all

function [X]=Function_Advection_Diffusion_2D_V3(N,Tnum,X0,ii)
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
X=zeros(Xnum*Ynum,N);


%%  %Initialize concentrations in the C(x,t) matrix and plot measurements
C=zeros(Xnum,Ynum,Tnum+2);        

%% Boundary conditions



%% Iteration based on forward integration scheme

for en=1:N
%     pertur=-1+2*rand(1,4);
     pertur=2*rand(1,10);
%      pertur=ones(1,4);
    C(:,:,2)=vec2mat(squeeze(X0(:,en)),Ynum)';
    
      C(12,12,:)=C0*pertur(1,1);  
      C(10,14,:)=C0*pertur(1,2);
      C(13,9,:)=C0*pertur(1,3);
      C(11,8,:)=C0*pertur(1,4);
      C(2,4,:)=C0*pertur(1,5);
      C(1,16,:)=C0*pertur(1,6);
      C(4,11,:)=C0*pertur(1,7);
      C(8,3,:)=C0*pertur(1,8);
      C(18,9,:)=C0*pertur(1,9);
      C(15,18,:)=C0*pertur(1,10);

    for k=2:Tnum+1

      
    
    if ii<1600
        for i=2:Xnum-1
        for j=2:Ynum-1
            Lambday=Dy(i,j)*dt/((dy)^2);
            Gammay=Uy(i,j)*dt/dy;
            Lambdax=Dx(i,j)*dt/((dx)^2);
            Gammax=Ux(i,j)*dt/dx;
            C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i-1,j,k)-C(i,j,k))+...
                 Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j-1,k)-C(i,j,k));
        end
        end
    end

% if ii>=600 && ii<1200
%     for i=2:Xnum-1
%     for j=2:Ynum-1
%             Lambday=Dy(i,j)*dt/((dy)^2);
%             Gammay=Uy(i,j)*dt/dy;
%             Lambdax=Dx(i,j)*dt/((dx)^2);
%             Gammax=Ux(i,j)*dt/dx;
%         C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i+1,j,k)-C(i,j,k))+...
%              Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j-1,k)-C(i,j,k));
%     end
%     end
% end
% 
% if ii>=1200 
%     for i=2:Xnum-1
%     for j=2:Ynum-1
%             Lambday=Dy(i,j)*dt/((dy)^2);
%             Gammay=Uy(i,j)*dt/dy;
%             Lambdax=Dx(i,j)*dt/((dx)^2);
%             Gammax=Ux(i,j)*dt/dx;
%         C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i-1,j,k)-C(i,j,k))+...
%              Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j+1,k)-C(i,j,k));
%     end
%     end
% end

    aux=squeeze(C(:,:,k+1));
    aux2=aux(:);


    end
    X(:,en)=aux2;
    
end

