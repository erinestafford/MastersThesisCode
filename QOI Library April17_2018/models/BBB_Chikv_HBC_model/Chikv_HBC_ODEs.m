function [out] = Chikv_HBC_ODEs(time, init_conditions,params)
%RHS_eq takes in the time, initial conditions and parameters of the model
%and calculates the output of the ODE equations

%% Initialize vector
out = zeros([11 1]);
%% Host
%Group1 - Low Risk, Group2 - High Risk
S_h1 = init_conditions(1);
S_h2 = init_conditions(2);
I_h1 = init_conditions(3);
I_h2 = init_conditions(4);
R_h1 = init_conditions(5);
R_h2 = init_conditions(6);
%% Vectors
S_v = init_conditions(9);
E_v = init_conditions(10);
I_v = init_conditions(11);


%% Calculate Biting Rates
%biting rates desired for hosts and vectors
b_hw1 = params.sigma_h1 * S_h1 + params.sigma_h1 * params.pi1 * I_h1 + params.sigma_h1 * R_h1;
b_hw2 = params.sigma_h2 * S_h2 + params.sigma_h2 * params.pi2 * I_h2 + params.sigma_h2 * R_h2;
b_hw = b_hw1 + b_hw2;
b_vw = params.sigma_v * S_v + params.sigma_v * E_v + params.sigma_v * I_v;

%total bites
b_t = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_t/b_hw;
rho_v = b_t/b_vw;
%% Equations
N_h1 = S_h1 + I_h1 + R_h1;
N_h2 = S_h2 + I_h2 + R_h2;
N_h = N_h1 + N_h2;
N_v = S_v + E_v + I_v;
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

out(1) = Y(1);
out(2) = Y(2);
out(3) = Y(3);
out(4) = Y(4);
out(5) = Y(5);
out(6) = Y(6);
out(7) = Y(7);
out(8) = Y(8);
out(9) = Y(9);
out(10) = Y(10);
out(11) = Y(11);
end

