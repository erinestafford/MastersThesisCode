%------------------------------------------- DEFINE_MODEL


function [str] = define_default_model(str)
% DEFINE_DEFAULT_MODEL define the parameters for the built-in default models
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


switch str.data
    case 'read'
        if ~isfield(str, 'data2') % define the name of the data file, if not provided
            str.data2='data_file.txt';
        end %
        
    case {'poly', 'polysum' ,'polyprod'}
        str.psol=[1.0 ; 2.0;  3.0];
        
    case 'linear'
        str.psol=linspace(1,str.data2+1,str.data2+1)';
        
        
        
    case 'linearODE2' % fit a 2d linear ODE model
        str.z0=[1,0]; % initial conditions
        str.psol=[1 2 -4 1]' ;
        str.plabel =  {'A11', 'A12', 'A21', 'A22'};
        
    case 'harmonic1' % harmonic oscillator initial conditions given
        str.z0=[1,0]; % initial conditions
        str.psol=[2.0; 2.0];
        
    case 'harmonic2' % harmonic oscillator initial conditions y(1) = parameter
        str.z0=[1,0]; % initial conditions to generate data
        str.psol=[1.0; 2.0; 2.0];
        
    case 'harmonic3' % nonidentifiable harmonic oscillator  (has mass)
        str.z0=[1,0]; % initial conditions
        str.psol=[2.0; 2.0; 2.0];
        
    otherwise
        % user must supply the default parameters
end


end

