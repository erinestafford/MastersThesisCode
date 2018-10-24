function [out] = Chikv_HBC_ODEs(time, init_conditions, theta2, theta1,init_cumulative_infected,K_v,pi1, pi2, H0)
%RHS_eq takes in the time, initial conditions and parameters of the model
%and calculates the output of the ODE equations

%% Declare needed params
%other params
beta_h = 0.24;
beta_v = 0.24;
gamma_h = 1/6;
mu_h= 1/(70*365);
nu_h =  1/3;
psi_v =  0.3;
mu_v =  1/17;
nu_v= 1/11;
sigma_h1 =  10; %low risk contacts
sigma_h2 =  30; %high risk contacts
sigma_v =  0.5;
theta0 = .8; % no risk group
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
b_hw1 = sigma_h1 * S_h1 + sigma_h1 * pi1 * I_h1 + sigma_h1 * R_h1;
b_hw2 = sigma_h2 * S_h2 + sigma_h2 * pi2 * I_h2 + sigma_h2 * R_h2;
b_hw = b_hw1 + b_hw2;
b_vw = sigma_v * S_v + sigma_v * E_v + sigma_v * I_v;

%total bites
b_t = (b_hw * b_vw)/(b_hw + b_vw);
rho_h = b_t/b_hw;
rho_v = b_t/b_vw;
%% Equations
N_h1 = S_h1 + I_h1 + R_h1;
N_h2 = S_h2 + I_h2 + R_h2;
N_h = N_h1 + N_h2;
N_v = S_v + E_v + I_v;
lambda_h1 = beta_h * (I_v/N_v) * (b_t*theta1)/N_h;
lambda_h2 = beta_h * (I_v/N_v) * (b_t*theta2)/N_h;

%host1
Y(1) = (mu_h*(theta1*H0)) - (lambda_h1 * S_h1) - (mu_h*S_h1);
Y(3) = (lambda_h1 * S_h1) - (gamma_h + mu_h)*I_h1;
Y(5) = (gamma_h * I_h1) - (mu_h * R_h1);
Y(7) = (lambda_h1 * S_h1);
%host2
Y(2) = (mu_h*(theta2*H0)) - (lambda_h2 * S_h2) - (mu_h*S_h2);
Y(4) = (lambda_h2 * S_h2) - (gamma_h + mu_h)*I_h2;
Y(6) = (gamma_h * I_h2) - (mu_h * R_h2);
Y(8) = (lambda_h2 * S_h2);

%probability a host is infected
P_HI = (rho_h*(sigma_h1*pi1*I_h1 + sigma_h2*pi2*I_h2))/(b_t);
lambda_v = beta_v * P_HI * (b_t/N_v);

%vector
Y(9) = (psi_v - (psi_v - mu_v)*(N_v/K_v))*N_v - (lambda_v*S_v) - (mu_v * S_v);
Y(10) = (lambda_v* S_v) - (nu_v + mu_v) * E_v;
Y(11) = (nu_v*E_v) - (mu_v * I_v);

out(1) = Y(1);
out(2) = Y(2);
out(3) = Y(3);
out(4) = Y(4);
out(5) = Y(5);
out(6) = Y(6);
out(7) = Y(7);
out(8) = Y(8);
out(9) = Y(9); %susceptible vector
out(10) = Y(10); %exposed vector
out(11) = Y(11); %infected vector

end

