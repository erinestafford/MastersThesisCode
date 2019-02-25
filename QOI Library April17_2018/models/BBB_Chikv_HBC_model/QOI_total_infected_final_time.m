function total_infected = QOI_total_infected_final_time(soln)
% input: POIs and old_soln structure from ode solver
% output: return the final number of people who have been infected
% by the end of the calculation

total_infected = soln.y(7,end)+soln.y(8,end);

end
