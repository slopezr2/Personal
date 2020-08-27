function RHO = calc_rho2(n, loc)

  
    dist = [0 : n - 1];
    coeffs = calc_loccoeffs(loc, dist);
    coeffs
    RHO = zeros(n, n);
    for i = 1 : n
        v(i : n) = coeffs(1 : n + 1 - i);
        v(1 : i - 1) = coeffs(i : -1 : 2);
        RHO(i, :) = v;
    end

    return
