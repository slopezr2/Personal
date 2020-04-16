clear all
 close all
clc
load ROH
load ROH_Santiago.mat
load P_Ensemble.mat
load P_Ensemble2.mat
Tsim=2500;
m=4;
n=20;
H=zeros(m,n);
H(1,8)=1;
H(2,7)=1;
H(3,5)=1;
H(4,4)=1;
sigma=1e-5;
R=sigma^2*eye(m);
[Xreal]=Function_Advection_Diffusion_2D_Proof_covarince(1,Tsim);

%=====Scenario asimilating all observations===
%==Observations===
Y1=Xreal(8,:);
Y2=Xreal(7,:);
Y3=Xreal(5,:);
Y4=Xreal(4,:);
Y=[Y1;Y2;Y3;Y4];
 alpha=0.3;
% alpha=0;
N=15;
Xb=zeros(n,N,Tsim);
Xa=Xb;



for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    T=ROH_Santiago.*trace(P0)*1e-5/n;
%     T=P_Ensemble;
    P=alpha*T+(1-alpha)*P0; 
    %===== Analysis Step=====

    K=P*H'*pinv(H*P*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxa(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using Shrinkage Estimator and all observations')
ylim([0 2.5])


%====Scenario Asimilating observations inside the valley====
Xb=zeros(n,N,Tsim);
Xa=Xb;
m=2;
H=zeros(m,n);
H(1,8)=1;
H(2,7)=1;
Y=[Y1;Y2];
R=sigma^2*eye(m);


for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P=((1/N-1)*(L*L'));
%     imagesc(P)
    %===== Analysis Step=====
    K=P*H'/(H*P*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxa(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using only Y1 and Y2')
ylim([0 2.5])


% for i=1:Tsim-1
%     %===== Forecast Step=====
%     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
%     meanxb=mean(Xb(:,:,i),2);
%     L=Xb(:,:,i)-meanxb;
%     P(:,:,i)=((1/N-1)*(L*L'));
% %     imagesc(P)
%     %===== Analysis Step=====
% %     K=P*H'/(H*P*H'+R);
% %     for en=1:N
% %         Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
% %     end
% %     meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
% Xa(:,:,i+1)=Xb(:,:,i+1);
% end
% 

% %====Scenario Assimilating observations outside the valley====
% Xb=zeros(n,N,Tsim);
% Xa=Xb;
% m=2;
% H=zeros(m,n);
% H(1,5)=1;
% H(2,4)=1;
% Y=[Y3;Y4];
% R=sigma^2*eye(m);
% 
% 
% for i=1:Tsim-1
%     %===== Forecast Step=====
%     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
%     meanxb=mean(Xb(:,:,i),2);
%     L=Xb(:,:,i)-meanxb;
%     P=((1/N-1)*(L*L'));
% %     imagesc(P)
%     %===== Analysis Step=====
%     K=P*H'/(H*P*H'+R);
%     for en=1:N
%         Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
%     end
%     meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
% end
% figure
% plot(meanxa(6,:),'LineWidth',3)
% hold on
% plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('using only Y3 and Y4')
