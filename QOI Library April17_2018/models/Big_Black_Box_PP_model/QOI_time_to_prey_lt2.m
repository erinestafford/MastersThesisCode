function time_lt2 = QOI_time_to_prey_lt2(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: time prey population less lan critical value
time_lt2 = -999;

for i =1:length(ode_soln.y(2,:))
    if (ode_soln.y(2,:) <= 2)
        time_lt2 = ode_soln.x(i)
        
    end
end


end