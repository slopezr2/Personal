close all
load error_EnKF_KA.mat
load error_Ledoid.mat
load error_Schur.mat
cont=0;
for Nm=[1 3]
    Nm_opt=[12 25 50];
    for freq=[1 3]
        freq_opt=[1 5 10];
        for Nen=1:3
            Nen_opt=[10 50 100];
            fig=figure;
            cont=cont+1;
            KA_plot=plot([0;log10(movmean(squeeze((mean(error_EnKF_KA(Nm,freq,Nen,:,:),4))),100))],'LineWidth',3);
            hold on
            ledoid_plot=plot([0;log10(movmean(squeeze((mean(error_Ledoid(Nm,freq,Nen,:,:),4))),100))],'LineWidth',3);
            if (Nen==1 || Nen==2) && Nm==3  && freq==1
                shur_plot=plot([0; log10(movmean(squeeze((mean(error_Schur(Nm,freq,Nen,1:2,:),4))),100))],'LineWidth',3);
            else
                shur_plot=plot([0; log10(movmean(squeeze((mean(error_Schur(Nm,freq,Nen,:,:),4))),100))],'LineWidth',3);
            end
            hold on
            if cont==7
                legend([KA_plot,ledoid_plot,shur_plot],{'EnKF-KA','EnKF-RBLW','EnKF-CL'},'FontSize',12,'Position',[0.652976195372285 0.339682544152888 0.255357137961047 0.161904757434414])
            else
                legend([KA_plot,ledoid_plot,shur_plot],{'EnKF-KA','EnKF-RBLW','EnKF-CL'},'FontSize',12,'Position',[0.652976195372285 0.223015877486221 0.255357137961047 0.161904757434414])
            end
            ylabel('log(L_t)','FontSize',12)
            xlabel('Time step','FontSize',12)
            titulo=['N= ',num2str(Nen_opt(Nen)),', \delta','t= ',num2str(freq_opt(freq)),' h',', s= ',num2str(Nm_opt(Nm)/100)];
%             title(titulo)
            figmat=(['N_',num2str(Nen_opt(Nen)),'_Observed_',num2str(Nm_opt(Nm)),'_frequency_',num2str(freq_opt(freq))]);
           RMSE_KA(Nm,freq,Nen)=nanmean(sqrt(sum(error_EnKF_KA(Nm,freq,Nen,:,:).^2,5)/1500));
           RMSE_Ledoid(Nm,freq,Nen)=nanmean(sqrt(sum(error_Ledoid(Nm,freq,Nen,:,:).^2,5)/1500));
           RMSE_Schur(Nm,freq,Nen)=nanmean(sqrt(sum(error_Schur(Nm,freq,Nen,:,:).^2,5)/1500));
%             disp([titulo,' KA= ',num2str(RMSE_KA),' Ledoid= ',num2str(RMSE_Ledoid),' CL= ',num2str(RMSE_Schur)])
%               saveas(fig,figmat,'epsc')
        end
    end
end