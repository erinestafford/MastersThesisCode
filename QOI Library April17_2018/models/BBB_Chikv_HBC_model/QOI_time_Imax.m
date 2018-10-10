function time_Imax = QOI_time_Imax(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: time the epidemic peaks

[~,index]=max(ode_soln.y(2,:) + ode_soln.y(3,:));
time_Imax = ode_soln.x(index);

end