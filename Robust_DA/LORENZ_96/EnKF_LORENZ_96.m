clear all
close all
clc

Tsim=500;
dt=0.01; %step length
m=40;
n=40;
F=8;
sigma=1e-2;
R=sigma^2*eye(m);
H = eye(n,n); 
H = H(randperm(n,m),:);
%===Generate real state===
x0=2*randn(n,1);
[Xreal]=Lorenz_96(Tsim,dt,x0,F);


%==Number of Ensembles==
N=100;
Xb=zeros(n,N,Tsim);
Xb(:,:,1)=2*randn(n,N);
Xa=Xb;

%=====Scenario EnKF===
%==Observations===
Y=H*Xreal;
for i=1:Tsim-1
    %===== Forecast Step=====
    for en=1:N
        [Xb(:,en,i+1)]=Lorenz_96_one_step(1,dt,squeeze(Xa(:,en,i)),F);
     end 
    meanxb=mean(Xb(:,:,i),2);
    L=Xb(:,:,i)-meanxb;
    P0=((1/N-1)*(L*L'));
    B=P0; 
   % ===== Analysis Step=====
    K=B*H'*pinv(H*B*H'+R);
    for en=1:N
        Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
    end
    meanxa_EnKF(:,i+1)=mean(Xa(:,:,i+1),2);
end

error_EnKF=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))
 figure
 imagesc(Xreal),title('Truth State')
 figure
 imagesc(meanxa_EnKF),title('Analysis State EnKF')
figure
subplot(1,4,1)
plot(Xreal(10,:),'r','LineWidth',2)
hold on
plot(meanxa_EnKF(10,:),'b','LineWidth',2)
legend({'X truth','Xa'})
title('State 10')
subplot(1,4,2)
plot(Xreal(20,:),'r','LineWidth',2)
hold on
plot(meanxa_EnKF(20,:),'b','LineWidth',2)
title('State 20')
subplot(1,4,3)
plot(Xreal(30,:),'r','LineWidth',2)
hold on
plot(meanxa_EnKF(30,:),'b','LineWidth',2)
title('State 30')
subplot(1,4,4)
plot(Xreal(40,:),'r','LineWidth',2)
hold on
plot(meanxa_EnKF(40,:),'b','LineWidth',2)
title('State 40')

