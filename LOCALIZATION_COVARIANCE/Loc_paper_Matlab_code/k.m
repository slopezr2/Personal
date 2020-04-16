clear all;

r = 1;
defaults;

olocal = find(coeffs_obs > 1.0e-3);
ilocal = pos(olocal);
wi = max(ilocal) - min(ilocal);
wo = max(olocal) - min(olocal);

Pcl = RHO .* P;
Kcl = Pcl * H' * inv(H * Pcl * H' + R);

P_la = Aii * Aii' / (m - 1);
K_la = P_la * H' * inv( H * P_la * H' + R);

K_la = K_la .* repmat(coeffs_obs, n, 1);

fprintf('  || Pcl(%d, :) - P_la(%d, :) || = %.4g\n', ii, ii, norm(Pcl(ii, :) - P_la(ii, :)));

fprintf('  || Kcl - K_la || = %.4g\n', norm(Kcl - K_la));
fprintf('  || Kcl(%d, :) - K_la(%d, :) || = %.4g\n', ii, ii, norm(Kcl(ii, :) - K_la(ii, :)));

figure(1);

a1 = subplot(1, 3, 1);
imagesc(Kcl);
c = caxis;
set(a1, 'position', [0.1300    0.1850    0.2134    0.40]);
axis equal;
axis tight;
xlabel('obs. index');
ylabel('state vector index');
title('Kcl');
line([1 p], [ii ii], 'linestyle', '--', 'color', 'k');

h = colorbar('south');
set(h, 'position', [0.1400    0.080    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

a2 = subplot(1, 3, 2);
imagesc(K_la);
caxis(c);
set(a2, 'position', [0.4108    0.1850    0.2134    0.40]);
axis equal;
axis tight;
xlabel('obs. index');
ylabel('state vector index');
title('Kla')
hold on;
plot(olocal, ilocal, 'k.', 'markersize', 4);
rectangle('position', [min(olocal) min(ilocal) wo wi], 'linestyle', '--', 'edgecolor', 'k');
line([1 p], [ii ii], 'linestyle', '--', 'color', 'k');

h = colorbar('south');
set(h, 'position', [0.4208    0.080    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

a3 = subplot(1, 3, 3);
plot_steps(Kcl(ii, :), 'b', 0, 0);
hold on;
plot_steps(K_la(ii, :), 'r', 0, 0, 1);
plot_steps(K(ii, :), 'k', 0, 1, 1);
hold off;
set(a3, 'position', [0.6916    0.1100    0.2134    0.475]);
axis tight;
xlabel('obs. index');
ylabel('gain');
title('Kii')
legend('CL', 'LA', 'none');

setcolormap;

if doplot
    pname = sprintf('plot-k-r=%.3g.ps', r);
    print('-depsc2', pname);
end
