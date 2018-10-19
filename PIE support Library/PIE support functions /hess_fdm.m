function [hess] = hess_fdm(x,f)
%% HESS finite difference approximation of the hessian of f at x
% usage: [grad] = hess_fdm(x,@f)

% input:
% x is an n dimensional column vector
% @f is the function handle mapping R^n to R^1
%
% output:
% hess is the nxn dimensional matrix of partial derivatives
% e.g. in 2 dimensions hess = [f_xx fxy ; f_yx fyy]

nxvar = length(x);
hess = NaN(nxvar,nxvar);
dx = 1.e-3; % dimensional delta x
xdiff=x;

for ix=1:nxvar
    xdiff(ix) = x(ix)+ dx;
    [gradp] = grad_fdm(xdiff,f);
    xdiff(ix)=x(ix)-dx;
    [gradm] = grad_fdm(xdiff,f);
    hess(:,ix)=(gradp-gradm)/(2*dx);
    xdiff(ix)=x(ix);
end


% can you also return the gradient
% grad=0.5*(gradp+gradm);
end