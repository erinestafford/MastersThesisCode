function QOIs = BBB_Chikv_HBC_model(POIs)
% This takes parameters, solves the ODE and returns desired quantities

%% Initialize ODE solver
% convert the list of POIs into model variable names
% POIs will be same parameters as being optimized
params = get_p_struct(POIs);

% initial conditions for y=(S1_h, S2_h, I1_h, I2_h, R1_h, R2_h, S_v, E_v, I_v) )
yzero=get_init(params);
% final integration time
tfinal = 100;nout=100; 
tspan=0: tfinal/nout:  tfinal;

% Bake the parameters into ode_rhs (aka currying)
yzero = balance_model(yzero, params);
dydt_fn = @(t,y) Chikv_HBC_ODEs(t, y, params);

%% Solve ODE
ode_soln = ode45(dydt_fn, tspan, yzero);
%% Return quantities to analyze
QOIs(1) = QOI_total_infected_final_time(ode_soln); % Total infected a tfinal
QOIs(2) = QOI_R0(params); 
QOIs(3) = QOI_Reff(params); 
QOIs = QOIs'; % as col
end