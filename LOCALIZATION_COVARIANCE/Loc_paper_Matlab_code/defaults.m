if ~exist('doplot', 'var')
    doplot = 1;
end

if ~exist('step', 'var')
    step = 1;
end

n = 100;
m = 21;

nk = 50;
kmax = 10;
kwidth = 10;
state = 1;

randomobspos = 0;
randomobsorder = 0;
p = 30;
if ~exist('r', 'var')
    r = 1;
end

locfun = 'Gaspari_Cohn';
radius = 10;
periodic = 1;

rand('state', state);
E = zeros(n, m);
for e = 1 : m
    E(:, e) = gen_sample(n, 1, nk, kmax, kwidth, step);
end

x = mean(E')';
A = E - repmat(x, 1, m);
P = A * A' / (m - 1);

if randomobspos
    pos = floor(rand(1, p) * n) + 1;
else
    dx = n / p;
    pos = ceil(mod(floor(dx / 2 + dx * [1 : p]), n) + 1);
    if randomobsorder
        pos = pos(shuffle(p));
    end
end
H = spalloc(p, n, p);
for o = 1 : p
    H(o, pos(o)) = 1;
end
R = speye(p) * r;
Rinv = speye(p) / r;

ii = 40;

dist =  [0 : n - 1];
dist = min([abs(dist); abs(n - 1 - dist)]);
coeffs = calc_loccoeffs(radius, locfun, dist);
v(ii : n) = coeffs(1 : n + 1 - ii);
v(1 : ii - 1) = coeffs(ii : -1 : 2);
dist_obs = min([abs(ii - pos); abs(n - 1 + ii - pos); abs(n - 1 + pos - ii)]);
coeffs_obs = calc_loccoeffs(radius, locfun, dist_obs);

Aii = A .* repmat(v', 1, m );

RHO = calc_rho2(n, radius, locfun, periodic);

K = P * H' * inv(H * P * H' + R);
