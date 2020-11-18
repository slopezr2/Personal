%====Algorithm to create Target Matrix EnKF-KA====
clear all
load orog.mat

ncolumn=110; %Number of columns
nrow=100;
n=nrow*ncolumn; %Number of states
T=zeros(n);
dist=[0:ncolumn-1];
Radius=5; %Radius of localization
R=Radius* 1.7386;
coeffs=zeros(n,1);
ind1 = find(dist <= R);
r2 = (dist(ind1) / R) .^ 2;
r3 = (dist(ind1) / R) .^ 3;
coeffs(ind1) = 1 + r2 .* (- r3 / 4 + r2 / 2) + r3 * (5 / 8) - r2 * (5 / 3);
ind2 = find(dist > R & dist <= R * 2);
r1 = (dist(ind2) / R);
r2 = (dist(ind2) / R) .^ 2;
r3 = (dist(ind2) / R) .^ 3;
coeffs(ind2) = r2 .* (r3 / 12 - r2 / 2) + r3 * (5 / 8) + r2 * (5 / 3) - r1 * 5 + 4 - (2 / 3) ./ r1;

KA=1; %Include Knownledge

%===Physical restrictions====
min_height_value=200;
max_height_value=600;
guardar=0;
for i=1:n
    %===Detection of row and column
     [row,column]=ind2sub([nrow,ncolumn],i);
     row_radius=[max(1,row-nrow):1:min(nrow,row+nrow)];
     column_radius=[max(1,column-ncolumn):1:min(ncolumn,column+ncolumn)];
     for j=1:length(row_radius)
         for k=1:length(column_radius)
             D=Distance_2d([row column],[row_radius(j) column_radius(k)]);
%              D=max(abs(row-row_radius(j)),abs(column-column_radius(k)));
             state=sub2ind([nrow,ncolumn],row_radius(j), column_radius(k));
             indice=floor(D)+1;
             T(i,state)=coeffs(indice);
             if KA==1
                height_diff=abs(orog(row,column)-orog(row_radius(j),column_radius(k)) );
                if  (height_diff>=max_height_value)
                    T(i,state)=0;
                    T(state,i)=0;
%                 elseif (height_diff>=min_height_value && height_diff<max_height_value)
%                     smooth_factor=(-1/(max_height_value-min_height_value))*(height_diff-min_height_value)+1;
%                     T(i,state)=T(i,state)*smooth_factor;
                    
                
                end                
             else
               
             end
             
         end
         
     end
     
     
     
end
Fig=figure;
imagesc(T)
colormap(Fig,flipud(hot))
% title(titulo)
xlabel('States')
ylabel('States')
% colorbar
set(Fig,'Colormap',...
    [204/255 204/255 204/255;1 1 0;1 0.974358975887299 0;1 0.948717951774597 0;1 0.923076927661896 0;1 0.897435903549194 0;1 0.871794879436493 0;1 0.846153855323792 0;1 0.82051283121109 0;1 0.794871807098389 0;1 0.769230782985687 0;1 0.743589758872986 0;1 0.717948734760284 0;1 0.692307710647583 0;1 0.666666686534882 0;1 0.64102566242218 0;1 0.615384638309479 0;1 0.589743614196777 0;1 0.564102590084076 0;1 0.538461565971375 0;1 0.512820541858673 0;1 0.487179487943649 0;1 0.461538463830948 0;1 0.435897439718246 0;1 0.410256415605545 0;1 0.384615391492844 0;1 0.358974367380142 0;1 0.333333343267441 0;1 0.307692319154739 0;1 0.282051295042038 0;1 0.256410270929337 0;1 0.230769231915474 0;1 0.205128207802773 0;1 0.179487183690071 0;1 0.15384615957737 0;1 0.128205135464668 0;1 0.102564103901386 0;1 0.0769230797886848 0;1 0.0512820519506931 0;1 0.0256410259753466 0;1 0 0;0.958333313465118 0 0;0.916666686534882 0 0;0.875 0 0;0.833333313465118 0 0;0.791666686534882 0 0;0.75 0 0;0.708333313465118 0 0;0.666666686534882 0 0;0.625 0 0;0.583333313465118 0 0;0.541666686534882 0 0;0.5 0 0;0.458333343267441 0 0;0.416666656732559 0 0;0.375 0 0;0.333333343267441 0 0;0.291666656732559 0 0;0.25 0 0;0.20833332836628 0 0;0.16666667163372 0 0;0.125 0 0;0.0833333358168602 0 0;0.0416666679084301 0 0]);
% Create colorbar
colorbar

if guardar==1
    if KA==1
        T_AMVA=T;
        save T_AMVA T_AMVA
    else
        T_no_AMVA=T;
        save T_no_AMVA T_no_AMVA
    end
end