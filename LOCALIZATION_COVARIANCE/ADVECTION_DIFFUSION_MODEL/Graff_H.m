function Graff_H(H,nrow,ncolumn)
HH=zeros(20,20);
for i=1:size(H,1)
   j=find(H(i,:)==1); 
   [row,column]=ind2sub([nrow,ncolumn],j);
   HH(row,column)=1;
end
figure
imagesc(HH)
hold on
        plot(5:15,9*ones(11),'g','LineWidth',2)
        plot(5:15,15*ones(11),'g','LineWidth',2)
        plot(5*ones(7),9:15,'g','LineWidth',2)
        plot(15*ones(7),9:15,'g','LineWidth',2)

