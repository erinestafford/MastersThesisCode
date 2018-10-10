function min_pred = QOI_min_pred(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: max prey in time period

min_pred=min(ode_soln.y(1,:));

end