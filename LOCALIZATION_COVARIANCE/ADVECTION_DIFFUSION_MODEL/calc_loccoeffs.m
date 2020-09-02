% function [coeffs] = calc_loccoeffs(radius, tag, dist)
%
% Calculates localisation coefficients
%
% @param radius - localisation radius
% @param tag - tag to choose a particular function
% @param dist - vector of distances
% @return coeffs - vector of localisation coefficients

% File:           get_loccoeffs.m
%
% Created:        14/08/2007
%
% Last modified:  11/09/2008
%
% Author:         Pavel Sakov
%                 NERSC
%
% Purpose:        Calculates localisation coefficients
%
% Description:    Note: Implications of using particular localisation matrix
%                 have not been fully investigated yet. At this moment, 'Gauss'
%                 and 'Gaspary_Cohn' seem to be the two safest options.
%
% Revisions:      22.08.2008 PS: Corrected spatial scales for each function so
%                 that calc_loccoeffs(1, function, 1) = exp(-0.5) with precision
%                 of 5 digits.
%                 11.09.2008 PS: added a check that the input distances are
%                   a row vector.
%                 21.11.2008 PS: removed the above check

%% Copyright (C) 2008 Pavel Sakov
%% 
%% This file is part of EnKF-Matlab. EnKF-Matlab is a free software. See 
%% LICENSE for details.

function [coeffs] = calc_loccoeffs(radius, dist)

        coeffs = zeros(size(dist));


        R = radius * 1.7386;
        ind1 = find(dist <= R);
        r2 = (dist(ind1) / R) .^ 2;
        r3 = (dist(ind1) / R) .^ 3;
        coeffs(ind1) = 1 + r2 .* (- r3 / 4 + r2 / 2) + r3 * (5 / 8) - r2 * (5 / 3);
        ind2 = find(dist > R & dist <= R * 2);
        r1 = (dist(ind2) / R);
        r2 = (dist(ind2) / R) .^ 2;
        r3 = (dist(ind2) / R) .^ 3;
        coeffs(ind2) = r2 .* (r3 / 12 - r2 / 2) + r3 * (5 / 8) + r2 * (5 / 3) - r1 * 5 + 4 - (2 / 3) ./ r1;
    
  
    
    return
