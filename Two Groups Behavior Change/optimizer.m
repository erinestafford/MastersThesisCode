function [ op_param, fval, grad, hes ] = optimizer(obj_fn, lb, ub, params)
%OPTIMIZER ...

names = fieldnames(params);

options = optimset('Algorithm','sqp'); % we think we like sqp, but we aren't sure.

init_parray = (ub+lb)/2; % this could be an input / randomized

[parray, fval, ~,~,~,grad, hes] = fmincon(obj_fn, init_parray, [],[],[],[], lb, ub, [], options);

op_param = array2struct(parray, names); 

end
