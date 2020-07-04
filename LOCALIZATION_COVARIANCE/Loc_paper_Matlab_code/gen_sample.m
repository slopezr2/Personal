function [x] = gen_sample(n, kstart, kend, kmax, kwidth, step)

    inverse_scale = 0;
    if ~exist('kmax', 'var') | kwidth == 0
        inverse_scale = 1;
    end
    
    if ~exist('step', 'var')
        step = 1;
    end
    
    xx = (1 : n)';
    x = zeros(n, 1);
    
    kvalid = [kstart : step : kend];
    %
    % (an easier way to pick the wave numbers would be to use
    % "kstart : step : kend" in the "for" cycle below, but we want
    % to get exactly the same amplitudes regardless of the chosen wave
    % numbers...)
    %
    for k = kstart : kend
        kk = k * 2.0 * pi / n; % wave number
        if inverse_scale
            a = rand / k; % amplitude
        else
            a = rand * exp(-0.5 * ((k - kmax) / kwidth) ^ 2);
        end
        ph = rand * 2.0 * pi; % phase
        if ismember(k, kvalid)
            x = x + a * sin(kk * xx + ph);
        end
    end

    return
