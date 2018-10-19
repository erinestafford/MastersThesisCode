function [grad] = grad_fdm(x,f)
%% GRAD finite difference approximation of the gradient of f at x
% usage: [grad] = grad_fdm(x,@f)
%
% input:
% x is an n dimensional column vector
% @f is the function handle mapping R^n to R^1
%
% output:
% grad is the n dimensional column vector of partial derivatives
% e.g.  grad = [f_x; f_y; f_z; ...]

nxvar = length(x);
grad = NaN(size(x));
dx = 1.e-3; % dimensional delta x
xdiff=x;
for ix=1:nxvar
    xdiff(ix) = x(ix)+ dx;
    fp = feval(f,xdiff);
    xdiff(ix)=x(ix)-dx;
    fm = feval(f,xdiff);
    grad(ix)=(fp-fm)/(2.0*dx);
    xdiff(ix)=x(ix);
end
end