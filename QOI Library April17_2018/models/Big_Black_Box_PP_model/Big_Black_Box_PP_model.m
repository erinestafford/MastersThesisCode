function QOIs = Big_Black_Box_PP_model(POIs)
% This takes parameters, solves the ODE and returns desired quantities

%% Initialize ODE solver

% initial conditions for y=(predators, prey)
yzero=[2,3]';
% final integration time
tfinal = 20;nout=20; 
tspan=[0: tfinal/nout:  tfinal];

% convert the list of POIs into model variable names
alpha = POIs(1);
beta = POIs(2);
gamma = POIs(3);
delta = POIs(4);
% Bake the parameters into sir_ode_rhs (aka currying)
dydt_fn = @(t,y) PP_ODEs(t, y, alpha, beta, gamma, delta);

%% Solve ODE
ode_soln = ode23tb(dydt_fn, tspan, yzero);
plot(ode_soln.x,ode_soln.y)
%% Return quantities to analyze
QOIs(1) = QOI_max_pred(POIs, ode_soln); % max predator population
QOIs(2) = QOI_max_prey(POIs, ode_soln); %max prey population
QOIs(3) = QOI_min_prey(POIs, ode_soln);
QOIs(4) = QOI_min_pred(POIs, ode_soln);
QOIs = QOIs';
end