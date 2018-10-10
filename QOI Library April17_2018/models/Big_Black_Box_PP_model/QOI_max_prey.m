function max_prey = QOI_max_prey(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: max prey in time period

max_prey=max(ode_soln.y(2,:));

end