clear all;
defaults;

P_la = Aii * Aii' / (m - 1);
ilocal = find(v > 1.0e-8);
imin = min(ilocal);
imax = max(ilocal);
w = imax - imin;

P_cl = RHO .* P;

Tcl_sq = eye(n) + P_cl * H' * H / r;
Tla_sq = eye(n) + P_la * H' * H / r;
T_sq = eye(n) + P * H' * H / r;

fprintf('  || Tcl_sq(%d, :) - Tla_cl(%d, :) || = %.3g\n', ii, ii, norm(Tla_sq(ii, :) - Tcl_sq(ii, :)));

figure(1)

a1 = subplot(1, 3, 1);
imagesc(Tcl_sq);
c = caxis;
set(a1, 'position', [0.1300    0.1100    0.2134    0.4000]);
axis square;
set(a1, 'xtick', []);
set(a1, 'ytick', []);
hold on;
plot(ii, ii, 'k.', 'markersize', 10);
line([1 n], [ii ii], 'linestyle', '--', 'color', 'k');
title('Tclsq');

a2 = subplot(1, 3, 2);
imagesc(Tla_sq);
caxis(c);
set(a2, 'position', [0.4108    0.1100    0.2134    0.40]);
axis square;
set(a2, 'xtick', []);
set(a2, 'ytick', []);
hold on;
plot(ii, ii, 'k.', 'markersize', 10);
rectangle('position', [imin imin w w], 'linestyle', '--', 'edgecolor', 'k');
line([1 n], [ii ii], 'linestyle', '--', 'color', 'k');
title('Tlasq');

a3 = subplot(1, 3, 3);
plot_steps(Tcl_sq(ii, :), 'b', 0, 0);
hold on;
plot_steps(Tla_sq(ii, :), 'r--', 0, 0, 1);
plot_steps(T_sq(ii, :), 'k', 0, 1, 1);
set(a3, 'position', [0.6916    0.1100    0.2134    0.40]);
axis tight;
axis square;
legend('CL', 'LA', 'none');
title('Tiisq');
xlabel('state vector index');
ylabel('Tsq');

setcolormap;

h = colorbar('peer', a1, 'south');
set(h, 'position', [0.1400    0.11    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');
h = colorbar('peer', a2, 'south');
set(h, 'position', [0.4208    0.11    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

if doplot
    pname = 'plot-tsq.ps';
    print('-depsc2', pname);
end
