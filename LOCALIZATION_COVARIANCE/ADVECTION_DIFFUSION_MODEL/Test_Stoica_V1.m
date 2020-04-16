clear all
 close all
 clc
% load ROH
load RHO1.mat
load ROH_Santiago.mat
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

%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===
Y1=Xreal(8,:);
Y2=Xreal(7,:);
Y3=Xreal(5,:);
Y4=Xreal(4,:);
Y=[Y1;Y2;Y3;Y4];
N=3;
Xb=zeros(n,N,Tsim);
Xa=Xb;



for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    T=ROH_Santiago.*trace(P0)*1e-6/n;
    alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
    B=alpha(i)*T+(1-alpha(i))*P0; 
    %===== Analysis Step=====

    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxas(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxas(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using Shrinkage Stoica and all observations')
ylim([0 2.5])
error_Stoica=norm(abs(sum(meanxas(:,:)-Xreal(:,:))))
figure
 plot(alpha),title('\alpha using Stoica')
plot(Xreal(6,:)-meanxas(6,:)),title('Using Shrinkage Stoica and all observations')


%===Using Ledoid and Wolf===
for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    T=ROH_Santiago.*trace(P0)*1e-6/n;
    [phi(i),dl(i)]=Alpha_CC_Ledoid_V1(L,N,n);
    B=phi(i)*eye(n,n)+dl(i)*P0; 
    %===== Analysis Step=====

    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxa(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using Shrinkage Ledoid and Wolf and all observations')
ylim([0 2.5])
error_Ledoid=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))
figure
plot(Xreal(6,:)-meanxa(6,:)),title('Using Shrinkage Ledoid and Wolf and all observations')

% plot(alpha),title('\alpha using Ledoid and Wolf')


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
    B=((1/N-1)*(L*L'));
%     imagesc(P)
    %===== Analysis Step=====
    K=B*H'/(H*B*H'+R);
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
error_Valley=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))
%=====Scenario asimilating all observations===
%==Observations===
Y1=Xreal(8,:);
Y2=Xreal(7,:);
Y3=Xreal(5,:);
Y4=Xreal(4,:);
Y=[Y1;Y2;Y3;Y4];
m=4;
H=zeros(m,n);
H(1,8)=1;
H(2,7)=1;
H(3,5)=1;
H(4,4)=1;
R=sigma^2*eye(m);
Xb=zeros(n,N,Tsim);
Xa=Xb;

for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    B=P0; 
    %===== Analysis Step=====
    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxa(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using all observations')
ylim([0 2.5])
error_All=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))

%=====Scenario asimilating all observations===
%==Observations===
Y1=Xreal(8,:);
Y2=Xreal(7,:);
Y3=Xreal(5,:);
Y4=Xreal(4,:);
Y=[Y1;Y2;Y3;Y4];
m=4;
H=zeros(m,n);
H(1,8)=1;
H(2,7)=1;
H(3,5)=1;
H(4,4)=1;
R=sigma^2*eye(m);
Xb=zeros(n,N,Tsim);
Xa=Xb;

for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)));
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    B=RHO1.*P0; 
    %===== Analysis Step=====
    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa(:,i+1)=mean(Xa(:,:,i+1),2);
end
figure
plot(meanxa(6,:),'LineWidth',3)
hold on
plot(Xreal(6,:),'LineWidth',3),legend('Analysis State','True State'),title('Using all observations and Schur Product')
plot(Xreal(6,:)-meanxa(6,:)),title('Using all observations and Schur Product')
ylim([0 2.5])
error_Schur=norm(abs(sum(meanxa(:,:)-Xreal(:,:))))