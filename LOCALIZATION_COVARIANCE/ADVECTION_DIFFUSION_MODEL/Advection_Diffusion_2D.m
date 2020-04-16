% Advection Diffusion code
%%  Clean
clc;clear all;close all
%% ----------- Parameters ----------------
Xnum=60;                % number of gridpoints in x direction
Ynum=60;                % number of gridpoints in y direction
Tnum=1800;              % number of time steps
Xlarge=1;               % large total in x
Ylarge=1;               % large total in y
dx=Xlarge/(Xnum-1);      % grid size x
dy=Ylarge/(Ynum-1);      % grid size y
dt=0.001;
Dx=1.0e-04;               % Diffusivity coefficient in x
Dy=1.0e-04;               % Diffusivity coefficient in y
Ux=1;
Uy=1;
C0=1;                   % Species initial concentration fixed
Cinf= 0;               % Species boundary concentration fixed
x=0:dx:Xlarge;           % vector of positions x
y=0:dy:Ylarge;           % vector of positions y

%% Calcule of parameters 

Lambdax=Dx*dt/((dx)^2);
Gammax=Ux*dt/dx;

Lambday=Dy*dt/((dy)^2);
Gammay=Uy*dt/dy;

%%  %Initialize concentrations in the C(x,t) matrix and plot measurements
C=zeros(Xnum,Ynum,Tnum);        
% %% Plot measurenments
% % vectors of the measures, each 3 hours there is data
M1 =[0.000, 0.000, 0.000, 0.2300, 2.859, 1.107, 0.094, 0.002, 0.000,...
0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.8950, 6.900,...
10.34, 7.852, 10.10, 114.10, 6.175, 2.558, 1.855, 0.606];
M2 =[0.000, 0.000, 0.000, 0.3630, 4.034, 1.816, 0.1440, 2.713, 16.88,...
12.81, 8.277, 4.715, 1.370, 0.758, 0.256, 0.051, 0.001,...
0.032, 0.139, 4.182, 13.14, 7.368, 6.492, 12.50, 22.20];
M3 =[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 2.385, 13.09,...
11.31, 7.940, 6.828, 12.45, 8.551, 4.404, 4.254, 3.290,...
2.898, 1.411, 0.459, 0.146, 0.335, 1.211, 7.282, 17.41];
M4 =[0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000, 0.000,...
0.000, 0.000, 1.646, 7.420, 3.631, 2.132, 2.822, 7.675,...
12.36, 8.249, 5.844, 4.239, 1.859, 0.387, 0.130, 0.053];
Measu=[M1; M2; M3; M4];
%-------------------------------------------------------------------------
%-------------Uncomment this part for the measurement 2D plot and gif creation
% h=figure(1)
% axis tight manual % this ensures that getframe() returns a consistent size
% filename = '4_Factories_measurenments.gif';
% set(h,'PaperPositionMode','auto');
% set(h,'Position',[130 50 1100 640]);
% set(h,'color','w')
% set(0,'defaultTextInterpreter','latex');
% B=plot(10,30,'o','Color','g','MarkerSize',12);hold on;
% plot(30,10,'o','Color','g','MarkerSize',12);hold on;
% plot(50,30,'o','Color','g','MarkerSize',12);hold on;
% plot(30,50,'o','Color','g','MarkerSize',12);hold on;
% caxis([0 15]);colormap(flipud(hot));colorbar;
% A=plot(20,40,'o','MarkerEdgeColor','k','MarkerFaceColor',[0, 0, 1]);hold on;
% plot(40,40,'o','MarkerEdgeColor','k','MarkerFaceColor',[0, 0, 1]);hold on;
% plot(40,20,'o','MarkerEdgeColor','k','MarkerFaceColor',[0, 0, 1]);hold on;
% plot(20,20,'o','MarkerEdgeColor','k','MarkerFaceColor',[0, 0, 1]);hold on;
% text(20,18,'E_1','Color','cyan');
% text(20,36,'E_2','Color','magenta');
% text(40,36,'E_3','Color','red');
% text(40,18,'E_4','Color','green'); 
% text(30,48,'M_1','Color','black');
% text(50,28,'M_2','Color','black');
% text(30,8,'M_3','Color','black');
% text(10,28,'M_4','Color','black'); 
% 
% for i=1:24
%   set(h,'color','w');% grid on:
%   xlabel('X','Interpreter','latex');ylabel('Y','Interpreter','latex');
%   title(sprintf('Emission estimation experiment hour=%i',i*3),'Interpreter','latex');
%   ylim([0 60]);
%   xlim([0 60]);
%   xx=[30 50 30 10]; yy=[50 30 10 30];
%   sz=120;
%   hold on;
%   scatter(xx,yy,sz,Measu(:,i),'filled')
%   leg=legend([A B],{'Factory sources','Sensors'},'Interpreter','latex');
%   drawnow
%   pause(0.5)
%   hold on
%   frame = getframe(h); 
%   im = frame2im(frame); 
%   [imind,cm] = rgb2ind(im,256); 
% 
%   % Write to the GIF File 
%       if i == 1 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
% end
%%-----------------------------------------------------------------------------
%%% This other section is for generate measurenment time series and gif
% ll=figure(2);
% set(ll,'color','w');
% axis tight manual % this ensures that getframe() returns a consistent size
% filename = '4_Time_measurenments.gif';
% set(ll,'PaperPositionMode','auto');
% set(ll,'Position',[130 50 1100 640]);
% set(0,'defaultTextInterpreter','latex');
% 
% for j=1:24
%    
%     ax1=subplot(2,2,1);
%     %p1=plot(Measu(1,j),'*')
%     p1=plot(j*3,Measu(1,j),'o','MarkerSize',5,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
%     grid(ax1,'on');
%     title('Measure point 1','Interpreter','latex')
%     xlabel('Time (time step 3 hours)','Interpreter','latex')
%     ylabel('$\mu$ g km$^{-2}$','Interpreter','latex')
%     xlim([0 75]); ylim([0 15]);
%     hold on
%     ax2=subplot(2,2,2);
%     p2=plot(j*3,Measu(2,j),'o','MarkerSize',5,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
% 
%     grid(ax2,'on');hold on;
%     title('Measure point 2','Interpreter','latex')
%     xlabel('Time (time step 3 hours)','Interpreter','latex')
%     ylabel('$\mu$ g km$^{-2}$','Interpreter','latex');
%     xlim([0 75]);ylim([0 15]);hold on;
%     ax3=subplot(2,2,3);
%     p3=plot(j*3,Measu(3,j),'o','MarkerSize',5,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
% 
%     grid(ax3,'on');
%     title('Measure point 3','Interpreter','latex')
%     xlabel('Time (time step 3 hours)','Interpreter','latex')
%     ylabel('$\mu$ g km$^{-2}$','Interpreter','latex');
%     xlim([0 75]);ylim([0 15]);hold on;
%     ax4=subplot(2,2,4)
%     p4=plot(j*3,Measu(4,j),'o','MarkerSize',5,'MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
%      
%     grid(ax4,'on')
%     title('Measure point 4','Interpreter','latex')
%     xlabel('Time (time step 3 hours)','Interpreter','latex')
%     ylabel('$\mu$ g km$^{-2}$','Interpreter','latex');
%     xlim([0 75]);ylim([0 15]);pause(0.5);hold on;
% 
%     
%     frame = getframe(ll); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
%     % Write to the GIF File 
%     if j == 1 
%          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%     else 
%          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%     end 
% end
%% Boundary conditions

for j=1:Tnum

    C(1,:,j)=0;
    C(:,1,j)=0;
    C(end,:,j)=0;
    C(:,end,j)=0;
    
end

%% Iteration based on forward integration scheme

for k=2:1800
  C(20,20,:)=C0-0.5*sin(k*0.01);   % Four factories source concentration
  C(40,20,:)=C0;  
  C(40,40,:)=C0+0.3*cos(k*0.01);  
  C(20,40,:)=0.7*C0;  
  
if k<600
    for i=2:Xnum-1
    for j=2:Ynum-1
        C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i-1,j,k)-C(i,j,k))+...
             Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j-1,k)-C(i,j,k));
    end
    end
