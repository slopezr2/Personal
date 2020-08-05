dc=zeros(20);

nx_int=[4 7 8 9 14 15 16 ];

ny_int=[ 6 10 10 10 17 17 17];

agrup=[10,50,50,50,20,20,20];

parameters=rand(max(agrup),1);

for i=1:length(agrup)
       dc(nx_int(i),ny_int(i))=parameters(agrup(i));
end
    
    
    
    

imagesc(dc)