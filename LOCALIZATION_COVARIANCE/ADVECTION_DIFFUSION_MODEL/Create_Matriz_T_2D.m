%====Algorithm to create Target Matrix EnKF-KA====
clear all
n=400; %Number of states
ncolumn=20; %Number of columns
nrow=n/ncolumn;
T=zeros(n);
R=4; %Radius of localization
dist = [0 : ncolumn - 1];
coeffs = exp(-1* (dist / R) .^ 2);
for i=1:n
    %===Detection of row and column
     [row,column]=ind2sub([nrow,ncolumn],i);
     
     
     
     
  
     
     
     
     
      if i<n-ncolumn+1
        T(i,i:i+nrow-1)=coeffs;   
        T(i,i:ncolumn:n)=coeffs(1:end+1-column);
        j=i+ncolumn+1;
         k=2;
         [rowj,columnj]=ind2sub([nrow,ncolumn],j); 

         while rowj>row && j<n
             T(i,j)=coeffs(k);
             T(j,i)=coeffs(k);
             j=j+ncolumn+1;
             k=k+1;
             [rowj,columnj]=ind2sub([nrow,ncolumn],j); 

         end
      else
        T(i,i:n)=coeffs(1:(n-i)+1);
        
      end
      
      
      if i>ncolumn-1
        T(i,i-nrow+1:i)=flip(coeffs); 
              
      else
        T(i,1:i)=flip(coeffs(1:i));    
      end
            

     
      if column>1
         T(i,flip(i:-ncolumn:1))=flip(coeffs(1:column));  
      end
    
end
imagesc(T)