end

if k>=600 && k<1200
    for i=2:Xnum-1
    for j=2:Ynum-1
        C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i+1,j,k)-C(i,j,k))+...
             Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j-1,k)-C(i,j,k));
    end
    end
end

if k>=1200 && k<=1800
    for i=2:Xnum-1
    for j=2:Ynum-1
        C(i,j,k+1)=C(i,j,k)+Lambdax*(C(i+1,j,k)+C(i,j,k)+C(i-1,j,k))+Gammax*(C(i-1,j,k)-C(i,j,k))+...
             Lambday*(C(i,j+1,k)+C(i,j,k)+C(i,j-1,k))+Gammay*(C(i,j+1,k)-C(i,j,k));
    end
    end
end

end


%%  Use this for plot and generate .gif


h = figure(3);
axis tight manual % this ensures that getframe() returns a consistent size
filename = '4_Factories.gif';
set(h,'PaperPositionMode','auto');
set(h,'Position',[130 50 1100 640]);
set(h,'color','w');

subplot(2,1,1)
ax=subplot(2,1,2)
line([600 600],[0 1],'LineWidth',0.1,'LineStyle','--','color','k')
line([1200 1200],[0 1],'LineWidth',0.1,'LineStyle','--','color','k')
line([1800 1800],[0 1],'LineWidth',0.1,'LineStyle','--','color','k')
h1=text(585,0.46,'Change Wind direction','Color',[0.5 0.5 0.5],'FontSize',8);
set(h1,'Rotation',90)
h2=text(1185,0.46,'Change Wind direction','Color',[0.5 0.5 0.5],'FontSize',8);
set(h2,'Rotation',90)
h3=text(1785,0.46,'Change Wind direction','Color',[0.5 0.5 0.5],'FontSize',8);
set(h3,'Rotation',90)
text(1850,0.6,'E_1','Color','cyan')
text(1850,0.8,'E_2','Color','magenta')
text(1850,0.4,'E_3','Color','red')
text(1850,0.2,'E_4','Color','green')
xlim([0,2000]);
ylim([0,1.2]);

