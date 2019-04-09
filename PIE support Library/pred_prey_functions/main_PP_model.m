function main_PP_model

% set the path for the current directory and subdirectories (this needs to
% be run the first time the code is executed.
restoredefaultpath ;prefix = mfilename('fullpath');
dirs = regexp(prefix,'[\\/]');addpath(genpath(prefix(1:dirs(end))))

clear global ; clf; format shortE; close all;  % close previous sessions
set(0,'DefaultAxesFontSize',18);set(gca,'FontSize',18);close(gcf); % increase font size
rng(101); % set the random number generator seed for reproducibility
global str 

str.data='PP model';%  poly  'PP model'
str.model=str.data;

% Define the problem by defining the structure array str.*
% str.data = poly polysum linear harmonic1 harmonic2 harmonic3 - built in
str= define_default_params(str); % set the default paramter values
str= change_default_params(str); % user code to change the default paramter values

%  fit the data and analyze the fit
estimate_parameters; % str passed through global (will fix later)

end



function str= change_default_params(str)
%% CHANGE_PROBLEM_DEFAULTS  sub for user routine to change the default values

str.evaluate_model=@evaluate_PP_model; % name of the function to fit the data
str.ode_function=@ode_preditor_prey;
str.cross_validation_analysis=@none;%cross_validation_analysis;

str.plabel =  {'\alpha', '\beta','\delta', '\gamma'}; % Default labels
str.noise_sd=0.05; % additive noise standard deviation for generated data

str.nbootstrap=20;% number of bootstrap samples

str.z0=[1,2]; % initial conditions for differential equation model
str.psol=[10,5,2,1]'; % parameters used to define the data
str.lb = [];
str.ub = [];
str.p0=str.psol; % initial guess at the solution for the parameters
str.p0=0.99*str.psol ; % initial guess at the solution (=psol for initial testing)

str.pref=str.p0; % reference solution for regularization is initial guess
str.wpref = ones(size(str.psol)); % default weights for regularization.

end

function [ydata_fit,zsol_fit] = evaluate_PP_model(p,tdata,str)
% EVALUATE_MODEL User routine to evaluate the model at the data points
% and generate the fitted approximations to the observable data


ntdata=length(tdata);
z0=str.z0; % initial conditions are given
[tsol,zsol_fit] = str.ode_solver(str.ode_function, tdata, z0,str.ode_opts,str,p); % ode45 ode113 ode23tb

if length(tsol) ~= length(tdata)% check of ODE solver was successful
    warning('ODE solver failed to reach the final time. Augmenting solution with zeros')
    [nt, nz] = size(zsol_fit); zsol_fit=[zsol_fit;zeros(length(tdata)-nt,nz)];
    keyboard 
end

% ydata_fit=[zsol_fit(:,1)]; % only observe first variable
ydata_fit=zsol_fit; % only observe all variables

end
