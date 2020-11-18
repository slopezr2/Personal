clear all
 close all
 clc

load T_advection.mat
load T_advection_r1.mat
load T_advection_rho.mat
load RHO_advection_r1.mat
load RHO_advection_r2.mat
load RHO_advection_r5.mat
load RHO_T_Schur_r1
load RHO_T_Schur_r2
load meanP0
Tsim=1000;
m=200;
n=20*20;
sigma=1e-3;
R=sigma^2*eye(m);
H = eye(n,n); 
H = H(randperm(n,m),:);
[Xreal]=Function_Advection_Diffusion_2D_Proof_covarince_V2(1,Tsim);
% Graff_H(H,20,20)
%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===

Y=H*Xreal;
%==Number of Ensembles==
N=50;
Xb=zeros(n,N,Tsim);
Xa=Xb;


aux=tic;
for i=1:Tsim-1
     %===== Forecast Step=====
     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
     meanxb=mean(Xb(:,:,i),2);
     L=(Xb(:,:,i)-meanxb)/sqrt(N);
     P0=((L*L'));
      A=sort(diag(P0));
     T=T_advection_rho.*A(end-3)/n;  
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
     varxa_EnKF_KA(:,i+1)=var(Xa(:,:,i+1),1,2);
end
t_EnKF_KA=toc(aux)
error_EnKF_KA=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))))


% % 
% figure
% imagesc(Xreal),title('Truth State')
% caxis([0 1.1])
% figure
% imagesc(meanxa_stoica),title('Analysis State EnKF_KA')
% caxis([0 1.1])
%  figure
% plot(0.5+alpha,'LineWidth',3),title(['\alpha Value for the EnKF-KA using N= ',num2str(N)])
% xlabel('Time [h]')
% 
%===Using Ledoid and Wolf===
N=50;
Xb=zeros(n,N,Tsim);
Xa=Xb;

aux=tic;
for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
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
    varxa_ledoid(:,i+1)=var(Xa(:,:,i+1),1,2);
end
% % figure
% % plot(meanxa_ledoid(6,:),'LineWidth',3)
% % hold on
% % plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using Shrinkage Ledoid and Wolf and all observations')
% % ylim([0 2.5])
t_ledoid=toc(aux)

error_Ledoid=norm(abs(sum(meanxa_ledoid(:,:)-Xreal(:,:))))
% % % figure
% % imagesc(meanxa_ledoid),title('Analysis State Ledoid')
% 
% % 
% % 
%====Scenario Background====
Xb=zeros(n,N,Tsim);
Xa=Xb;
for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
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
    varxa(:,i+1)=var(Xa(:,:,i+1),1,2);
end
% figure
% plot(meanxa(6,:),'LineWidth',3)
% hold on
% plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using only Y1 and Y2')
% ylim([0 2.5])
 error_Background=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))
% %  figure
% % imagesc(meanxa),title('Background State')
% % 
% % % %=====Scenario EnKF===
% % % %==Observations===
% % % Xb=zeros(n,N,Tsim);
% % % Xa=Xb;
% % % for i=1:Tsim-1
% % %     %===== Forecast Step=====
% % %     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
% % %     meanxb=mean(Xb(:,:,i),2);
% % %     L=Xb(:,:,i)-meanxb;
% % %     P0=((1/N-1)*(L*L'));
% % %     B=P0; 
% % %     %===== Analysis Step=====
% % %     K=B*H'*pinv(H*B*H'+R);
% % %     for en=1:N
% % %         Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
% % %     end
% % %     meanxa_EnKF(:,i+1)=mean(Xa(:,:,i+1),2);
% % % end
% % % 
% % %  error_EnKF=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))
% % % figure
% % % imagesc(meanxa),title('Analysis EnKF')
% % % caxis([0 1.1])
% % 
% % 
% % % 
% % %=====Scenario asimilating all observations===
% % %==Observations===
% 


N=20;
Xb=zeros(n,N,Tsim);
Xa=Xb;
aux=tic;
for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    B=RHO_T_Schur_r1.*P0; 
    %===== Analysis Step=====
    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa_Schur(:,i+1)=mean(Xa(:,:,i+1),2);
    varxa_Schur(:,i+1)=var(Xa(:,:,i+1),1,2);
end
t_Schur=toc(aux)

 error_Schur=norm(abs(sum(meanxa_Schur(:,:)-Xreal(:,:))))
 
 save varxa varxa
 save varxa_EnKF_KA varxa_EnKF_KA
 save varxa_ledoid varxa_ledoid
 save varxa_Schur varxa_Schur