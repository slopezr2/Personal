clear all;

r = 1;
defaults;

dist =  [0 : n - 1];
coeffs = calc_loccoeffs(radius, locfun, dist);
v(ii : n) = coeffs(1 : n + 1 - ii);
v(1 : ii - 1) = coeffs(ii : -1 : 2);
Aii = A .* repmat(v', 1, m );
Pii = Aii * Aii' / (m - 1);
ilocal = find(v > 1.0e-8);
imin = min(ilocal);
imax = max(ilocal);
w = imax - imin;

RHO = calc_rho2(n, radius, locfun, periodic);
P_cl = RHO .* P;

Tcl = inv(sqrtm(eye(n) + P_cl * H' * H / r));
Tii = inv(sqrtm(eye(n) + Pii * H' * H / r));
T = inv(sqrtm(eye(n) + P * H' * H / r));

fprintf('  r = %.3g: || Tcl(%d, :) - Tii(%d, :) || = %.3g\n', r, ii, ii, norm(Tii(ii, :) - Tcl(ii, :)));

figure(1)

a1 = subplot(1, 3, 1);
imagesc(Tcl - eye(n));
set(a1, 'position', [0.1300    0.1100    0.2134    0.4000]);
axis square;
set(a1, 'xtick', []);
set(a1, 'ytick', []);
hold on;
plot(ii, ii, 'k.', 'markersize', 10);
line([1 n], [ii ii], 'linestyle', '--', 'color', 'k');
title('Tcl');

a2 = subplot(1, 3, 2);
imagesc(Tii - eye(n));
set(a2, 'position', [0.4108    0.1100    0.2134    0.40]);
axis square;
set(a2, 'xtick', []);
set(a2, 'ytick', []);
hold on;
plot(ii, ii, 'k.', 'markersize', 10);
rectangle('position', [imin imin w w], 'linestyle', '--', 'edgecolor', 'k');
line([1 n], [ii ii], 'linestyle', '--', 'color', 'k');
title('Tla');

a3 = subplot(1, 3, 3);
plot_steps(Tcl(ii, :), 'b', 0, 0);
hold on;
plot_steps(Tii(ii, :), 'r--', 0, 0, 1);
plot_steps(T(ii, :), 'k', 0, 1, 1);
set(a3, 'position', [0.6916    0.1100    0.2134    0.40]);
axis tight;
axis square;
if r ~= 0.0001
    legend('CL', 'LA', 'none');
else
    legend('CL', 'LA', 'none', 'location', 'northwest');
end
title('Tii');
xlabel('state vector index');
ylabel('T');

setcolormap;

h = colorbar('peer', a1, 'south');
set(h, 'position', [0.1400    0.11    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');
h = colorbar('peer', a2, 'south');
set(h, 'position', [0.4208    0.11    0.1934    0.01]);
set(h, 'xaxislocation', 'bottom');

if doplot
    pname = sprintf('plot-t-r=%.3g.ps', r);
    print('-depsc2', pname);
end
