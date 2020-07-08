r = 1e-2;

figure;
for step = [1 2]
    defaults;

    RHO = calc_rho2(n, radius, locfun, periodic);
    P_cl_f = RHO .* P;
    dist =  [0 : n - 1];
    coeffs = calc_loccoeffs(radius, locfun, dist);

    A_cl = inv(sqrtm(eye(n) + P_cl_f * H' * H / r)) * A;

    A_la = A;
    for i = 1 : n
        v(i : n) = coeffs(1 : n + 1 - i);
        v(1 : i - 1) = coeffs(i : -1 : 2);
        Ai = A .* repmat(v', 1, m );
        Pi = Ai * Ai' / (m - 1);
        Ti = inv(sqrtm(eye(n) + Pi * H' * H / r));
        A_la(i, :) = Ti(i, :) * Ai;
    end

    subplot(1, 2, step);
    plot_ensspectrum(A, 50, 'b', 1, 0, 0);
    plot_ensspectrum(A_cl, 50, 'g', 0, 0, 0);
    plot_ensspectrum(A_la, 50, 'r', 0, 0, 0);
    
    [a, b, c, d] = legend('', 'Forecast', 'CL', 'LA');
    legend(c([2 3 4]), d([2 3 4]));

    set(gca, 'xlim', [0 50]);
    xlabel('spectral component');
    ylabel('psd');
    if step == 1
        title('a');
    else
        title('b');
    end

    pause(0.2);
end

pname = sprintf('plot-spectrum-r=%.3g.ps', r);
print('-depsc2', pname);
