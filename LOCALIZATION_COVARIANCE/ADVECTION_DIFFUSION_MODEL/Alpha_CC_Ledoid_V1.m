%===Algorithm to calculate Alpha for a Convex Combination
%in a Shrinkage formulation based on "On Using a priori Knowledge in
%Space-Time Adaptive Processing"

function [phi,dl]=Alpha_CC_Ledoid_V1(L,N,n)
        [~,S,~] = svd(L,0); 
        S=diag(S).^2;
        S2=sum(S.^2);
        S=sum(S);
        u = S/n; 
        suma=0;
        sb=L*sqrt(N-1);
        for k=1:N 
            suma=suma + norm(sb(:,k)).^4;
        end
        l = min((suma-(N-2)*S2)/((S2-(S^2)/n)*N^2),1);
        dl= 1-l;
        phi=l*u;