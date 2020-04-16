clear all;

defaults;

figure(1);

a1 = subplot(1, 3, 1);
imagesc(RHO);
set(a1, 'position', [0.1300    0.1100    0.2134    0.8150]);
axis square;
set(a1, 'xtick', []);
set(a1, 'ytick', []);
title('RHO')

h = colorbar('south');
set(h, 'position', [0.1400    0.330    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

a2 = subplot(1, 3, 2);
imagesc(P);
c = caxis;
set(a2, 'position', [0.4108    0.1100    0.2134    0.8150]);
axis square;
set(a2, 'xtick', []);
set(a2, 'ytick', []);
title('P')

h = colorbar('south');
set(h, 'position', [0.4208    0.330    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

a3 = subplot(1, 3, 3);
imagesc(P .* RHO);
caxis(c);
set(a3, 'position', [0.6916    0.1100    0.2134    0.8150]);
axis square;
set(a3, 'xtick', []);
set(a3, 'ytick', []);
title('RHOP')

h = colorbar('south');
set(h, 'position', [0.7016    0.330    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

setcolormap;

if doplot
    print -depsc2 'plot-cl.ps';
end

