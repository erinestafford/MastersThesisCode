function  main_chikv_hbc_model
% set the path for the current directory and subdirectories (this needs to
% be run the first time the code is executed.
restoredefaultpath ;prefix = mfilename('fullpath');
dirs = regexp(prefix,'[\\/]');addpath(genpath(prefix(1:dirs(end))))

clear global ; clf; format shortE; close all;  % close previous sessions
set(0,'DefaultAxesFontSize',18);set(gca,'FontSize',18);close(gcf); % increase font size
rng(101); % set the random number generator seed for reproducibility
global str 

str.data='chikv';%  poly  'PP model'
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

str.evaluate_model=@evaluate_chikv_hbc_model; % name of the function to fit the data
str.ode_function=@ode_chikv_hbc;
str.cross_validation_analysis=@none;%cross_validation_analysis;

str.plabel =  {'\theta_2','\pi_1', '\pi_2','init', 'K_v'}; % Default labels
str.noise_sd=0.05; % additive noise standard deviation for generated data
str.tend = 300;
str.tbeg = 0;
str.nbootstrap=20;% number of bootstrap samples

str.psol=[0.7,0.6,.8,4, 1100]'; % initial guess at the solution for the parameters
str.ub = [1,1, 1,10, 1500]';
str.lb = [0.1,0.1, 0.1,0, 900]';
str.p0=(str.ub+str.lb)/2; % initial guess at the solution (=psol for initial testing)
str.pref=str.psol; % reference solution for regularization is initial guess
str.wpref = ones(size(str.psol)); % default weights for regularization.
str.profile_range= 2.0000e-02;
str.min_method='lsqnonlin';% chikv_optimize lsqnonlin  fminunc  MPP NL minimization program
str.regularize = 'regularize';
str.lambda = 0.8;
end

function [ydata_fit,zsol_fit, R0] = evaluate_chikv_hbc_model(p,tdata,str)
% EVALUATE_MODEL User routine to evaluate the model at the data points
% and generate the fitted approximations to the observable data

ntdata=length(tdata);
[tsol,zsol_fit, R0] = balance_and_solve_chikv(tdata, p, str);
if length(tsol) ~= length(tdata)% check of ODE solver was successful
    warning('ODE solver failed to reach the final time. Augmenting solution with zeros')
    [nt, nz] = size(zsol_fit); zsol_fit=[zsol_fit;zeros(length(tdata)-nt,nz)];
    keyboard 
end

ydata_fit=[zsol_fit(:,7)+zsol_fit(:,8)]; % variables observed
%ydata_fit=zsol_fit; % only observe all variables

end
