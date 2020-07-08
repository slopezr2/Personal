clear all
 close all
 clc

load T_r_1
load meanP0
T1= meanP0 - min(meanP0(:));
T1 = T1 ./ max(T1(:));
Tsim=500;
dt=0.01; %step length
m=20;
n=40;
F=8;
sigma=1e-3;
R=sigma^2*eye(m);
H = eye(n,n); 
H = H(randperm(n,m),:);
% [Xreal]=Lorenz_96_one_step_Proof_covarince_V2(1,Tsim);
x0=10*rand(n,1);
[Xreal]=Lorenz_96(Tsim,dt,x0,F);
% Graff_H(H,20,20)
%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===

Y=H*Xreal;
%==Number of Ensembles==
N=100;
Xb=zeros(n,N,Tsim);
Xb(:,:,1)=10*rand(n,N);
Xa=Xb;


aux=tic;
for i=1:Tsim-1
     %===== Forecast Step=====
     for en=1:N
        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
     end 
    meanxb=mean(Xb(:,:,i),2);
     L=(Xb(:,:,i)-meanxb)/sqrt(N);
     P0=((L*L'));
      A=sort(diag(P0));
%      T=T_r_1.*trace(P0)/n; 
%      T=meanP0;
     T=T1.*trace(P0)/n; 
%      T=T_advection_rho.*P0; 
%      T=T_advection_rho.*meanP0;
     alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
     B=alpha(i)*T+(1-alpha(i))*P0; 
     %===== Analysis Step=====
     K=B*H'*pinv(H*B*H'+R);
     for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
     end

     meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
end
t_EnKF_KA=toc(aux)
error_EnKF_KA=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))))

%  figure
%  imagesc(Xreal),title('Truth State')
% % caxis([0 1.1])
%  figure
%  imagesc(meanxa_EnKF_KA),title('Analysis State EnKF_KA')
% caxis([0 1.1])
%  figure
% plot(alpha,'LineWidth',3),title(['\alpha Value for the EnKF-KA using N= ',num2str(N)])
% xlabel('Time [h]')

%===Using Ledoid and Wolf===
aux=tic;
Xb=zeros(n,N,Tsim);
Xb(:,:,1)=10*rand(n,N);
Xa=Xb;
for i=1:Tsim-1
    %===== Forecast Step=====
    for en=1:N
        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
     end 
    meanxb=mean(Xb(:,:,i),2);
    L=(Xb(:,:,i)-meanxb)/sqrt(N);
    P0=((L*L'));
    [phi(i),dl(i)]=Alpha_CC_Ledoid_V1(L,N,n);
    B=phi(i)*eye(n,n)+dl(i)*P0; 
    %===== Analysis Step=====

    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa_ledoid(:,i+1)=mean(Xa(:,:,i+1),2);
end
% figure
% plot(meanxa_ledoid(6,:),'LineWidth',3)
% hold on
% plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using Shrinkage Ledoid and Wolf and all observations')
% ylim([0 2.5])
t_ledoid=toc(aux)

error_Ledoid=norm(abs(sum(meanxa_ledoid(:,:)-Xreal(:,:))))
% figure
% imagesc(meanxa_ledoid),title('Analysis State Ledoid')



%====Scenario Background====
Xb=zeros(n,N,Tsim);
Xb(:,:,1)=2*rand(n,N);
Xa=Xb;

for i=1:Tsim-1
    %===== Forecast Step=====
   for en=1:N
        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
     end 
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
% figure
% plot(meanxa(6,:),'LineWidth',3)
% hold on
% plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using only Y1 and Y2')
% ylim([0 2.5])
 error_Background=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))
%  figure
% imagesc(meanxa),title('Background State')

%=====Scenario EnKF===
%==Observations===
% Xb=zeros(n,N,Tsim);
% Xa=Xb;
% for i=1:Tsim-1
%     ===== Forecast Step=====
%     [Xb(:,:,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,:,i)),F);
%     meanxb=mean(Xb(:,:,i),2);
%     L=Xb(:,:,i)-meanxb;
%     P0=((1/N-1)*(L*L'));
%     B=P0; 
%     ===== Analysis Step=====
%     K=B*H'*pinv(H*B*H'+R);
%     for en=1:N
%         Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
%     end
%     meanxa_EnKF(:,i+1)=mean(Xa(:,:,i+1),2);
% end
% 
%  error_EnKF=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))
% figure
% imagesc(meanxa),title('Analysis EnKF')
% caxis([0 1.1])
% 
% 

%=====Scenario asimilating all observations===
%==Observations===

Xb=zeros(n,N,Tsim);
Xb(:,:,1)=10*rand(n,N);
Xa=Xb;
aux=tic;
for i=1:Tsim-1
    %===== Forecast Step=====
    for en=1:N
        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
     end 
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    B=T_r_1.*P0; 
    %===== Analysis Step=====
    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa_Schur(:,i+1)=mean(Xa(:,:,i+1),2);
end
t_Schur=toc(aux)

 error_Schur=norm(abs(sum(meanxa_Schur(:,:)-Xreal(:,:))))