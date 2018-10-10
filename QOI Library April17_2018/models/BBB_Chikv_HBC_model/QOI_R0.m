function R0 = QOI_R0(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: Reproductive number

%% Params
beta_h = 0.24;
beta_v = 0.24;
gamma_h = 1/6;
mu_h= 1/(70*365);
mu_v =  1/17;
nu_v= 1/11;
sigma_h1 =  10; %low risk contacts
sigma_h2 =  30; %high risk contacts
sigma_v =  0.5;
theta2 = POIs(1);% proportion of population in group 2 - high risk
theta1 = 1 - theta2;%proportion of population in group 1 - low risk
pi1 = POIs(4);
pi2 = POIs(5);


init = ode_soln.y(:,1);

%% Calculate Biting Rates
%biting rates desired for hosts and vectors
b_hw1 = sigma_h1 * init(1) + sigma_h1 * pi1 * init(3) + sigma_h1 * init(5);
b_hw2 = sigma_h2 * init(2) + sigma_h2 * pi2 * init(4) + sigma_h2 * init(6);
b_hw = b_hw1 + b_hw2;
b_vw = sigma_v * init(7) + sigma_v * init(8) + sigma_v * init(9);

%total bites
b_T = (b_hw * b_vw)/(b_hw + b_vw);

%% R0 for model
Nh = init(1) + init(2) + init(3) + init(4) + init(5) + init(6);
Nv = init(7) + init(8) + init(9);

R_h = (1/(gamma_h +mu_h)) * beta_h * (b_T/Nv) * (theta1 + theta2);
R_v = (1/(nu_v + mu_v)) * (nu_v/mu_v) * beta_v * (b_T/Nh);

R0 = sqrt(R_v * R_h);

end
