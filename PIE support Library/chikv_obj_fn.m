function [val_real] = chikv_obj_fn(p, data, t_in)
%chik_obj_fn returns the value that the objective function optimizes over

new_init = get_init_conditions(p, t_in);
[~,Y] = balance_and_solve(t_in, new_init, params); 
val_real = cmp_real_model(Y, data);



end