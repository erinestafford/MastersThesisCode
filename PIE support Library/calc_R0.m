function R0 = calc_R0(init,P,str)
%CHIK_CALC_R0 Given params and t0, return what would be R_0 at t_0
P = get_p_struct(str, P);
%% Calc_bt
b_hw1 = P.sigma_h1 * init(1) + P.sigma_h1 * P.pi1 * init(3) + P.sigma_h1 * init(5);
b_hw2 = P.sigma_h2 * init(2) + P.sigma_h2 * P.pi2 * init(4) + P.sigma_h2 * init(6);
b_hw = b_hw1 + b_hw2;
b_vw = P.sigma_v * init(9) + P.sigma_v * init(10) + P.sigma_v * init(11);
%total bites
b_t = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_t/b_hw;
rho_v = b_t/b_vw;
b_v = b_t/rho_v;
b_h = b_t/rho_h;
%%
Nh = init(1) + init(2) + init(3) + init(4) + init(5) + init(6);
Nv = init(9) + init(10) + init(11);

R_h = (1/(P.gamma_h +P.mu_h)) * P.beta_h * (b_t/Nv) * (P.theta1 + P.theta2);
R_v = (1/(P.nu_v + P.mu_v)) * (P.nu_v/P.mu_v) * P.beta_v * (b_t/Nh);

R0 = sqrt(R_v * R_h);

end