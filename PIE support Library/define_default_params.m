
%------------------------------------------- DEFINE_DEFAULT_PARAMETERS


function str = define_default_params(str)
%% DEFINE_PROBLEM initialize the struct str that defines the problem to be solved

% input: str is a structure where str.data defines the problem
% currently, only the values for str.data and str.data2 are input and any other
% values will be overwritten.  This will be changed in the future so that
% only the undefined variables will be changed

% output:
% all other values for the structure str.  See below

str.verbose =1; % =1 (true) for verbose printing mode to print the results of the key analysis steps

% FIRST SET DEFAULT PARAMETERS (options are listed as comments)

% str.data  % how the data is generated ('read' not implemented yet)
% 'poly' % fit a polynomial through the data
% 'polysum' % non-identifiabile sum test
% 'polyprod'% non-identifiabile product test
% 'harmonic1' harmonic oscillator frequency and damping unknown
% 'harmonic2' harmonic oscillator initial value, frequency and damping unknown
% 'harmonic3' nonidentifiable harmonic oscillator  (has mass)



%% Define default labels for plots
str.plabel =  {'P1', 'P2', 'P3', 'P4', 'P5','P6'}; % Default labels
str.linespec={'-k','-.b','-r',':g','-m','-.c','--k',':k'}; % Default line types



%% MODIFY DEFAULT PARAMETERS for different model
% (normalize problems so parameters are order 1)

[str] = define_default_model(str); % define the parameters for the model
if isfield(str, 'psol')
    str.p0=0.9*str.psol ; % initial guess at the solution (=psol for initial testing)
end

%--- for generated test (not used if the data is read from a file)
str.noise_sd=0.05; % additive noise standard deviation for generated data
str.ntdata=101; % number of times the model is sampled
str.ntdata=str.ntdata; % number of sample data points to be fit
str.tbeg=0.0; str.tend=1.0; % beginning and end points for generated data

%% DEFINE THE FUNCTION HANDLES
% set function handles for each step of the process.  These can be set to a
% users code instead of the default codes.  If the handle =@none;%
%  this step will be skipped

str.obtain_data=@obtain_data;%
str.define_default_model=@define_default_model; % name of the model to define the data
str.evaluate_model=@evaluate_model; % name of the function to fit the data

str.pre_analysis=@pre_analysis ;%
str.local_identifiability=@local_identifiability;
str.analyze_residuals=@analyze_residuals_chikv;
str.extended_identifiability = @extended_identifiability;
str.contour_slice =@contour_slice; % 2D contour plot of residuals near the optimal values
str.global_identifiability=@global_identifiability;
str.bootstrap_analysis=@bootstrap_analysis;
str.cross_validation_analysis=@cross_validation_analysis;
str.post_analysis=@post_analysis ;%

%% REGULARIZATION PARAMETERS
str.regularize='none'; % ridge' 'none'  The ridge regularization will add the
% penalty scale*lambda*||p-str.pref||^2 to the fitting process.  The variable
% lambda is the square of str.sqrt_lambda, and scale = 1 if the problem is not
% standardied and = sqrt(||ydata||) if it is standardized.

str.normalize='none'; % none ydata   This parameter normalizes the penalty
% fuction to have the same dimensions as the residual function being minimized.


% set default weights
if isfield(str, 'psol')
    str.pref=str.p0; % reference solution for regularization is initial guess
    str.wpref = ones(size(str.psol)); % weights for regularization.  Typically the weight
    % for pref(ip) is 1/sigma(i), where sigma(i) is an estimate of the standard
    % deviation (error) of pref from the true solution.  That is, if pref(ip)
    % is a good estimate, sigma(ip) is small and the weight giving this
    % estimate is large.
end


str.sqrt_lambda=sqrt(0.1);% sqrt of the regularization parameter

%% EXTENDED INDENTIFIAILITY PROFILE PARAMETERS
str.profile_range=.2; % range of variables for leave-one-out profiling
str.profile_nsamps=20;
str.remove_index=0; % set profile indicator to default value of zero meaning keep
% all variables. When doing a leave-one-out profile analysis, the variable
% p(str.remove_index) ranges over a fixed set of values in the optimization process.
%

%% GLOBAL INDENTIFIAILITY PROFILE PARAMETERS
% uses str.profile_range for the range of the variables
str.candidate_points=100;
str.sample_points =200; % =ceil(ncan/10)
str.global_all=0; % 1 to plot all combinations (verbose mode only)
str.show_global_identifiability_steps = 0; % set =1 to show search steps
str.fit_nonidentifible_surface=0; % fit a curve through pairs of nonidentifible varibles -- not debugged

%% OPTIMIZATION METHOD PARAMETERS
str.min_method='lsqnonlin';%  lsqnonlin  fminunc  MPP NL minimization program

% Current optimization programs  only require function
% values, not the Jacobian or Hessian from the user
% Name of the nonlinear  minimization (optimization) function to be used.  Some of these functions
% require the user supply the residual R(X) and others require f(X)= R'*R
% lsqnonlin  nonlinear least squares program, provide the residual
% fminunc  unconstrained optimization, provide f(X)= R'*R
% MPP  Moore-Penrose pseudoinverse for linear problems, must have defined the matrix str.A

% The optimization routine requires a function to be minimized.  The
% default names can be changed to a user provided function
str.eval_residual=@eval_residual; % name of the function returning the residuals
str.eval_function=@eval_function; % name of the function returning the f(p)=R'*R
% these default functions only require function values.


%% Some optimization routines require the user to supply the Jacobian and/or Hessian.
% The user will have to match the call interface for these optimization routines
str.min_opts = optimoptions(@lsqnonlin,'MaxIterations',150, ...
    'FunctionTolerance',1.e-6,'display','off'); % parameter options for the minimization function

%% ---- ODE solver parameters
str.ode_solver=@ode45; % MATLAB ODE solver  'ode45'  'ode113'  'ode23tb'
str.ode_function=@ode_derivative; % name of function defining time derivatives
str.ode_opts = odeset('RelTol',1e-5,'AbsTol',1e-7); % ode solver options

%% parameters for block bootstrap
str.nbootstrap=100;% number of bootstrap samples
str.nsamps_per_BS_block=5; % number of points in block bootstrap,must be an odd number


%% --- cross validation parameters
str.nCV_folds=6; % number of cross validation folds


end
