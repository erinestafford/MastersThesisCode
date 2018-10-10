%------------------------------------------- QOI_DEFINE_DEFAULT_PARAMETERS


function str = QOI_define_default_params(str)
%% QOI_define_default_params initialize the structure str.* with the default 
% values. 

% input: str is a structure where str.data defines the problem

% output:
% all other values for the structure str.  See below

str.verbose =1;% =1 (true) for verbose printing mode to print the results of the key analysis steps

%% Define default labels for plots
str.POI_names =  {'P1', 'P2', 'P3', 'P4', 'P5','P6'};% Default POI labels
str.QOI_names =  {'Q1', 'Q2', 'Q3', 'Q4', 'Q5','Q6'};% Default QOI labels
str.linespec={'-k','-.b','--r',':g','-m','-.c','--k',':k'};% Default line types

%% POI descriptors  % later set these to appropiate values for built in models
str.POI_baseline(1)=1.0;
str.POI_min(1)=1.0;
str.POI_max(1)=1.0;
str.POI_mode=str.POI_baseline;
str.POI_pdf='triangle';% uniform triangle beta
str.POI_constraints=@POI_constraints; % name of POI constraint function
str.nPOI=1;

%% define the functions to evaluate the model and parameters
str.QOI_model_eval=@str.QOI_model_eval;% model

%% ---- ODE solver parameters used by  solver
str.ode_solver=@ode45;% MATLAB ODE solver  'ode45'  'ode113'  'ode23tb'
str.ode_function=@ode_derivative;% name of function defining time derivatives
str.ode_opts = odeset('RelTol',1e-5,'AbsTol',1e-7);% ode solver options


%% DEFINE THE FUNCTION HANDLES
% set function handles for each step of the process.  These can be set to a
% users code instead of the default codes.  If the handle =@none;%
%  this step will be skipped
str.QOI_pre_analysis=@QOI_pre_analysis ;%
str.QOI_LSA=@QOI_LSA;
str.QOI_ESA=@QOI_ESA;
str.QOI_GSA=@QOI_GSA;
str.QOI_post_analysis=@none;% @QOI_post_analysis ;%

%% LOCAL SENSITIVITY  PARAMETERS
% later might add the number of digits in the LaTeX table 
str.LSA_LaTeX_filename='sens_matrix.tex';

%% EXTENDED SENSITIVITY  PARAMETERS
str.number_ESA_samples=11; % number of samples for each one-at-a-time ESA

%% GLOBAL INDENTIFIAILITY PROFILE PARAMETERS
str.number_GSA_samples=201;%  % number of samples for global sensitivity analysis
str.sampler_GSA=@sobol; % rand sobol halton

end
