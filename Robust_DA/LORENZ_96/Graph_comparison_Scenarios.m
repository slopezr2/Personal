close all
load error_EnKF_KA.mat
load error_Ledoid.mat
load error_Schur.mat

for Nm=[1 2]
    Nm_opt=[50 75];
    for freq=[1]
        freq_opt=[1];
        for Nen=1:2
            Nen_opt=[20 40];
            fig=figure;
            %if Nm==2 && Nen==1
            %subplot(2,2,3)    
           % else
            %subplot(2,2,Nm*Nen)
            %end
            a=squeeze((mean(error_Schur(Nm,freq,Nen,:,:),5)));
            [~,kk1]=max(a);
            plot([1.25;log10(movmean(squeeze((mean(error_Schur(Nm,freq,Nen,kk1,:),4))),100))],'Marker','.','LineWidth',2)
            hold on
            a=squeeze((mean(error_Ledoid(Nm,freq,Nen,:,:),5)));
            [~,kk2]=max(a);
            plot([1.25;log10(movmean(squeeze((mean(error_Ledoid(Nm,freq,Nen,kk2,:),4))),100))],'Marker','.','LineWidth',2)
            a=squeeze((mean(error_EnKF_KA(Nm,freq,Nen,:,:),5)));
            [~,kk3]=min(a);
            plot([1.25;log10(movmean(squeeze((mean(error_EnKF_KA(Nm,freq,Nen,kk3,:),4))),100))],'Marker','.','LineWidth',2)
            legend({'EnKF-Cl','EnKF-RBLW','EnKF-KA'},'FontSize',12)
            ylabel('log(L_t)','FontSize',15)
            xlabel('Time step','FontSize',15)
            titulo=['N= ',num2str(Nen_opt(Nen)),', \delta','t= ',num2str(freq_opt(freq)),' h',', s= ',num2str(Nm_opt(Nm)/100)];
%             title(titulo)
            figmat=(['N_',num2str(Nen_opt(Nen)),'_Observed_states_',num2str(Nm_opt(Nm)),'_Observation_',num2str(freq_opt(freq))]);
            RMSE_KA=mean(sqrt(sum(error_EnKF_KA(Nm,freq,Nen,kk3,:).^2,5)/1500));
            RMSE_Ledoid=mean(sqrt(sum(error_Ledoid(Nm,freq,Nen,:,:).^2,5)/1500));
            RMSE_Schur=mean(sqrt(sum(error_Schur(Nm,freq,Nen,:,:).^2,5)/1500));
            disp([titulo,' KA= ',num2str(RMSE_KA),' Ledoid= ',num2str(RMSE_Ledoid),' CL= ',num2str(RMSE_Schur)])
            saveas(fig,figmat,'epsc')
        end
    end
end