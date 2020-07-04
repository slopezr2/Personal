% Advection Diffusion code
%%  Clean
clc;clear all;%close all


%% ====Ensemble configuration====
N=10;




%% ----------- Parameters ----------------
Xnum=1;                % number of gridpoints in x direction
Ynum=20;                % number of gridpoints in y direction
Tnum=1000;              % number of time steps
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

for j=1:Tnum

   
%     C(:,1,j)=0;
%     C(:,end,j)=0;
    
end

%% Iteration based on forward integration scheme
for en=1:N
    disp([num2str((en/N)*100) '%'])
    pertur=randn(1,1);
    for k=2:Tnum

      C(1,12,:)=C0;  

    
        for i=1:Xnum
        for j=2:Ynum-1
             Lambday=Dy(i,j)*dt/((dy)^2);
            Gammay=Uy(i,j)*dt/dy;
            C(i,j,k+1)=C(i,j,k)+ Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j+1,k)-C(i,j,k));
        end
        end
    aux=squeeze(C(:,:,k));
    aux2(:,k)=aux(:);


    end
    X(:,:,en)=aux2;
    
end

%%  Use this for plot and generate .gif


h = figure(3);
axis tight manual % this ensures that getframe() returns a consistent size
filename = '4_Factories.gif';
set(h,'PaperPositionMode','auto');
set(h,'Position',[130 50 1100 640]);
set(h,'color','w');

for k=2:20:Tnum


hFig=figure(3);
         
       ax1= imagesc(C(:,:,k));
       xlim([0 20])
       ylim([0 2])
        
        
colormap(hFig,flipud(hot))
        
        title(['Four factories emitting pollutants ',num2str(k)],'Interpreter','latex')
        hold on
        plot(5*ones(1,10),0:9,'g','LineWidth',2)
       hold on
       plot(6,1,'b.','MarkerSize',13)
       plot(4,1,'k*','MarkerSize',13)
       plot(5,1,'k*','MarkerSize',13)
       plot(7,1,'k*','MarkerSize',13)
       plot(8,1,'k*','MarkerSize',13)
       text(3.9,1.1,'Y4')
       text(4.8,1.1,'Y3')
       text(6.8,1.1,'Y2')
       text(7.8,1.1,'Y1')
caxis([0 1.5*C0]);

       
        colorbar
        xlabel('X grid','Interpreter','latex')
        ylabel('Y grid','Interpreter','latex')
        hold on         
       refreshdata(hFig)

     
end
