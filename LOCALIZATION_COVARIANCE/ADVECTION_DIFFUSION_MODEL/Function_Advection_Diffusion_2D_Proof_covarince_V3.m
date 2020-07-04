% Advection Diffusion code
%%  Clean
% clc;clear all;%close all

function [X]=Function_Advection_Diffusion_2D_Proof_covarince_V3(N,Tnum)
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
Ux_mountain=8e-2;
Uy_mountain=8e-2;
Ux(9:15,5)=Ux_mountain;
Ux(9:15,15)=Ux_mountain;
Ux(9,5:15)=Ux_mountain;
Ux(15,5:15)=Ux_mountain;
Uy=1*ones(Xnum,Ynum);
Uy(9:15,5)=Uy_mountain;
Uy(9:15,15)=Uy_mountain;
Uy(9,5:15)=Uy_mountain;
Uy(15,5:15)=Uy_mountain;
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
%     pertur=1*rand(1,4);
    pertur=ones(1,10);
    for k=2:Tnum

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
    
    if k<1600
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

% if k>=600 && k<1200
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
% if k>=1200 
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
        
        
        
    aux=squeeze(C(:,:,k));
    aux2(:,k)=aux(:);


    end
    X(:,:,en)=aux2;
    
end



% %===Grafica===
% % for k=2:40:Tnum
% for k=842:842
% 
% hFig=figure(3);
%          
%        ax1= imagesc(C(:,:,k));
%        xlim([0 20])
%        ylim([0 20])
%         
%         
% colormap(hFig,flipud(hot))
%         
%         title(['Four factories emitting pollutants ',num2str(k)],'Interpreter','latex')
% %         hold on
% %         plot(5:15,9*ones(11),'g','LineWidth',2)
% %         plot(5:15,15*ones(11),'g','LineWidth',2)
% %         plot(5*ones(7),9:15,'g','LineWidth',2)
% %         plot(15*ones(7),9:15,'g','LineWidth',2)
%        hold on
%        plot(12,12,'k.','MarkerSize',13)
%        plot(14,10,'k.','MarkerSize',13)
%        plot(8,11,'k.','MarkerSize',13)
%        plot(9,13,'k.','MarkerSize',13)
%        
% Ux(:,5)=Ux_mountain;
% Ux(:,15)=Ux_mountain;
% Ux(9,:)=Ux_mountain;
% Ux(15,:)=Ux_mountain;
% 
% 
% %        plot(4,1,'k*','MarkerSize',13)
% %        plot(5,1,'k*','MarkerSize',13)
% % %        plot(7,1,'k*','MarkerSize',13)
% % %        plot(8,1,'k*','MarkerSize',13)
% 
% caxis([0 1.5*C0]);
% 
%        
%         colorbar
%         xlabel('X grid','Interpreter','latex')
%         ylabel('Y grid','Interpreter','latex')
%         hold on         
%        refreshdata(hFig)
% 
%      
% end
