clear all;

defaults;

ilocal = find(v > 1.0e-8);
imin = min(ilocal);
imax = max(ilocal);
w = imax - imin;

figure(1);

a1 = subplot(1, 3, 1);
imagesc(v' * v);
set(a1, 'position', [0.1300    0.1100    0.2134    0.8150]);
axis square;
set(a1, 'xtick', []);
set(a1, 'ytick', []);
hold on;
plot(ilocal, ilocal, 'k.', 'markersize', 4);
plot(ii, ii, 'k.', 'markersize', 10);
rectangle('position', [imin imin w w], 'linestyle', '--', 'edgecolor', 'k');
title('FF');

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
imagesc(Aii * Aii' / (m - 1));
caxis(c);
axis square;
set(a3, 'position', [0.6916    0.1100    0.2134    0.8150]);
set(a3, 'xtick', []);
set(a3, 'ytick', []);
hold on;
plot(ii, ii, 'k.', 'markersize', 10);
rectangle('position', [imin imin w w], 'linestyle', '--', 'edgecolor', 'k');
title('AA');

h = colorbar('south');
set(h, 'position', [0.7016    0.330    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

setcolormap;

if doplot
    print -depsc2 'plot-la.ps';
end
