function total_infected = QOI_total_infected_final_time(POIs, old_soln)
% input: POIs and old_soln structure from ode solver
% output: return the final number of people who have been infected
% by the end of the calculation

total_infected = old_soln.y(2,end)+old_soln.y(3,end);

end
