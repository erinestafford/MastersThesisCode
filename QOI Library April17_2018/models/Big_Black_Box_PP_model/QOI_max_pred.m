function max_pred = QOI_max_pred(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: max prey in time period

max_pred=max(ode_soln.y(1,:));

end