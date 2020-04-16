states=[63, 130,192 ,313];
Location={'outside the valley','internal border of the valley','inside the valley','external border of the valley'};
Name_file={'outside_the_valley','internal_border_of_the_valley','inside_the_valley','external_border_of_the_valley'};
close all
k=1;
for i=states
fig=figure;
plt_real=plot([0 Xreal(i,:)],'LineWidth',2,'Color',[0.4660    0.6740    0.1880 ],'MarkerIndices',[1 21 41 61 81 101 121 141 161 181 201 221 241 261 281 301 321 341 361 381 401 421 441 461 481 501 521 541 561 581 601 621 641 661 681 701 721 741 761 781 801 821 841 861 881 901 921 941 961 981 1001 1021 1041 1061 1081 1101 1121 1141 1161 1181 1201 1221 1241 1261 1281 1301 1321 1341 1361 1381 1401 1421 1441 1461 1481],...
    'Marker','o'); hold on
plt_back=plot([0 meanxa(i,:)],'LineWidth',2,'Color',[0.4940    0.1840    0.5560 ]);
plt_ledoid=plot(movmean([0 meanxa_ledoid(i,:)],100),'LineWidth',2,'Color',[0.8500    0.3250    0.0980 ]);
plt_schur=plot(movmean([0 meanxa_Schur(i,:)],100),'LineWidth',2,'Color',[0.9290    0.6940    0.1250 ]);
plt_KA=plot(movmean([0 meanxa_EnKF_KA(i,:)],100),'LineWidth',2,'Color',[0    0.4470    0.7410 ]);
legend([plt_real,plt_back,plt_KA,plt_ledoid,plt_schur],{'x*','Free-Run','EnKF-KA','EnKF-RBLW','EnKF-CL'},'FontSize',12,'Position',[0.788921427092591 0.395801368442731 0.104685210291498 0.17050690763557])
ylabel('Concentration','FontSize',14)
xlabel('Time step','FontSize',14)
xlim([0 1000])
%  saveas(fig,Name_file{k},'epsc')
k=k+1;
end