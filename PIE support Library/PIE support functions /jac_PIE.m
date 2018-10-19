function [jac] = jac_PIE(x,f)
%% Jacobian finite difference approximation of the jacient of the multivaruate f at x
% usage: [jac] = jac_fdm(x,@f)
%
% input:
% x is an n dimensional column vector
% @f is the function handle mapping R^n to R^m
%
% output:
% jac is the n X m dimensional matrix of partial derivatives
% e.g.  jac_ij = df_i/dx_j
global tdata ydata str

fp = f(x,tdata,ydata,str);

nxvar = length(x);
[ntdim,nydim]= size(fp);
nfvar=ntdim*nydim;

jac = NaN(nfvar,nxvar);
dx = 1.e-3; % dimensional delta x
xdiff=x;
for ix=1:nxvar
    xdiff(ix) = x(ix)+ dx;
    fp = f(xdiff,tdata,ydata,str);
    xdiff(ix)=x(ix)-dx;
    fm = f(xdiff,tdata,ydata,str);
    der=(fp-fm)/(2.0*dx);

    % reshape residuals if necessary
    if nydim==1
    jac(:,ix)=der;
    else
     jac(:,ix)=reshape(der,nfvar,1);   
    end
    
end
end