%------------------------------------------- EVALUATE_MODEL


function [ydata_fit,zsol_fit] = evaluate_model(p,tdata,str)
% EVALUATE_MODEL User routine to evaluate the model at the data points
% and generate the fitted approximations to the observable data
%
% input:
% p column array of parameter values
% tdata column array of 'times' associated with parameter values
% str stucture with parameters describing the model
%
% output:
% ydata_fit column array of the data evaluated at the 'times'.
%     This data is a function of the model solution
% zsol_fit column array of the model evaluated at the 'times'
% str the structure array can be used for output to define model parameters

ntdata=length(tdata);
switch str.model
    
    case 'poly' % fit a polynomial through the data
        zsol_fit =  p(1) + p(2)*tdata + p(3)*tdata.^2;
        ydata_fit=zsol_fit;
    case 'polysum' % nonidentifiability sum test
        zsol_fit =  p(1)+(p(2) + p(3))*tdata;
        ydata_fit=zsol_fit;
    case 'polyprod'% nonidentifiability product test
        zsol_fit =  p(1)+(p(2)*p(3))*tdata;
        ydata_fit=zsol_fit;
        
    case 'linear' % fit a polynomial linear regression through the data
        
        if ~isfield(str, 'A')  % Generate design matrix on first call
            ndegree=str.model2; % degree of the polynomial
            str.A=ones(ntdata,ndegree+1);% the design matrix of monomial basis functions
            for ic=1:ndegree
                str.A(:,ic+1)=tdata.^ic;
            end
        end
        
        zsol_fit=str.A*p; % linear model
        ydata_fit=zsol_fit;  % observed data is the solution
        
    case 'linearODE2' % fit a 2d linear ODE model
        z0=str.z0; % initial conditions are given
        [~,zsol_fit] = str.ode_solver(str.ode_function, tdata, z0,str.ode_opts,str,p); % ode45 ode113 ode23tb
        ydata_fit=zsol_fit(:,1); %  observe first variable
        %         ydata_fit=zsol_fit(:,1)-zsol_fit(:,2); %  observe first variable
        %         ydata_fit=[zsol_fit(:,1);zsol_fit(:,2)]; % observe both variables
        
    case {'harmonic1'} % harmonic oscillator problems
        z0=str.z0; % initial conditions are given
        [~,zsol_fit] = str.ode_solver(str.ode_function, tdata, z0,str.ode_opts,str,p); % ode45 ode113 ode23tb
        ydata_fit=zsol_fit(:,1); % only observe first variable
        
    case {'harmonic2'} % harmonic oscillator problems z0(1) is unknown
        z0=str.z0;z0(1)=p(3); % initial conditions for z0(1) is unknown
        [~,zsol_fit] = str.ode_solver(str.ode_function, tdata, z0,str.ode_opts,str,p); % ode45 ode113 ode23tb
        ydata_fit=zsol_fit(:,1); % only observe first variable
        
    case {'harmonic3'} % harmonic oscillator problems with mass
        z0=str.z0; % initial conditions are fixed
        [~,zsol_fit] = str.ode_solver(str.ode_function, tdata, z0,str.ode_opts,str,p); % ode45 ode113 ode23tb
        ydata_fit=zsol_fit(:,1); % only observe first variable
    otherwise
end

end