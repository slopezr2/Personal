clear all
close all
clc

load T_r_1
load meanP0
T1= meanP0 - min(meanP0(:));
T1 = T1 ./ max(T1(:));
Tsim=500;
dt=0.01; %step length
m=40;
n=40;

Nexp=3;
F=8;
sigma=1e-3;
N=30;
frequency=1;

H = eye(n,n); 
H = H(randperm(n,m),:);
% [Xreal]=Lorenz_96_one_step_Proof_covarince_V2(1,Tsim);
x0=10*rand(n,1);
[Xreal]=Lorenz_96(Tsim,dt,x0,8);
% Graff_H(H,20,20)
%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===

muestreo=frequency:frequency:Tsim;


Y=H*Xreal;
%==Number of Ensembles==


PLC=0.3;
for F_i=1:5
    F_pos=[6,7,8,9,10];
    F=F_pos(F_i);
    
    R=sigma^2*eye(m);
 for exp=1:Nexp
     disp(['F: ',num2str(F),' exp: ',num2str(exp) ])
    %=====Scenario EnTLHF===
    %==Observations===
    Xb=zeros(n,N,Tsim);
    Xb(:,:,1)=10*rand(n,N);
    Xa=Xb;

    for i=1:Tsim-1
        %===== Forecast Step=====
        for en=1:N
            [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
        end
        meanxb=mean(Xb(:,:,i),2);
        L=Xb(:,:,i)-meanxb;
        P0=((1/N-1)*(L*L'));
        B=P0; 
        %===== Analysis Step=====
        try K=B*H'*pinv(H*B*H'+R);
        catch
        	continue
        end
        Pa=B-K*H*B;

        if sum(muestreo==i)
              try [U,S,V] = svd(Pa);
              catch
                continue
              end    
              eigen_value=S(1,1);
              lambda=PLC/eigen_value;
              if eigen_value==0
                 lambda=0; 
              end
              
              try G=pinv(eye(n)-lambda*Pa*eye(n))*K;
              catch
                continue
              end 
             for en=1:N
                Xa(:,en,i+1)=Xb(:,en,i+1)+G*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
             end
         else
             Xa(:,:,i+1)=Xb(:,:,i+1);
         end
        meanxa_EnTLHF(:,i+1)=mean(Xa(:,:,i+1),2);
    end

    error_EnTLHF_F(F_i,exp)=norm(abs(sum(meanxa_EnTLHF(:,:)-Xreal(:,:))))/sqrt(Tsim);


    %=====Scenario EnTLHF_KA===
    %==Observations===
    Xb=zeros(n,N,Tsim);
    Xb(:,:,1)=10*rand(n,N);
    Xa=Xb;
    for i=1:Tsim-1
        %===== Forecast Step=====
        for en=1:N
            [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
        end
        meanxb=mean(Xb(:,:,i),2);
        L=Xb(:,:,i)-meanxb;
        P0=((1/N-1)*(L*L'));
        A=sort(diag(P0));
        T=T_r_1.*trace(P0)/n; 
        alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
        B=alpha(i)*T+(1-alpha(i))*P0; 
        %===== Analysis Step=====
        try K=B*H'*pinv(H*B*H'+R);
        catch
        	continue
        end
        Pa=B-K*H*B;
        if sum(muestreo==i)
              try [U,S,V] = svd(Pa);
              catch
                continue
              end 
              eigen_value=S(1,1);
              lambda=PLC/eigen_value;
              try G=pinv(eye(n)-lambda*Pa*eye(n))*K;
              catch
                continue
              end
             for en=1:N
                Xa(:,en,i+1)=Xb(:,en,i+1)+G*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
             end
         else
             Xa(:,:,i+1)=Xb(:,:,i+1);
         end
        meanxa_EnTLHF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
    end

    error_EnTLHF_KA_F(F_i,exp)=norm(abs(sum(meanxa_EnTLHF_KA(:,:)-Xreal(:,:))))/sqrt(Tsim);
    
    %=====Scenario EnKFF===
    %==Observations===
    Xb=zeros(n,N,Tsim);
    Xb(:,:,1)=10*rand(n,N);
    Xa=Xb;

    for i=1:Tsim-1
        %===== Forecast Step=====
        for en=1:N
            [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
        end
        meanxb=mean(Xb(:,:,i),2);
        L=Xb(:,:,i)-meanxb;
        P0=((1/N-1)*(L*L'));
        B=P0; 
        %===== Analysis Step=====
        try K=B*H'*pinv(H*B*H'+R);
        catch
        	continue
        end
        
        if sum(muestreo==i)
              
             for en=1:N
                Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
             end
         else
             Xa(:,:,i+1)=Xb(:,:,i+1);
         end
        meanxa_EnKF(:,i+1)=mean(Xa(:,:,i+1),2);
    end

    error_EnKF_F(F_i,exp)=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))/sqrt(Tsim);


    %=====Scenario EnTLHF_KA===
    %==Observations===
    Xb=zeros(n,N,Tsim);
    Xb(:,:,1)=10*rand(n,N);
    Xa=Xb;
    for i=1:Tsim-1
        %===== Forecast Step=====
        for en=1:N
            [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
        end
        meanxb=mean(Xb(:,:,i),2);
        L=Xb(:,:,i)-meanxb;
        P0=((1/N-1)*(L*L'));
        A=sort(diag(P0));
        T=T_r_1.*trace(P0)/n; 
        alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
        B=alpha(i)*T+(1-alpha(i))*P0; 
        %===== Analysis Step=====
        try K=B*H'*pinv(H*B*H'+R);
        catch
        	continue
        end
        if sum(muestreo==i)
             for en=1:N
                Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
             end
         else
             Xa(:,:,i+1)=Xb(:,:,i+1);
         end
        meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
    end

    error_EnKF_KA_F(F_i,exp)=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))))/sqrt(Tsim);
    
    
  end
end


fig=figure;
error_EnTLHF_F(error_EnTLHF_F>1000)=NaN;
error_EnTLHF_KA_F(error_EnTLHF_KA_F>1000)=NaN;
error_EnKF_F(error_EnKF_F>1000)=NaN;
error_EnKF_KA_F(error_EnKF_KA_F>1000)=NaN;


rmse_EnTLHF=nanmedian(error_EnTLHF_F,2);
rmse_EnTLHF_KA=nanmedian(error_EnTLHF_KA_F,2);
rmse_EnKF=nanmedian(error_EnKF_F,2);
rmse_EnKF_KA=nanmedian(error_EnKF_KA_F,2);


plot(6:1:10,rmse_EnKF,'*--b','LineWidth',2)
hold on
plot(6:1:10,rmse_EnKF_KA,'*--r','LineWidth',2)
plot(6:1:10,rmse_EnTLHF,'*-b','LineWidth',2)
plot(6:1:10,rmse_EnTLHF_KA,'*-r','LineWidth',2)



legend({'EnKF','EnKF-KA','EnTLHF','EnTLHF-KA'},'FontSize',14,'Position',[0.142690063812579 0.675141249576627 0.268421047298532 0.23607747520142])
ylabel(['Time mean RMSE'],'FontSize',14)
xlabel(['External Forcing Value'],'FontSize',14)
% ylim([7.8 9])
xticks(6:1:10)
% xticklabels({'1e-4','1e-3','1e-2','1e-1'})
saveas(fig,'Robust_Comparison_F.eps','epsc')


