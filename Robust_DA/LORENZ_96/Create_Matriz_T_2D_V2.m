%====Algorithm to create Target Matrix EnKF-KA====
clear all
% load RHO_advection.mat
n=40; %Number of states
ncolumn=40; %Number of columns
nrow=n/ncolumn;
T=zeros(n);
% T=RHO_advection;
Radius=4; %Radius of localization
r=Radius+2;
KA=0; %Include Knownledge
dist = (0 : ncolumn - 1);
coeffs = exp(-1* (dist / Radius) .^ 2);
%===Physical restrictions====
NRest=2; %Number of restrictions
Rest_vert=9:15;
Rest_hori=5:15;
for i=1:n
    %===Detection of row and column
     [row,column]=ind2sub([nrow,ncolumn],i);
     row_radius=[max(1,row-r):1:min(nrow,row+r)];
     column_radius=[max(1,column-r):1:min(ncolumn,column+r)];
     for j=1:length(row_radius)
         for k=1:length(column_radius)
             D=Distance_2d([row column],[row_radius(j) column_radius(k)]);
             state=sub2ind([nrow,ncolumn],row_radius(j), column_radius(k));
              T(i,state)=coeffs(floor(D)+1);
             if KA==1 && row>Rest_vert(1) && row<Rest_vert(end) && column>Rest_hori(1) && column<Rest_hori(end) && (row_radius(j)<=Rest_vert(1) || row_radius(j)>=Rest_vert(end) || column_radius(k)<=Rest_hori(1) || column_radius(k)>=Rest_hori(end) )  
                T(i,state)=0;
                T(state,i)=0;
                titulo=['Covariance Proposed Structure with a localization radius of ',num2str(Radius),' and incorporing previous knowledge'];
             else
               titulo=['Covariance Proposed Structure with a localization radius of ',num2str(Radius),' without incorporing previous knowledge'];   
              end
             
         end
         
     end
     
     
     
end
hFig=figure;
imagesc(T)
% colormap(hFig,flipud(hot))
title(titulo)
xlabel('States')
ylabel('States')
% colorbar
set(hFig,'Colormap',...
    [204/255 204/255 204/255;1 1 0;1 0.974358975887299 0;1 0.948717951774597 0;1 0.923076927661896 0;1 0.897435903549194 0;1 0.871794879436493 0;1 0.846153855323792 0;1 0.82051283121109 0;1 0.794871807098389 0;1 0.769230782985687 0;1 0.743589758872986 0;1 0.717948734760284 0;1 0.692307710647583 0;1 0.666666686534882 0;1 0.64102566242218 0;1 0.615384638309479 0;1 0.589743614196777 0;1 0.564102590084076 0;1 0.538461565971375 0;1 0.512820541858673 0;1 0.487179487943649 0;1 0.461538463830948 0;1 0.435897439718246 0;1 0.410256415605545 0;1 0.384615391492844 0;1 0.358974367380142 0;1 0.333333343267441 0;1 0.307692319154739 0;1 0.282051295042038 0;1 0.256410270929337 0;1 0.230769231915474 0;1 0.205128207802773 0;1 0.179487183690071 0;1 0.15384615957737 0;1 0.128205135464668 0;1 0.102564103901386 0;1 0.0769230797886848 0;1 0.0512820519506931 0;1 0.0256410259753466 0;1 0 0;0.958333313465118 0 0;0.916666686534882 0 0;0.875 0 0;0.833333313465118 0 0;0.791666686534882 0 0;0.75 0 0;0.708333313465118 0 0;0.666666686534882 0 0;0.625 0 0;0.583333313465118 0 0;0.541666686534882 0 0;0.5 0 0;0.458333343267441 0 0;0.416666656732559 0 0;0.375 0 0;0.333333343267441 0 0;0.291666656732559 0 0;0.25 0 0;0.20833332836628 0 0;0.16666667163372 0 0;0.125 0 0;0.0833333358168602 0 0;0.0416666679084301 0 0]);
% Create colorbar
colorbar