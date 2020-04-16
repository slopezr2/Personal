

clear all
close all
clc
load T_r_1
load meanP0
T1= meanP0 - min(meanP0(:));
T1 = T1 ./ max(T1(:));
Tsim=500;
dt=0.01; %step length
F=8;
Nexp=10; %Number of experiments for each scenario
for Nm=1:2
    m_opt=[20 30];    
    m=m_opt(Nm);
    n=40;
    sigma=1e-3;
    R=sigma^2*eye(m);
    for freq=1:1
        frequency_opt=[1];
        frequency=frequency_opt(freq); % Frequency of observations
        muestreo=frequency:frequency:Tsim;
        H = eye(n,n); 
        H = H(randperm(n,m),:);
        x0=10*rand(n,1);
        [Xreal]=Lorenz_96(Tsim,dt,x0,F);
        Y=H*Xreal;
        %==Number of Ensembles==
        for Nen=1:2
            N_opt=[40 100];    
            N=N_opt(Nen);

            %=====Scenario asimilating all observations and Using Shrinkage Stoica===
            %==Observations===
            Xb=zeros(n,N,Tsim);
            Xb(:,:,1)=10*rand(n,N);
            Xa=Xb;
            for exp=1:Nexp
                N_errores_EnKF_KA(Nm,freq,Nen,exp)=0;
                for i=1:Tsim-1
                     %===== Forecast Step=====
                     for en=1:N
                        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
                     end 
                     meanxb=mean(Xb(:,:,i),2);
                     if sum(muestreo==i)
                         L=(Xb(:,:,i)-meanxb)/sqrt(N);
                         P0=((L*L'));
                         T=T1.*trace(P0)/n;  
                         alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
                         B=alpha(i)*T+(1-alpha(i))*P0; 
                         %===== Analysis Step=====
                         try K=B*H'*pinv(H*B*H'+R);
                         catch
                             N_errores_EnKF_KA(Nm,freq,Nen,exp)=1;
                         end
                         for en=1:N
                            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
                         end

                         meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
                     else
                     Xa(:,:,i+1)=Xb(:,:,i+1);
                     meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);   
                     end
                     error_EnKF_KA(Nm,freq,Nen,exp,i)=norm(abs(sum(meanxa_EnKF_KA(:,i)-Xreal(:,i))));
                end
                       error_EnKF_KA_mean=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))));

                %===Using EnKF-LW  Ledoid and Wolf===
                N_errores_EnKF_LW(Nm,freq,Nen,exp)=0;
                Xb=zeros(n,N,Tsim);
                Xb(:,:,1)=10*rand(n,N);
                Xa=Xb;
                for i=1:Tsim-1
                    %===== Forecast Step=====
                    for en=1:N
                        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
                    end 
                    meanxb=mean(Xb(:,:,i),2);
                    if sum(muestreo==i)
                        L=(Xb(:,:,i)-meanxb)/sqrt(N);
                        P0=((L*L'));
                        [phi(i),dl(i)]=Alpha_CC_Ledoid_V1(L,N,n);
                        B=phi(i)*eye(n,n)+dl(i)*P0; 
                        %===== Analysis Step=====
                        try K=B*H'*pinv(H*B*H'+R);
                         catch
                             N_errores_EnKF_LW(Nm,freq,Nen,exp)=1;
                         end
                        for en=1:N
                            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
                        end
                    else
                      Xa(:,:,i+1)=Xb(:,:,i+1);  
                    end
                    meanxa_ledoid(:,i+1)=mean(Xa(:,:,i+1),2);
                    error_Ledoid(Nm,freq,Nen,exp,i)=norm(abs(sum(meanxa_ledoid(:,i)-Xreal(:,i))));

                end
                    error_EnKF_LW_mean=norm(abs(sum(meanxa_ledoid(:,:)-Xreal(:,:))));


%                 %====Scenario Background====
%                     Xb=zeros(n,N,Tsim);
%                     Xb(:,:,1)=1*rand(n,N);
%                     Xa=Xb;
%                 for i=1:Tsim-1
%                     %===== Forecast Step=====
%                     for en=1:N
%                       [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
%                     end 
%                     meanxb=mean(Xb(:,:,i),2);
%                     L=(Xb(:,:,i)-meanxb)/sqrt(N);
%                     P0=((L*L'));
%                     if i==1
%                         meanP0=P0;
%                      else
%                         P0_t(:,:,1)=meanP0;
%                         P0_t(:,:,2)=P0;
%                         meanP0=mean(P0_t,3); 
%                      end
%                     Xa(:,:,i+1)=Xb(:,:,i+1);
%                     meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
%                 end
% 
%                 error_Background=norm(abs(sum(meanxa(:,:)-Xreal(:,:))));

                % %=====Scenario asimilating all observations===
                % %==Observations===

                Xb=zeros(n,N,Tsim);
                Xb(:,:,1)=10*rand(n,N);
                Xa=Xb;
                N_errores_EnKF_Schur(Nm,freq,Nen,exp)=0;
                for i=1:Tsim-1
                    %===== Forecast Step=====
                    for en=1:N
                        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
                    end 
                    meanxb=mean(Xb(:,:,i),2);
                    if sum(muestreo==i)
                        L=Xb(:,:,i)-meanxb;
                        P0=((1/N-1)*(L*L'));
                        B=T_r_1.*P0; 
                        %===== Analysis Step=====
                        try K=B*H'*pinv(H*B*H'+R);
                         catch
                             N_errores_EnKF_Schur(Nm,freq,Nen,exp)=1;
                         end
                        for en=1:N
                            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
                        end
                    else
                         Xa(:,:,i+1)=Xb(:,:,i+1);  
                    end
                    meanxa_Schur(:,i+1)=mean(Xa(:,:,i+1),2);
                    error_Schur(Nm,freq,Nen,exp,i)=norm(abs(sum(meanxa_Schur(:,i)-Xreal(:,i))));
                end
                    error_Schur_mean=norm(abs(sum(meanxa_Schur(:,:)-Xreal(:,:))));

%                 figure
%                 plot(movmean(squeeze(error_Schur(Nm,freq,Nen,exp,:)),100),'LineWidth',2)
%                 hold on
%                 plot(movmean(squeeze(error_Ledoid(Nm,freq,Nen,exp,:)),100),'LineWidth',2)
%                 plot(movmean(squeeze(error_EnKF_KA(Nm,freq,Nen,exp,:)),100),'LineWidth',2),legend('EnKF Schur product','EnKF-LW','EnKF-KA')
                  experimento=['Obs: ',num2str(m),',Freq obs: ',num2str(frequency), ', N ens: ', num2str(N),' # Expe: ', num2str(exp),' RMSE EnKF-KA: ',num2str(error_EnKF_KA_mean),' RMSE EnKF-LW: ',num2str(error_EnKF_LW_mean),' RMSE EnKF-Schur: ',num2str(error_Schur_mean) ];
                  disp(experimento)
            end
        end
    end
    
    
end

save error_Schur error_Schur
save error_Ledoid error_Ledoid
save error_EnKF_KA error_EnKF_KA