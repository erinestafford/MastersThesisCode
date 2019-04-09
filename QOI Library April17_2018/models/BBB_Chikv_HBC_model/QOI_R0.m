function R0 = QOI_R0(params)
% input: POIs and old_soln structure from ode solver
% output: Reproductive number

init = get_init(params);

%% Calculate Biting Rates
%biting rates desired for hosts and vectors
b_hw1 = params.sigma_h1 * init(1) + params.sigma_h1 * params.pi1 * init(3) + params.sigma_h1 * init(5);
b_hw2 = params.sigma_h2 * init(2) + params.sigma_h2 * params.pi2 * init(4) + params.sigma_h2 * init(6);
b_hw = b_hw1 + b_hw2;
b_vw = params.sigma_v * init(7) + params.sigma_v * init(8) + params.sigma_v * init(9);

%total bites
b_T = (b_hw * b_vw)/(b_hw + b_vw);

%% R0 for model
Nh = init(1) + init(2) + init(3) + init(4) + init(5) + init(6);
Nv = init(9) + init(10) + init(11);

R_h = (1/(params.gamma_h +params.mu_h)) * params.beta_h * (b_T/Nv) * (params.theta1 + params.theta2);
R_v = (1/(params.nu_v + params.mu_v)) * (params.nu_v/params.mu_v) * params.beta_v * (b_T/Nh);

R0 = sqrt(R_v * R_h);

end
