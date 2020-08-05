close all
% clear all
Hist=0;
Matrix_Shapiro=1;
Nuevo=1;
guardar=1;

state_hist=31;

Tsim=51;
dt=0.01; %step length
F=8;
n=40;
N=900;

steps_evaluation=1:5:51;


if Nuevo==1
Xb(:,:,1)=6*randn(n,N);


    for i=1:Tsim-1
            %===== Forecast Step=====
            for en=1:N
                [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xb(:,en,i)),F);
            end
    end
end


if Matrix_Shapiro==1
    
Fig=figure;
set(gcf, 'Position', [300, 100, 700, 800])       
   for j=1:length(steps_evaluation)
       for i=1:n
            [H, pValue, W] = swtest(Xb(i,:,steps_evaluation(j)));
            Shapiro(i,j)=H;
        end
        
   end
   Shapiro(:,1)=0
   axes1 = axes('Parent',Fig,...
    'Position',[0.13 0.11 0.568521046643914 0.815]);
    hold(axes1,'on');

   imagesc(steps_evaluation,1:n,Shapiro), axis ij
   colormap([1 1 1; 0.3 0.3 0.3])
%    hold on
   g_y=[0.5:1:n+0.5]; % user defined grid Y [start:spaces:end]
   g_x=[-1.5:5:53.5]; % user defined grid X [start:spaces:end]
   for i=1:length(g_x)
       plot([g_x(i) g_x(i)],[g_y(1) g_y(end)],'k') %y grid lines
%        hold on    
   end
   for i=1:length(g_y)
       plot([g_x(1) g_x(end)],[g_y(i) g_y(i)],'k') %x grid lines
%        hold on    
   end
   
    
    xticks([1:5:51])
    xticklabels([0:5:51])
    yticks([1:3:n+1])
    set(gca,'FontSize',13)
    xlabel(['Time step'],'FontSize',15)
    ylabel(['Lorenz-96 component'],'FontSize',15)
    xlim([-1.5 53.5])
    ylim([0.5 n+0.5])
    
    % Create textbox
    annotation(Fig,'textbox',...
    [0.79 0.94 0.2 0.0549999987334013],...
    'String',{'Gaussian','Non-Gaussian'},...
    'HorizontalAlignment','right',...
    'FitBoxToText','off',...
    'BackgroundColor',[1 1 1]);

    % Create rectangle
    annotation(Fig,'rectangle',...
    [0.80 0.972 0.0410918367346937 0.0125],'LineWidth',1,...
    'FaceColor',[1 1 1]);

    % Create rectangle
    annotation(Fig,'rectangle',...
    [0.80 0.952 0.0410918367346937 0.0125],'LineWidth',1,...
    'FaceColor',[0.301960784313725 0.301960784313725 0.301960784313725]);

    ax = gca;
    outerpos = ax.OuterPosition;
    ti = ax.TightInset; 
    left = outerpos(1) + ti(1);
    bottom = outerpos(2) + ti(2);
    ax_width = outerpos(3) - ti(1) - ti(3);
    ax_height = outerpos(4) - ti(2) - ti(4);
    ax.Position = [left bottom ax_width ax_height];




    
    if guardar==1
       saveas(Fig,'Shapiro_Matrix.eps','epsc') 
    end
    porcentage_normality=sum(Shapiro)*100/n;
end









if Hist==1
    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,1)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;

    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,2)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;

    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,5)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;


    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,10)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;


    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,20)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;


    Fig=figure;
    h=histfit(squeeze(Xb(state_hist,:,49)),20,'kernel');
    h(1).FaceColor=[0.301960784313725 0.745098039215686 0.933333333333333];
    h(2).LineWidth=4;
end
