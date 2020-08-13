load T_AMVA.mat
load T_no_AMVA.mat
load lat_ecmwf.mat
load lon_ecmwf.mat
load orog.mat
close all

T_AMVA(T_AMVA==0)=NaN;
T_no_AMVA(T_no_AMVA==0)=NaN;
state_1=T_AMVA(4643,:);
state_no_1=T_no_AMVA(4643,:);
state_2=T_AMVA(7961,:);
state_no_2=T_no_AMVA(7961,:);
fig=figure;
hold on
matrix_1=reshape(state_1,[100 110]);
matrix_2=reshape(state_2,[100 110]);
imAlpha=ones(size(matrix_2));
imAlpha(isnan(matrix_2))=0;
imagesc(lon_ecmwf,lat_ecmwf, matrix_1')
imagesc(lon_ecmwf,lat_ecmwf, matrix_2','AlphaData',imAlpha')
set(gca,'YDir','normal')
colormap(flipud(hot))
colorbar
S=shaperead('/home/slopezr2/Documents/Municipios_AreaMetropolitana.shp');
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(43),lat_ecmwf(47),15,'s','b','filled')
scatter(lon_ecmwf(61),lat_ecmwf(80),15,'s','b','filled')
ylim([5.8 6.8])




fig2=figure;

hold on
matrix_no_1=reshape(state_no_1,[100 110]);
matrix_no_2=reshape(state_no_2,[100 110]);
imAlpha=ones(size(matrix_no_2));
imAlpha(isnan(matrix_no_2))=0;
imagesc(lon_ecmwf,lat_ecmwf, matrix_no_1')
imagesc(lon_ecmwf,lat_ecmwf, matrix_no_2','AlphaData',imAlpha')
set(gca,'YDir','normal')
colormap(flipud(hot))
colorbar
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(43),lat_ecmwf(47),15,'s','b','filled')
scatter(lon_ecmwf(61),lat_ecmwf(80),15,'s','b','filled')
ylim([5.8 6.8])




fig3=figure;
imagesc(lon_ecmwf,lat_ecmwf,orog')
set(gca,'YDir','normal')
colorbar
hold on
mapshow(S,'FaceColor',[0.2 0.2 0.2],'FaceAlpha',0.0, 'LineWidth',1)
scatter(lon_ecmwf(43),lat_ecmwf(47),15,'s','b','filled')