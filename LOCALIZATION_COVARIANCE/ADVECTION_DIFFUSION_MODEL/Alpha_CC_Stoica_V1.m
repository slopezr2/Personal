%===Algorithm to calculate Alpha for a Convex Combination
%in a Shrinkage formulation based on "On Using a priori Knowledge in
%Space-Time Adaptive Processing"

function alpha=Alpha_CC_Stoica_V1(L,P0,T,N)
sum=0;
for i=1:N
sum=sum+norm(L(:,i))^4;
end

rho=abs((1/(N^2))*sum-(1/N)*norm(P0)^2);
normB=norm(P0-T)^2;
if normB==0
    alpha=0;
else
    alpha=rho/(normB);
    alpha=max(0,alpha);
    alpha=min(1,alpha);
end
k=2;