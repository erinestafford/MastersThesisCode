function [val_real] = obj_fn(param_array, data, array_names, t_in, init)
%chik_obj_fn returns the value that the objective function optimizes over

params = array2struct(param_array, array_names); 
params.theta1 = 1-params.theta2;
%params.H0 = params.theta0*params.H0;
new_init = get_init_conditions(params, t_in);
c = 1.00001 - calc_R0(params, new_init);
[~,Y] = balance_and_solve(t_in, new_init, params); 
val_real = cmp_real_model(Y, data);


 
%forces optimizer to run over smooth curve when R0 < 1.5 by multiplying by 
%the distance from minimum R0 
if c>0
     val_real = val_real* (1+c);
  
end

end