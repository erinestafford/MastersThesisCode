function QOIs = Big_Black_Box_SIR_model(POIs)
% This takes parameters, solves the ODE and returns desired quantities

%% Initialize ODE solver

% initial conditions for y=(Suseptible, Infected, Recovered) ) 
yzero=[0.9999 0.0001 0]';
% final integration time
tfinal = 100;nout=100; 
tspan=[0: tfinal/nout:  tfinal];

% convert the list of POIs into model variable names
beta = POIs(1);
gamma = POIs(2);

% Bake the parameters into sir_ode_rhs (aka currying)
dydt_fn = @(t,y) SIR_ODEs(t, y, beta, gamma);

%% Solve ODE
ode_soln = ode23tb(dydt_fn, tspan, yzero);

%% Return quantities to analyze
QOIs(1) = QOI_total_infected_final_time(POIs, ode_soln); % Total infected a tfinal
QOIs(2) = QOI_inf_at_fixed_time(POIs, ode_soln); % number infected at a fixed time
QOIs(3) = QOI_R0(POIs, ode_soln); % R0 for basic SIR
QOIs = QOIs'; % as col
end