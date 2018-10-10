function [value,isterminal,direction] = peak_infected_event(t, Y, P)
derivatives = RHS_eq_twoGroup(t,Y, P);
if ((derivatives(3) < abs(0.01))) && ((derivatives(4) < abs(0.01)))
    value = 0;
else
    value = derivatives(3); % dI/dt = 0
end
value;
isterminal = 0; % stops graph when event is triggered
direction = 1; 
