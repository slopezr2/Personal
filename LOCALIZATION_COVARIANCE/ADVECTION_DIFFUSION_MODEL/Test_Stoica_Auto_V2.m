

clear all
close all
clc
load T_advection_rho.mat
load RHO_T_Schur_r1
Tsim=1500;
Nexp=1; %Number of experiments for each scenario
for Nm=1:3
    m_opt=[50 100 200];    
    m=m_opt(Nm);
    n=20*20;
    sigma=1e-3;
    R=sigma^2*eye(m);
    for freq=1:3
        frequency_opt=[1 5 10];
        frequency=frequency_opt(freq); % Frequency of observations
        muestreo=frequency:frequency:Tsim;



        H = eye(n,n); 
        H = H(randperm(n,m),:);
        [Xreal]=Function_Advection_Diffusion_2D_Proof_covarince_V3(1,Tsim);

        Y=H*Xreal;
        %==Number of Ensembles==
        for Nen=1:3
            N_opt=[10 50 100];    
            N=N_opt(Nen);

            %=====Scenario asimilating all observations and Using Shrinkage Stoica===
            %==Observations===
            Xb=zeros(n,N,Tsim);
            Xa=Xb;
            for exp=1:Nexp
                N_errores_EnKF_KA(Nm,freq,Nen,exp)=0;
                for i=1:Tsim-1
                     %===== Forecast Step=====
                     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D_V3(N,1,squeeze(Xa(:,:,i)),i);
                     meanxb=mean(Xb(:,:,i),2);
                     if sum(muestreo==i)
                         L=(Xb(:,:,i)-meanxb)/sqrt(N);
                         P0=((L*L'));
                          A=sort(diag(P0));
                         T=T_advection_rho.*A(end-3)/n;  
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
                for i=1:Tsim-1
                    %===== Forecast Step=====
                    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D_V3(N,1,squeeze(Xa(:,:,i)),i);
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


                %====Scenario Background====
                Xb=zeros(n,N,Tsim);
                Xa=Xb;
                for i=1:Tsim-1
                    %===== Forecast Step=====
                    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D_V3(N,1,squeeze(Xa(:,:,i)),i);
                    meanxb=mean(Xb(:,:,i),2);
                    L=(Xb(:,:,i)-meanxb)/sqrt(N);
                    P0=((L*L'));
                    if i==1
                        meanP0=P0;
                     else
                        P0_t(:,:,1)=meanP0;
                        P0_t(:,:,2)=P0;
                        meanP0=mean(P0_t,3); 
                     end
                    Xa(:,:,i+1)=Xb(:,:,i+1);
                    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
                end

                error_Background=norm(abs(sum(meanxa(:,:)-Xreal(:,:))));

                % %=====Scenario asimilating all observations===
                % %==Observations===

                Xb=zeros(n,N,Tsim);
                Xa=Xb;
                N_errores_EnKF_Schur(Nm,freq,Nen,exp)=0;
                for i=1:Tsim-1
                    %===== Forecast Step=====
                    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D_V3(N,1,squeeze(Xa(:,:,i)),i);
                    meanxb=mean(Xb(:,:,i),2);
                    if sum(muestreo==i)
                        L=Xb(:,:,i)-meanxb;
                        P0=((1/N-1)*(L*L'));
                        B=RHO_T_Schur_r1.*P0; 
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