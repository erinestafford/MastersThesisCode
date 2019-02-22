%------------------------------------------- EVAL_RESIDUAL

function [residuals,ydata_fit] = eval_residual(p,tdata,ydata,str)
% EVAL_RESIDUAL compute the residuals for the NL least squares problem

% input:
% p = multidimensional input - dimension p(npvar)
% tdata = array of times for the residual
% ydata(ntdata,nzdim) = reference solution needed for computing the residual
% str = structure defining the methods used, see the function define_default_params(str)
% str.remove_index = index of frozen variable when doing leave-one-out
%     profile analysis
% str.regularization = name of regularization to be used = none, ridge
% str.lambda_scaled = scaled regularization parameter - see define_problem(str)

% output:
% residuals = residual array =ydata - ydata_fit of the difference between
%    the data points and the fit points.  If there is no additional regularization,
%    the the residuals have dimension dimension (nydata,nydim).  When there is regularization,
%    then the regularization residuals are added to the end of the array and it
%    is now dimension (nydata+npvar,1)

% ydata_fit = the model values at the observational data

% When the leave-one-out profile analysis, the variable str.remove_index is frozen.
% The optimization routines optimize over all of the variables, so this forzen
% variable needs to be removed before calling the optimizer.
% It will then be added back in when evaluating the model.

if str.remove_index > 0 % add parameter back in when doing profile analysis
    p = [p(1:str.remove_index-1) ; str.remove_xvalue ; p(str.remove_index:end)];
end

[ydata_fit,~] = str.evaluate_model(p,tdata,str); % evaluate the model
residuals = str.wydata.*(ydata-ydata_fit);


% add a regularization term, if it is called for
switch str.regularize
    case 'none'
    case 'regularize'
        residuals = [(1-str.lambda).*residuals;str.lambda*str.wpref.*(p-str.pref)];
    otherwise
        error(['str.regularize not recognized',str.regularize])
end

end