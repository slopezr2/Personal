clear all;

logr_all = [2 : -0.5 : -4];

doplot = 0;
defaults;
RHO = calc_rho2(n, radius, locfun, periodic);
P_cl_f = RHO .* P;
dist =  [0 : n - 1];
coeffs = calc_loccoeffs(radius, locfun, dist);

std_f = sqrt(trace(H * P * H') / p);
fprintf('  initial spread = %.3g\n', std_f);

r_all = [];
std_all = [];
std_cl_all = [];
std_la_all = [];
dfs_all = [];
dfs_cl_all = [];
dfs_la_all = [];
for logr = logr_all

    r = 10^logr;
    
    K = P * H' * inv(H * P * H' + speye(p) * r);
    A_a = sqrtm(eye(n) - K * H) * A;
    P_a = (eye(n) - K * H) * P;
    std_a = sqrt(trace(H * P_a * H') / p);

    A_cl = inv(sqrtm(eye(n) + P_cl_f * H' * H / r)) * A;
    P_cl = A_cl * A_cl' / (m - 1);
    K_cl = P_cl_f * H' * inv(H * P_cl_f * H' + speye(p) * r);

    A_la = A;
    K_la = zeros(n, p);
    for i = 1 : n
        v(i : n) = coeffs(1 : n + 1 - i);
        v(1 : i - 1) = coeffs(i : -1 : 2);
        Ai = A .* repmat(v', 1, m );
        Pi = Ai * Ai' / (m - 1);
        Ti = inv(sqrtm(eye(n) + Pi * H' * H / r));
        A_la(i, :) = Ti(i, :) * Ai;
        K_la(i, :) = Pi(i, :) * H' * inv(H * Pi * H' + speye(p) * r);
    end
    P_la = A_la * A_la' / (m - 1);
    
    if doplot
        figure;
        subplot(1, 3, 1);
        plot(A_a);
        subplot(1, 3, 2);
        plot(A_cl);
        subplot(1, 3, 3);
        plot(A_la);
        pause(0.2);
    end
    
    std_cl = sqrt(trace(H * P_cl * H') / p);
    std_la = sqrt(trace(H * P_la * H') / p);
    
    dfs = trace(K * H);
    dfs_cl = trace(K_cl * H);
    dfs_la = trace(K_la * H);
    
    r_all = [r_all, r];
    std_all = [std_all std_a];
    std_cl_all = [std_cl_all std_cl];
    std_la_all = [std_la_all std_la];
    dfs_all = [dfs_all dfs];
    dfs_cl_all = [dfs_cl_all dfs_cl];
    dfs_la_all = [dfs_la_all dfs_la];

    fprintf('  r = %.3g:\n', r);
    fprintf('    no loc:\n');
    fprintf('      spread = %.3g\n', std_a);
    fprintf('      factor = %.3g\n', std_f / std_a);
    fprintf('      dfs = %.3g\n', dfs);
    fprintf('    cl:\n');
    fprintf('      spread = %.3g\n', std_cl);
    fprintf('      factor = %.3g\n', std_f / std_cl);
    fprintf('      dfs = %.3g\n', dfs_cl);
    fprintf('    la:\n');
    fprintf('      spread = %.3g\n', std_la);
    fprintf('      factor = %.3g\n', std_f / std_la);
    fprintf('      dfs = %.3g\n', dfs_la);
end
    
figure;
loglog(r_all, std_cl_all, 'b.-');
hold on;
loglog(r_all, std_la_all, 'r.-');
loglog(r_all, std_all, 'k.-');
title('spread');
legend('CL', 'LA', 'non', 'position', 'northwest');

figure;
loglog(r_all, dfs_cl_all, 'b.-');
hold on;
loglog(r_all, dfs_la_all, 'r.-');
loglog(r_all, dfs_all, 'k.-');
title('dfs');
legend('CL', 'LA', 'non', 'position', 'northwest');
