function dzdt = ode_chikv_hbc(z,str,P)
%% ode_derivative  compute the time derivative for the ODE str.data
% str = structure for the data for the problem
% p = parameters for problem 

dzdt=NaN(size(z));
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
params = struct(param_struct{:});
%% Host
%Group1 - Low Risk, Group2 - High Risk
S_h1 = z(1);
S_h2 = z(2);
I_h1 = z(3);
I_h2 = z(4);
R_h1 = z(5);
R_h2 = z(6);
I_h1_c = z(7);
I_h2_c = z(8);
%% Vectors
S_v = z(9);
E_v = z(10);
I_v = z(11);

%% Equations
N_h1 = S_h1 + I_h1 + R_h1;
N_h2 = S_h2 + I_h2 + R_h2;
N_h = N_h1 + N_h2;
N_v = S_v + E_v + I_v;

%% Calc_bt
b_hw1 = params.sigma_h1 * z(1) + params.sigma_h1 * params.pi1 * z(3) + params.sigma_h1 * z(5);
b_hw2 = params.sigma_h2 * z(2) + params.sigma_h2 * params.pi2 * z(4) + params.sigma_h2 * z(6);
b_hw = b_hw1 + b_hw2;
b_vw = params.sigma_v * z(9) + params.sigma_v * z(10) + params.sigma_v * z(11);
%total bites
b_t = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_t/b_hw;
rho_v = b_t/b_vw;
b_v = b_t/rho_v;
b_h = b_t/rho_h;

lambda_h1 = params.beta_h * (I_v/N_v) * (b_t*params.theta1)/N_h;
lambda_h2 = params.beta_h * (I_v/N_v) * (b_t*params.theta2)/N_h;

%host1
Y(1) = (params.mu_h*(params.theta1*params.H0)) - (lambda_h1 * S_h1) - (params.mu_h*S_h1);
Y(3) = (lambda_h1 * S_h1) - (params.gamma_h + params.mu_h)*I_h1;
Y(5) = (params.gamma_h * I_h1) - (params.mu_h * R_h1);
Y(7) = (lambda_h1 * S_h1);

%host2
Y(2) = (params.mu_h*(params.theta2*params.H0)) - (lambda_h2 * S_h2) - (params.mu_h*S_h2);
Y(4) = (lambda_h2 * S_h2) - (params.gamma_h + params.mu_h)*I_h2;
Y(6) = (params.gamma_h * I_h2) - (params.mu_h * R_h2);
Y(8) = (lambda_h2 * S_h2);

%probability a host is infected
P_HI = (rho_h*(params.sigma_h1*params.pi1*I_h1 + params.sigma_h2*params.pi2*I_h2))/(b_t);
lambda_v = params.beta_v * P_HI * (b_t/N_v);

%vector
Y(9) = (params.psi_v - (params.psi_v - params.mu_v)*(N_v/params.K_v))*N_v - (lambda_v*S_v) - (params.mu_v * S_v);
Y(10) = (lambda_v* S_v) - (params.nu_v + params.mu_v) * E_v;
Y(11) = (params.nu_v*E_v) - (params.mu_v * I_v);

dzdt(1) = Y(1);
dzdt(2) = Y(2);
dzdt(3) = Y(3);
dzdt(4) = Y(4);
dzdt(5) = Y(5);
dzdt(6) = Y(6);
dzdt(7) = Y(7);
dzdt(8) = Y(8);
dzdt(9) = Y(9);
dzdt(10) = Y(10);
dzdt(11) = Y(11);
end