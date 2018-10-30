function R0 = calc_R0(init,P)
%CHIK_CALC_R0 Given params and t0, return what would be R_0 at t_0
param_struct = ...
    {'beta_h', 0.24;
     'beta_v', 0.24;
     'gamma_h', 1/6;
     'mu_h', 1/(70*365);
     'nu_h', 1/3;
     'psi_v', 0.3;
     'mu_v', 1/17;
     'nu_v', 1/11;
     'sigma_h1', 10; %low risk contacts
     'sigma_h2', 30; %high risk contacts
     'sigma_v', 0.5;
     'H0', 10000;
     'theta1', 1-P(1); %proportion of population in group 1 - low risk
     'theta2', P(1);% proportion of population in group 2 - high risk
     'theta0', .8; % no risk group
     'init_cumulative_infected', 20;
     'K_v' , 100000;
     'pi1', P(2); %proportion that continues to be bitten in infected group 1
     'pi2', P(3); %proportion that continues to be bitten in infected group 2
    }';
P = struct(param_struct{:});
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