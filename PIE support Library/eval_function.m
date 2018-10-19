
%------------------------------------------- EVAL_FUNC


function func = eval_function(p)
%% EVAL_FUNC  evaluate the multivariate function to be minimized
% for nonlinear least-squares problems the func = R'*R where R is the residual array

% input:
% p = where the function is to be evaluated, dimension  p(ndim)
% output:
% func = scalar function value

% using global since some derivative and optimization routines don't  pass the parameters to the function
global tdata ydata str

[residuals, ~] = str.eval_residual(p,tdata,ydata,str); % compute the residuals
res2=0.5*residuals.*residuals;
func=sum(res2(:)); % form the mean square error of the residuals

end
