
function estimate_parameters
%% TEST_NONLINEAR_FIT for ODE parameter identifiability and estimation
%  February 20, 2018 Mac Hyman (last edit)
%
% This is an environment for using nonlinear least-squares (NLS) to fit an
% ordinary differential equation (ODE) model to data.  The functions are in
% the parameter identification and estimation (PIE) library.

%% Program for data analysis using linear regression.
% 1. Define the problem by defining the structure array str.*
% 2. read or generate the observational data (and solution if available)
% 3. analyze the problem setup, plot the data
% 4. fit the data by minimizing the residuals using a nonlinear solver
% 5. analyze the residuals for goodness of fit
% 6. estimate uncertainty in parameter estimates (bootstrap)
% 7. best parameter selection (cross-validation)
% 8. determine the local identifiability analysis of the parameters (Hessian analysis)
% 9. extended identifiability analysis of the parameters (profile analysis)
% 10. global identifiability analysis (sampling)

% 11. final analysis the problem solution

% set the path for the current directory and subdirectories (this needs to
% be run the first time the code is executed.

global tdata ydata str % global data needed for grad and Hessian function evaluations


%2. read or generate the observational data (and solution if available)
%and define problem dependent parameters, e.g. for scaling

[tdata,ydata,zsol,str]=str.obtain_data(str); % this could be a user routine
str.tdata=tdata; str.ydata=ydata; % save data for analysis

% 3. analyze the problem setup, plot the data
%  str.pre_analysis(tdata,ydata,zsol,str);

% 4. fit the data by minimizing the residuals using a nonlinear solver
[pfit,ydata_fit,residuals,errfit] = fit_data(tdata,ydata,str.p0,str);
if str.verbose; 
    disp('The pfit solution values are');
    pfit
end

% 5. analyze the residuals for goodness of fit
% [str] = str.analyze_residuals(tdata,str.ydata,ydata_fit,residuals,str);

% 6. estimate uncertainty in parameter estimates (bootstrap)
[str]=str.bootstrap_analysis(tdata,ydata,pfit,str);
%str.pfit=str.pest_mean; % add option to use mean value as the solution 

% 7. best parameter selection (cross-validation)
[CVindex,CVtrainMSE,CVtestMSE]=str.cross_validation_analysis(tdata,ydata,pfit,str);

% 8. determine the local identifiability analysis of the parameters (Hessian analysis)
% [eig_vec_Sidentifable, GRAD, HESS, SV_HESS, V] = str.local_identifiability(pfit,str);

% 9. extended identifiability analysis of the parameters (profile analysis)
% [p_range, res_profile]=str.extended_identifiability(tdata,str.ydata,pfit,errfit,str);

% % % 10. global identifiability analysis (sampling)
% [psfit,fsfit]=str.global_identifiability(tdata,str.ydata,pfit,errfit,str);
% 

% % 11. final analysis the problem solution
% [diff_sol] = str.post_analysis(tdata,ydata,zsol,pfit,str);

end

