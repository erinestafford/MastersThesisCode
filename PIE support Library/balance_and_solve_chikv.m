function [t,out, R0] = balance_and_solve_chikv(t_in, param, str)
init = get_init(str,param);
balance_init = init;
balance_init(3) = .0001;
balance_init(4) = .0001;
balance_init(7) = balance_init(3);
balance_init(8) = balance_init(4);
balance_init(1) = balance_init(1) + init(3) - balance_init(3);
balance_init(2) = balance_init(2) + init(4) - balance_init(4);


options = odeset('Events',@(t,Y)balancing_event(t, Y, init(7), init(8)));

t_balance = 100000; % how long we're willing to wait to balance
[t,Y] = output_chikv([0 t_balance],balance_init,param, str, options);
new_init = Y(end,:)';
R0 = calc_R0(new_init,param,str);
[t,out] = output_chikv(t_in, new_init, param, str, []);
end