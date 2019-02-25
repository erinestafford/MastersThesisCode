function inf_at_time_tinf = QOI_inf_at_fixed_time( ode_soln)
% input: POIs and old_soln structure from ode solver
% output: number of people infected at time t=tinf

tinf=10;

% use piecewise Hermite interpolation 
inf_at_time_tinf = interp1(ode_soln.x,ode_soln.y(2,:)+ode_soln.y(3,:),tinf);

end