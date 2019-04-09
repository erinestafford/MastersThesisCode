function [val_real] = obj_fn(param_array, data, array_names, t_in,wydata)
%chik_obj_fn returns the value that the objective function optimizes over

params = array2struct(param_array, array_names); 
params.theta1 = 1-params.theta2;
new_init = get_init_conditions(params, t_in);
[~,Y] = balance_and_solve(t_in, new_init, params); 
c = 1.00001 - calc_R0(params, new_init);
val_real = cmp_real_model(Y, data,wydata);


 
%forces optimizer to run over smooth curve when R0 < 1.5 by multiplying by 
%the distance from minimum R0 
if max(Y(:,7) + Y(:,8)) <= (new_init(7) + new_init(8))
     val_real = val_real* (10+c);
  
end

end