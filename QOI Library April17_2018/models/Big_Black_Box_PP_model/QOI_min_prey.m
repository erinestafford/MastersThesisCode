function min_prey = QOI_min_prey(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: max prey in time period

min_prey=min(ode_soln.y(2,:));

end