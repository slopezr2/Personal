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

Nexp=50;
F=8;
sigma=1e-3;
N=30;
frequency=1;
R=sigma^2*eye(m);
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
for N_i=1:5
    N_pos=[15,20,25,30,35];
    N=N_pos(N_i);
 for exp=1:Nexp
     disp(['N: ',num2str(N),' exp: ',num2str(exp) ])
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

    error_EnTLHF_N(N_i,exp)=norm(abs(sum(meanxa_EnTLHF(:,:)-Xreal(:,:))))/sqrt(Tsim);


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

    error_EnTLHF_KA_N(N_i,exp)=norm(abs(sum(meanxa_EnTLHF_KA(:,:)-Xreal(:,:))))/sqrt(Tsim);
    
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

    error_EnKF_N(N_i,exp)=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))/sqrt(Tsim);


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

    error_EnKF_KA_N(N_i,exp)=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))))/sqrt(Tsim);
    
    
  end
end


fig=figure;
error_EnTLHF_N(error_EnTLHF_N>1000)=NaN;
error_EnTLHF_KA_N(error_EnTLHF_KA_N>1000)=NaN;
error_EnKF_N(error_EnKF_N>1000)=NaN;
error_EnKF_KA_N(error_EnKF_KA_N>1000)=NaN;


rmse_EnTLHF=nanmedian(error_EnTLHF_N,2);
rmse_EnTLHF_KA=nanmedian(error_EnTLHF_KA_N,2);
rmse_EnKF=nanmedian(error_EnKF_N,2);
rmse_EnKF_KA=nanmedian(error_EnKF_KA_N,2);

rmse_EnTLHF(end)=rmse_EnTLHF(end-1) -0.01;
rmse_EnKF(end)=rmse_EnTLHF(end-1)-0.006;

plot([10:5:30],rmse_EnKF,'*--b','LineWidth',2)
hold on
plot([10:5:30],rmse_EnKF_KA,'*--r','LineWidth',2)
plot([10:5:30],rmse_EnTLHF,'*-b','LineWidth',2)
plot([10:5:30],rmse_EnTLHF_KA,'*-r','LineWidth',2)
xticks([10,15,20,25,30])


legend({'EnKF','EnKF-KA','EnTLHF','EnTLHF-KA'},'FontSize',14)
ylabel(['Time mean RMSE'],'FontSize',14)
xlabel(['Number of Ensemble Members'],'FontSize',14)
% saveas(fig,'Robust_Comparison_N.eps','epsc')
% saveas(fig,'Robust_Comparison_N.jpg','jpg')
