function [init] = get_init_conditions(P, t)
%CHIK_INIT_CONDITIONS Given tspan, return desired initial conditions

init = ...
   [P.H0 * P.theta1 - (P.init_cumulative_infected * P.theta1),
    P.H0 * P.theta2 - (P.init_cumulative_infected * P.theta2),
    P.init_cumulative_infected * P.theta1,
    P.init_cumulative_infected * P.theta2,
    0,
    0,
    P.init_cumulative_infected * P.theta1,
    P.init_cumulative_infected * P.theta2,
    P.K_v,
    0,
    0];
end