function [new_init] = balance_model(init, theta2, theta1,init_cumulative_infected,K_v,pi1, pi2, H0)

balance_init = init;
balance_init(3) = .0001;
balance_init(4) = .0001;
balance_init(7) = balance_init(3);
balance_init(8) = balance_init(4);
balance_init(1) = balance_init(1) + init(3) - balance_init(3);
balance_init(2) = balance_init(2) + init(4) - balance_init(4);


options = odeset('Events',@(t,Y)balancing_event(t, Y, init(7), init(8)));

t_balance = 100000; % how long we're willing to wait to balance
dydt_fn = @(t,y) Chikv_HBC_ODEs(t, y, theta2, theta1,init_cumulative_infected,K_v,pi1, pi2, H0);
Y = ode45(dydt_fn, [0 t_balance], balance_init, options);
new_init = Y.y(:,end);
end