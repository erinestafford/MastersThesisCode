function QOIs = BBB_Chikv_HBC_model(POIs)
% This takes parameters, solves the ODE and returns desired quantities

%% Initialize ODE solver
% convert the list of POIs into model variable names
% POIs will be same parameters as being optimized
theta2 = POIs(1);% proportion of population in group 2 - high risk
theta1 = POIs(2);%proportion of population in group 1 - low risk
init_cumulative_infected = POIs(3);
K_v = POIs(4);
pi1 = POIs(5);
pi2 = POIs(6);
H0 =  POIs(7);

% initial conditions for y=(S1_h, S2_h, I1_h, I2_h, R1_h, R2_h, S_v, E_v, I_v) )
yzero=[H0 * theta1 - init_cumulative_infected*theta1,
    H0 * theta2 - init_cumulative_infected*theta2,
    init_cumulative_infected * theta1,
    init_cumulative_infected * theta2,
    0,
    0,
    init_cumulative_infected * theta1,
    init_cumulative_infected * theta2,
    K_v,
    0,
    0];
% final integration time
tfinal = 100;nout=100; 
tspan=[0: tfinal/nout:  tfinal];

% Bake the parameters into ode_rhs (aka currying)
yzero = balance_model(yzero, theta2, theta1,init_cumulative_infected,K_v,pi1, pi2, H0);
dydt_fn = @(t,y) Chikv_HBC_ODEs(t, y, theta2, theta1,init_cumulative_infected,K_v,pi1, pi2, H0);

%% Solve ODE
ode_soln = ode45(dydt_fn, tspan, yzero);
%% Return quantities to analyze
QOIs(1) = QOI_total_infected_final_time(POIs, ode_soln); % Total infected a tfinal
%QOIs(2) = QOI_inf_at_fixed_time(POIs, ode_soln); % number infected at a fixed time
QOIs(2) = QOI_R0(POIs, ode_soln); % R0 for basic SIR
QOIs(3) = QOI_time_Imax(POIs, ode_soln);
QOIs = QOIs'; % as col
end