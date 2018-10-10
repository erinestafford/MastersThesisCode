function R0 = calc_R0(P, init)
%CHIK_CALC_R0 Given params and t0, return what would be R_0 at t_0
[b_t, rho_h, rho_v] = calc_b_T(P, init);

Nh = init(1) + init(2) + init(3) + init(4) + init(5) + init(6);
Nv = init(9) + init(10) + init(11);

R_h = (1/(P.gamma_h +P.mu_h)) * P.beta_h * (b_t/Nv) * (P.theta1 + P.theta2);
R_v = (1/(P.nu_v + P.mu_v)) * (P.nu_v/P.mu_v) * P.beta_v * (b_t/Nh);

R0 = sqrt(R_v * R_h);

end