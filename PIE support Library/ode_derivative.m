
%------------------------------------------- DYDY

function dzdt = ode_derivative(~,z,str,p)
%% ode_derivative  compute the time derivative for the ODE str.data
% tdata = current time
% z = current solution
% str = struct defining the problem
% p = problem parameters being optimized

dzdt=NaN(size(z));

switch str.model
    
    case {'linearODE2'}  % fit data with the harmonic oscillator
        dzdt(1)=p(1)*z(1)+p(2)*z(2) + 1;
        dzdt(2)=p(3)*z(1)+p(4)*z(2) + 0;
        
    case {'harmonic1','harmonic2'}  % fit data with the harmonic oscillator
        dzdt(1)=z(2);
        dzdt(2)=-100*p(1)*z(1) - p(2)*z(2);
        
    case 'harmonic3' % fit data with the harmonic oscillator - includes mass
        dzdt(1)=z(2);
        dzdt(2)=-100*(p(1)/p(3))*z(1) - (p(2)/p(3))*z(2);
        
    otherwise
        error(['str.model =',str.model,' not defined'])
end

end
