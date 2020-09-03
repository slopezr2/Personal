load T_AMVA.mat
load T_no_AMVA.mat
load lat_ecmwf.mat
load lon_ecmwf.mat
load orog.mat
close all

T_AMVA(T_AMVA==0)=NaN;
T_no_AMVA(T_no_AMVA==0)=NaN;

%===Dimensions domain====
x_T=100;
y_T=110;

%===States to visualizate===
x_1=43;
y_1=47;
x_2=61;
y_2=80;

state_1=sub2ind([x_T,y_T],x_1, y_1);
state_2=sub2ind([x_T,y_T],x_2, y_2);




covariance_1=T_AMVA(state_1,:);
covariance_no_1=T_no_AMVA(state_1,:);
covariance_2=T_AMVA(state_2,:);
covariance_no_2=T_no_AMVA(state_2,:);
fig=figure;
hold on
matrix_1=reshape(covariance_1,[100 110]);
matrix_2=reshape(covariance_2,[100 110]);
imAlpha=ones(size(matrix_2));
imAlpha(isnan(matrix_2))=0;
imagesc(lon_ecmwf,lat_ecmwf, matrix_1')
imagesc(lon_ecmwf,lat_ecmwf, matrix_2','AlphaData',imAlpha')
set(gca,'YDir','normal')
colormap(flipud(hot))
colorbar
S=shaperead('/home/slopezr2/Documents/Municipios_AreaMetropolitana.shp');
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(x_1),lat_ecmwf(y_1),15,'s','b','filled')
scatter(lon_ecmwf(x_2),lat_ecmwf(y_2),15,'s','b','filled')
ylim([5.8 6.8])
saveas(fig,'Target','png')



fig2=figure;

hold on
matrix_no_1=reshape(covariance_no_1,[100 110]);
matrix_no_2=reshape(covariance_no_2,[100 110]);
imAlpha=ones(size(matrix_no_2));
imAlpha(isnan(matrix_no_2))=0;
imagesc(lon_ecmwf,lat_ecmwf, matrix_no_1')
imagesc(lon_ecmwf,lat_ecmwf, matrix_no_2','AlphaData',imAlpha')
set(gca,'YDir','normal')
colormap(flipud(hot))
colorbar
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(x_1),lat_ecmwf(y_1),15,'s','b','filled')
scatter(lon_ecmwf(x_2),lat_ecmwf(y_2),15,'s','b','filled')
ylim([5.8 6.8])
saveas(fig2,'Distances','png')



fig3=figure;
imagesc(lon_ecmwf,lat_ecmwf,orog')
set(gca,'YDir','normal')
colorbar
colormap(flipud(autumn))
hold on
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(x_1),lat_ecmwf(y_1),15,'s','b','filled')
scatter(lon_ecmwf(x_2),lat_ecmwf(y_2),15,'s','b','filled')
saveas(fig3,'orography','png')