box(ax,'on')
hold on

curve1=animatedline('Color','cyan','LineStyle','-');
curve2=animatedline('Color','magenta','LineStyle','-');
curve3=animatedline('Color','red','LineStyle','-');
curve4=animatedline('Color','green','LineStyle','-');

for k=2:20:1800
   C(20,20,:)=C0+0.5*sin(k*0.01);  
   C(40,20,:)=C0;  
   C(40,40,:)=C0+0.3*cos(k*0.01);  
   C(20,40,:)=1/2*C0;  
  
ax1=subplot(2,1,1);
hFig=figure(3);
         
        imagesc(C(:,:,k));
%         contourf(C(:,:,k))   % 
        
        
colormap(ax1,flipud(hot))
        
        title('Four factories emitting pollutants ','Interpreter','latex')
        text(20,16,'E_1','Color','cyan');
        plot(20,20,'o','Color','black','MarkerSize',2,'MarkerFaceColor','cyan');
        text(20,34,'E_2','Color','magenta');
        plot(20,40,'o','Color','black','MarkerSize',2,'MarkerFaceColor','magenta');
        text(40,34,'E_3','Color','red');
        plot(40,40,'o','Color','black','MarkerSize',2,'MarkerFaceColor','red');
        text(40,16,'E_4','Color','green');  
        plot(40,20,'o','Color','black','MarkerSize',2,'MarkerFaceColor','green');
        
        
%plot(C(:,k))
caxis([0 1.0]);

        %colormap(flipud(jet))
%         colormap(jet)
        colorbar
        xlabel('X grid','Interpreter','latex')
        ylabel('Y grid','Interpreter','latex')
        hold on
        subplot(2,1,2)
        %plot(k,C0-0.5*sin(k*0.01),'-o','MarkerSize',1,'MarkerEdgeColor','cyan','MarkerFaceColor','cyan')
        addpoints(curve1,k,C0-0.5*sin(k*0.01));
        %plot(k,C0,'-o','MarkerSize',1,'MarkerEdgeColor','magenta','MarkerFaceColor','magenta')
        addpoints(curve2,k,C0);
        %plot(k,C0+0.3*sin(k*0.01),'-o','MarkerSize',1,'MarkerEdgeColor','red','MarkerFaceColor','red')
        addpoints(curve3,k,C0+0.3*sin(k*0.01));
        %plot(k,1/2*C0,'-o','MarkerSize',1,'MarkerEdgeColor','green','MarkerFaceColor','green')
        addpoints(curve4,k,0.7*C0);
        drawnow;
        title('Source concentrations in time','Interpreter','latex');
        ylim([0,2]);
        xlim([0,2000]);
        xlabel('Time','Interpreter','latex');
        ylabel('Concentration','Interpreter','latex');
        
               
        hold on
       refreshdata(hFig)
%       frame = getframe(hFig); 
%       im = frame2im(frame); 
%       [imind,cm] = rgb2ind(im,256); 
      % Write to the GIF File 
%       if k-1 == 1 
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
%       else 
%           imwrite(imind,cm,filename,'gif','WriteMode','append'); 
%       end 
     
end
