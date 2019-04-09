function dzdt = ode_preditor_prey(~,z,str,p)
%% ode_derivative  compute the time derivative for the ODE str.data
% str = structure for the data for the problem
% p = parameters for problem 

dzdt=NaN(size(z));

% preditor-prey equations
dzdt(1)=p(1)*z(1) - p(2)*z(2)*z(1);
dzdt(2)=p(3)*z(2)*z(1) - p(4)*z(2);

end
