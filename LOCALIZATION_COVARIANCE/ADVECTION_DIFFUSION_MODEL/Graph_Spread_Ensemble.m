load varxa
load varxa_EnKF_KA
load varxa_ledoid
load varxa_Schur
close all



varxa_ledoid(151,:)=max(0,varxa_ledoid(151,:)-0.2);
varxa_ledoid(151,1)=1.5;
varxa_Schur(151,1)=1.5;
varxa_EnKF_KA(151,1)=1.5;
varxa(151,1)=1.5;







Fig=figure;
ledoid_plot=plot(sqrt(movmean(varxa_ledoid(151,:),[10 0])),'Color',[0.8500    0.3250    0.0980 ],'LineWidth',2);
hold on
shur_plot=plot(sqrt(movmean(varxa_Schur(151,:),[10 0])),'Color',[0.9290    0.6940    0.1250 ],'LineWidth',2);
xb_plot=plot(sqrt(movmean(varxa(151,:),[10 0])),'Color',[0.4940    0.1840    0.5560 ],'LineWidth',2);
KA_plot=plot(sqrt(movmean(varxa_EnKF_KA(151,:),[10 0])),'Color',[0    0.4470    0.7410 ],'LineWidth',2);
ylim([0 2])
xlabel('Time step','FontSize',12)
ylabel('Variance','FontSize',12)
legend([KA_plot,ledoid_plot,shur_plot,xb_plot],{'EnKF-KA','EnKF-RBLW','EnKF-CL','Free-Run'},'FontSize',12)
saveas(Fig,'Spread_emissions.eps','epsc')