function [ b_T,rho_h, rho_v ] = calc_b_T(P, init)

%biting rates desired for hosts and vectors
b_hw1 = P.sigma_h1 * init(1) + P.sigma_h1 * P.pi1 * init(3) + P.sigma_h1 * init(5);
b_hw2 = P.sigma_h2 * init(2) + P.sigma_h2 * P.pi2 * init(4) + P.sigma_h2 * init(6);
b_hw = b_hw1 + b_hw2;
b_vw = P.sigma_v * init(9) + P.sigma_v * init(10) + P.sigma_v * init(11);
%total bites
b_T = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_T/b_hw;
rho_v = b_T/b_vw;
b_v = b_T/rho_v;
b_h = b_T/rho_h;
%r = b_v/b_h;
end

