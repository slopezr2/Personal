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
F=8;
sigma=1e-3;
R=sigma^2*eye(m);
H = eye(n,n); 
H = H(randperm(n,m),:);
% [Xreal]=Lorenz_96_one_step_Proof_covarince_V2(1,Tsim);
x0=10*rand(n,1);
[Xreal]=Lorenz_96(Tsim,dt,x0,8);
% Graff_H(H,20,20)
%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===
frequency=10;
muestreo=frequency:frequency:Tsim;


Y=H*Xreal;
%==Number of Ensembles==
N=30;
PLC=0.9;

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
     T=T_r_1.*trace(P0)/n; 
%      T=meanP0;
     %T=T1.*trace(P0)/n; 
%      T=T_advection_rho.*P0; 
%      T=T_advection_rho.*meanP0;
     alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
     B=alpha(i)*T+(1-alpha(i))*P0; 
     %===== Analysis Step=====
     if sum(muestreo==i)
         K=B*H'*pinv(H*B*H'+R);
         for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
         end
     else
         Xa(:,:,i+1)=Xb(:,:,i+1);
     end
     meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
end
t_EnKF_KA=toc(aux)
error_EnKF_KA=norm(abs(sum(meanxa_EnKF_KA(:,:)-Xreal(:,:))))

 figure
 imagesc(Xreal),title('Truth State')
 figure
 imagesc(meanxa_EnKF_KA),title('Analysis State EnKF_KA')


%=====Scenario EnKF===
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
   if sum(muestreo==i)
         K=B*H'*pinv(H*B*H'+R);
         for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
         end
     else
         Xa(:,:,i+1)=Xb(:,:,i+1);
    end
    meanxa_EnKF(:,i+1)=mean(Xa(:,:,i+1),2);
end

error_EnKF=norm(abs(sum(meanxa_EnKF(:,:)-Xreal(:,:))))
figure
imagesc(meanxa_EnKF),title('Analysis EnKF')

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
    K=B*H'*pinv(H*B*H'+R);
    Pa=B-K*H*B;
    
%     while not(all(eig(inv(Pa)-sigma_i*eye(n)) > 1e-5))
%       sigma_i=sigma_i-0.01;
%       if sigma_i <0
%           sigma_i=0.01;
%           break
%       end
%     end
   
    if sum(muestreo==i)
          G=pinv(eye(n)-PLC*Pa*eye(n))*K;
         for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+G*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
         end
     else
         Xa(:,:,i+1)=Xb(:,:,i+1);
     end
    meanxa_EnTLHF(:,i+1)=mean(Xa(:,:,i+1),2);
end

error_EnTLHF=norm(abs(sum(meanxa_EnTLHF(:,:)-Xreal(:,:))))
figure
imagesc(meanxa_EnTLHF),title('Analysis EnTLHF')


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
    K=B*H'*pinv(H*B*H'+R);
    Pa=B-K*H*B;
    
%     while not(all(eig(inv(Pa)-sigma_i*eye(n)) > 1e-5))
%       sigma_i=sigma_i-0.01;
%       if sigma_i <0
%           sigma_i=0.01;
%           break
%       end
%     end
    if sum(muestreo==i)
          G=pinv(eye(n)-PLC*Pa*eye(n))*K;
         for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+G*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
         end
     else
         Xa(:,:,i+1)=Xb(:,:,i+1);
     end
    meanxa_EnTLHF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
end

error_EnTLHF_KA=norm(abs(sum(meanxa_EnTLHF_KA(:,:)-Xreal(:,:))))
figure
imagesc(meanxa_EnTLHF_KA),title('Analysis EnTLHF_KA')

