function [hess] = hess_fdm(X,func,mord,atol)
% finite difference approximation of the hessian of func at X
% **** this routine needs to be fully debugged and optimized for fewer function evaluaitons****

% input:
% X is an n dimensional column vector
% func is the function handle mapping R^n to R^1
% mord = 2 second order is all that is currently available
% atol = estimate of the accuracy of func
% ****** note mord and atol not implimented yet ******
%
% output:
% hess is the nxn dimensional matrix of partial derivatives
% e.g. in 2 dimensions hess = [f_xx fxy ; f_yx fyy]

nx = length(X);
hess = NaN(nx,nx);
dx = 1.e-6; % dimensional delta X
xdiff=X;

for ix=1:nx
    xdiff(ix) = X(ix)+ dx;
    [gradp] = grad_fdm(xdiff,func,2,eps);
    xdiff(ix)=X(ix)-dx;
    [gradm] = grad_fdm(xdiff,func,2,eps);
    hess(:,ix)=(gradp-gradm)/(2*dx);
    xdiff(ix)=X(ix);
end

% needs to be debuged to reduce the number of function calls
% fails for cross derivatives (wrong dx) 
% gradp = NaN(size(X));gradm = NaN(size(X));xsave=X;
% for iy=1:nx
%     
%     xdiff(iy) = X(iy)+ dx;
%     fc = feval(func,X);
%     for ix=1:nx
%         xgrad(ix) = xdiff(ix)+ dx;
%         fp = feval(func,xgrad);
%         gradp(ix)=(fp-fc)/dx;
%         xgrad(ix)=xdiff(ix);
%     end
%     
%     xdiff(iy) = X(iy) - dx;
%     for ix=1:nx
%         xgrad(ix) = xdiff(ix) - dx;
%         fm = feval(func,xgrad);
%         gradm(ix)=(fc-fm)/dx;
%         xgrad(ix)=xdiff(ix);
%     end
%     gradp
%     gradm
%     hess(:,iy)=(gradp-gradm)/dx
% end



end