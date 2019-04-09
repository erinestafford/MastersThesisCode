function Reff = QOI_Reff(params)
%CHIK_CALC_R0 Given params and t0, return what would be R_0 at t_0
init = get_init(params);
Nh = init(1) + init(2) + init(3) + init(4) + init(5) + init(6);
Nv = init(9) + init(10) + init(11);
%% Calculate Biting Rates
%biting rates desired for hosts and vectors
b_hw1 = params.sigma_h1 * init(1) + params.sigma_h1 * params.pi1 * init(3) + params.sigma_h1 * init(5);
b_hw2 = params.sigma_h2 * init(2) + params.sigma_h2 * params.pi2 * init(4) + params.sigma_h2 * init(6);
b_hw = b_hw1 + b_hw2;
b_vw = params.sigma_v * init(7) + params.sigma_v * init(8) + params.sigma_v * init(9);

%total bites
b_T = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_T/b_hw;
rho_v = b_T/b_vw;
%% Reff for model
P_hs1 = (rho_h * params.sigma_h1 * init(1))/b_T;
P_hs2 = (rho_h * params.sigma_h2 * init(2))/b_T;
P_hs = P_hs1 + P_hs2;

R_h1 = params.theta1 * (1/(params.gamma_h + params.mu_h)) * (params.beta_h) * (b_T/Nv) * P_hs ;
R_h2 = params.theta2 * (1/(params.gamma_h + params.mu_h)) * (params.beta_h) * (b_T/Nv) * P_hs ;
R_h = R_h1+R_h2;

R_v = (1/(params.nu_v + params.mu_v)) * (params.nu_v/params.mu_v) * (params.beta_v) * (b_T/Nh) * (init(9)/Nv);

Reff = sqrt(R_v * R_h);

end
