r = 0.01;
defaults;

P_cl = RHO .* P;
T_cl = inv(sqrtm(eye(n) + P_cl * H' * H / r));

A_la = A;
T_la = zeros(n, n);
for i = 1 : n
    v(i : n) = coeffs(1 : n + 1 - i);
    v(1 : i - 1) = coeffs(i : -1 : 2);
    Ai = A .* repmat(v', 1, m );
    Pi = Ai * Ai' / (m - 1);
    Ti = inv(sqrtm(eye(n) + Pi * H' * H / r));
    A_la(i, :) = Ti(i, :) * Ai;
    T_la (i, :) = Ti(i, :);
end

figure(1);

a1 = subplot(1, 2, 1);
imagesc(T_cl - eye(n));
axis square;
set(a1, 'xtick', []);
set(a1, 'ytick', []);
set(a1, 'position', [0.13    0.1100    0.3347    0.8150]);
title('Tcl');

a2 = subplot(1, 2, 2);
imagesc(T_la - eye(n));
axis square;
set(a2, 'xtick', []);
set(a2, 'ytick', []);
set(a2, 'position', [0.50    0.1100    0.3347    0.8150]);
title('Tla');

h = colorbar('peer', a2, 'east');
set(h, 'xaxislocation', 'bottom');
set(h, 'position', [0.86    0.3321    0.015    0.3881]);
set(h, 'ytickmode', 'manual', 'ytick', [-2 -1 0 1 2])

setcolormap;
c = caxis(a2);
caxis(a1, c);

if doplot
    pname = sprintf('plot-tla-r=%.3g.ps', r);
    print('-depsc2', pname);
end
