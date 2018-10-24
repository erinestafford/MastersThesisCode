function [value,isterminal,direction] = balancing_event(t, Y, init7, init8)
%CHIK_BALANCING_EVENT event halting at when reaching initial infected
% infected at desired level
if abs((Y(7) + Y(8)) - (init7 + init8)) < 0.01
    value = 0;
else
    value = (Y(7) + Y(8)) - (init7 + init8); % dI/dt = 0
end
isterminal = 1; % stops graph when event is triggered
direction = 1; 
end