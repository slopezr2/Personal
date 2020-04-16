clear all
close all
clc
% try alpha_a=sum(alpha(:,1:k-1),2).*randn(n,1);
%                                  catch    
%                                     N_errores(obs,freq,en,rad,gamma,exp)=N_errores(obs,freq,en,rad,gamma,exp)+1;
%                                     continue
%                                   end
% 


load T_advection_rho.mat
load RHO_T_Schur_r1
Tsim=1000;
m=50;
n=20*20;
sigma=1e-3;
R=sigma^2*eye(m);

frequency=1; % Frequency of observations
muestreo=frequency:frequency:Tsim;



H = eye(n,n); 
H = H(randperm(n,m),:);
[Xreal]=Function_Advection_Diffusion_2D_Proof_covarince_V2(1,Tsim);
%=====Scenario asimilating all observations and Using Shrinkage Stoica===
%==Observations===

Y=H*Xreal;
%==Number of Ensembles==
N=10;
Xb=zeros(n,N,Tsim);
Xa=Xb;



for i=1:Tsim-1
     %===== Forecast Step=====
     [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
     meanxb=mean(Xb(:,:,i),2);
     if sum(muestreo==i)
         L=(Xb(:,:,i)-meanxb)/sqrt(N);
         P0=((L*L'));
          A=sort(diag(P0));
         T=T_advection_rho.*A(end-3)/n;  
         alpha(i)=Alpha_CC_Stoica_V1(L,P0,T,N);
         B=alpha(i)*T+(1-alpha(i))*P0; 
         %===== Analysis Step=====
         K=B*H'*pinv(H*B*H'+R);
         for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
         end

         meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);
     else
     Xa(:,:,i+1)=Xb(:,:,i+1);
     meanxa_EnKF_KA(:,i+1)=mean(Xa(:,:,i+1),2);   
     end
     error_EnKF_KA(i)=norm(abs(sum(meanxa_EnKF_KA(:,i)-Xreal(:,i))));
end


%===Using Ledoid and Wolf===

for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
    meanxb=mean(Xb(:,:,i),2);
    if sum(muestreo==i)
        L=(Xb(:,:,i)-meanxb)/sqrt(N);
        P0=((L*L'));
        [phi(i),dl(i)]=Alpha_CC_Ledoid_V1(L,N,n);
        B=phi(i)*eye(n,n)+dl(i)*P0; 
        %===== Analysis Step=====
        K=B*H'*pinv(H*B*H'+R);
        for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
        end
    else
      Xa(:,:,i+1)=Xb(:,:,i+1);  
    end
    meanxa_ledoid(:,i+1)=mean(Xa(:,:,i+1),2);
    error_Ledoid(i)=norm(abs(sum(meanxa_ledoid(:,i)-Xreal(:,i))));

end



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
end

error_Background=norm(abs(sum(meanxa(:,:)-Xreal(:,:))));

% %=====Scenario asimilating all observations===
% %==Observations===

Xb=zeros(n,N,Tsim);
Xa=Xb;
for i=1:Tsim-1
    %===== Forecast Step=====
    [Xb(:,:,i+1)]=Function_Advection_Diffusion_2D(N,1,squeeze(Xa(:,:,i)),i);
    meanxb=mean(Xb(:,:,i),2);
    if sum(muestreo==i)
        L=Xb(:,:,i)-meanxb;
        P0=((1/N-1)*(L*L'));
        B=RHO_T_Schur_r1.*P0; 
        %===== Analysis Step=====
        K=B*H'*pinv(H*B*H'+R);
        for en=1:N
            Xa(:,en,i+1)=Xb(:,en,i+1)+K*(Y(:,i+1)+sigma*randn(m,1)-H*Xb(:,en,i+1));
        end
    else
         Xa(:,:,i+1)=Xb(:,:,i+1);  
    end
    meanxa_Schur(:,i+1)=mean(Xa(:,:,i+1),2);
    error_Schur(i)=norm(abs(sum(meanxa_Schur(:,i)-Xreal(:,i))));
end

figure
plot(movmean(error_Schur,100),'LineWidth',2)
hold on
plot(movmean(error_Ledoid,100),'LineWidth',2)
plot(movmean(error_EnKF_KA,100),'LineWidth',2),legend('EnKF Schur product','EnKF-LW','EnKF-KA')
