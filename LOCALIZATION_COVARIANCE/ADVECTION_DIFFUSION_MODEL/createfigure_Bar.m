yvector1=[RMSE_KA(1,1,3);RMSE_Ledoid(1,1,3);RMSE_Schur(1,1,3)];
yvector2=[RMSE_KA(1,3,3);RMSE_Ledoid(1,3,3);RMSE_Schur(1,3,3)];
yvector3=[RMSE_KA(3,1,3);RMSE_Ledoid(3,1,3);RMSE_Schur(3,1,3)];
yvector4=[RMSE_KA(3,3,3);RMSE_Ledoid(3,3,3);RMSE_Schur(3,3,3)];
% yvector3(3,1)=18.234

Colores(1,:)=[ 0    0.4470    0.6410 ];
Colores(2,:)=[ 0.8500    0.3250    0.0980];
Colores(3,:)=[0.9290    0.6940    0.1250 ];
figure1 = figure;
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 0.7, 0.55]);
axes1 = axes('Parent',figure1,...
    'Position',[0.0765592972181552 0.149735099337748 0.156648936170213 0.8]);
hold(axes1,'on');

b=bar(yvector1,'Parent',axes1,...
    'FaceColor','flat');
for k=1:3
        b.CData(k,:)= Colores(k,:);
end
ylabel('Mean Fractional Bias PM_{10}','FontSize',18);

box(axes1,'on');

set(axes1,'XTick',[]);

axes2 = axes('Parent',figure1,...
    'Position',[0.282676318494754 0.149735099337748 0.156648936170213 0.8]);
hold(axes2,'on');


b=bar(yvector2,'Parent',axes2,...
    'FaceColor','flat');
for k=1:3
        b.CData(k,:)= Colores(k,:);
end
box(axes2,'on');
set(axes2,'XTick',[]);

hold on
b=bar(nan);

b.CData= Colores(1,:);
b=bar(nan);
b.CData= Colores(2,:);
b=bar(nan);
b.CData= Colores(3,:);
legend({'EnKF-KA','EnKF-RBLW','EnKF-CL'},'FontSize',12,'Position',[0.443611963501741 0.800705049507168 0.131788309362441 0.146638012025082])



axes3 = axes('Parent',figure1,...
    'Position',[0.598603003021718 0.149735099337748 0.156648936170213 0.8]);
hold(axes3,'on');

b=bar(yvector3,'Parent',axes3,...
    'FaceColor','flat');
for k=1:3
        b.CData(k,:)= Colores(k,:);
end
box(axes3,'on');
ylabel('Mean Fractional Bias PM_{10}','FontSize',18);
set(axes3,'XTick',[]);

axes4 = axes('Parent',figure1,...
    'Position',[0.804720024298309 0.149735099337748 0.156648936170213 0.8]);
hold(axes4,'on');


b=bar(yvector4,'Parent',axes4,...
    'FaceColor','flat');





for k=1:3
        b.CData(k,:)= Colores(k,:);
end
box(axes4,'on');
set(axes4,'XTick',[]);
hold on
b=bar(nan);

b.CData= Colores(1,:);
b=bar(nan);
b.CData= Colores(2,:);
b=bar(nan);
b.CData= Colores(3,:);
% legend({'EnKF-KA','EnKF-RBLW','EnKF-CL'},'FontSize',12,'Position',[0.865057253598771 0.5 0.132776227723479 0.130518230561332])

annotation(figure1,'textbox',...
    [0.635980966548665 0.0828827141631086 0.0834553418012874 0.0711920513518599],...
    'String',{'s=0.12'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.845717423193236 0.0843735295417318 0.072474375803509 0.0711920513518599],...
    'String',{'s=0.5'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');

annotation(figure1,'textbox',...
    [0.743594436359485 0.0134661548751045 0.0717423114036572 0.0711920513518599],...
    'String',{'\deltat=10'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');




annotation(figure1,'textbox',...
    [0.109626647368575 0.0834895284629495 0.0834553418012874 0.0711920513518599],...
    'String',{'s=0.12'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');

annotation(figure1,'textbox',...
    [0.326683748229837 0.0833247147024997 0.0724743758035091 0.0711920513518599],...
    'String',{'s=0.5'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');


annotation(figure1,'textbox',...
    [0.221998535756616 0.0152865977746277 0.0607613454058789 0.0711920513518599],...
    'String',{'\deltat=1'},...
    'HorizontalAlignment','center',...
    'FontSize',17,...
    'EdgeColor','none');

annotation(figure1,'line',[0.557833089311861 0.985358711566619],...
    [0.065 0.065],'LineWidth',2);

annotation(figure1,'line',[0.0424597364568082 0.469985358711567],...
    [0.065 0.065],'LineWidth',2);

