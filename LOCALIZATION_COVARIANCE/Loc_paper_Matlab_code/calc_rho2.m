function RHO = calc_rho2(n, loc, tag, periodic)

    if ~exist('tag', 'var')
        tag = 'Gauss';
    end
    
    if ~exist('periodic', 'var')
        periodic = 1;
    end
    
    dist = [0 : n - 1];
    if periodic
        dist = min([dist; n - dist]);
    end

    coeffs = calc_loccoeffs(loc, tag, dist);
    
    RHO = zeros(n, n);
    for i = 1 : n
        v(i : n) = coeffs(1 : n + 1 - i);
        v(1 : i - 1) = coeffs(i : -1 : 2);
        RHO(i, :) = v;
    end

    return
