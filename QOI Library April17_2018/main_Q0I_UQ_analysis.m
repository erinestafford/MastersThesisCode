function main_Q0I_UQ_analysis
% main program to preform sensitivity analysis on the output quantities of 
% interest (QOIs) as a function of input parameters of interest (POIs)

% the user must a code to generate the QOIs from the POIs 
str.QOI_model_eval = @my_model;% QOI=my_model(POI)

% If there constraints on the POIs the user must provide
str.POI_constraints= @constraints; % POI = constraints(POI_input)

% change the default str.* values in the user code
% str=QOI_change_default_params(str)

% set up the solver environment ----------
% set the path for the current directory and subdirectories 
restoredefaultpath ;prefix = mfilename('fullpath');
dirs = regexp(prefix,'[\\/]');addpath(genpath(prefix(1:dirs(end))))

clear global ; clf; format shortE; close all;% close previous sessions

set(0,'DefaultAxesFontSize',18,'defaultlinelinewidth',2);set(gca,'FontSize',18);close(gcf);% increase font size
rng(101);% set the random number generator seed for reproducibility

str.QOI_model_name='Chikv_HBC'; % define the problem to be solved

str= QOI_define_default_params(str);% set the default parameter values
str= QOI_change_default_params(str);% user code to change the default parameter values

disp(str) % display the variables for solving the problem - needs a better print format

% 1. analyze the problem setup
 str.QOI_pre_analysis(str);

% 2. local sensitivity analysis
[USI,RSI]=str.QOI_LSA(str); % unscaled and relative sensitivity indices

% 3. extended sensitivity analysis
[POI_ESA,QOI_ESA]=str.QOI_ESA(str);

%4. global sensitivity analysis
[POI_GSA,QOI_GSA]=str.QOI_GSA(str);

%global sensitivity sobol indices
% [sobol_indices]=Sobol_GSA(str);
% sobol_indices
% 5. final analysis the problem solution
str.QOI_post_analysis(str);

end

function str= QOI_change_default_params(str)
%% QOI_change_default_params change default parameters


switch str.QOI_model_name
    case 'SIR'
        str.POI_names =  {'beta', 'gamma'};
        str.nPOI=2;
        
        str.QOI_names =  {'Total Infected','Infected(t=2)','R0'};
        str.nQOI=3;
        
        str.QOI_model_eval = @Big_Black_Box_SIR_model;
        str.POI_baseline=[ 0.7; 0.3];
        str.POI_min=[ 0.1; 0.2] ;
        str.POI_max=[ 2; 0.7] ;
        str.POI_mode=str.POI_baseline;
        str.POI_pdf='beta';% uniform triangle beta
        
    case 'PP'
        str.POI_names =  {'\alpha','\beta', '\delta','\gamma'};
        str.nPOI=4;
        
        str.QOI_names =  {'Maximum Predator Pop','Maximum Prey Pop','Minimum Prey Pop', 'Minimum Predator Pop'};
        str.nQOI=4;
        
        str.QOI_model_eval = @Big_Black_Box_PP_model;
        str.POI_baseline=[10;5;2;1];
        str.POI_min=[ 5; 2.5;1;0.5]; 
        str.POI_max=[ 20;7.5;3;3];
        str.POI_mode=str.POI_baseline;
        str.POI_pdf='beta';% uniform triangle beta
    case 'Chikv_HBC'
        str.POI_names =  {'\theta_2', 'Initial Cumulative Infected', 'K_v', '\pi_1', '\pi_2', 'H_0'};
        str.nPOI=6;
        
        str.QOI_names =  {'Total Infected','Infected(t=2)','R0', 'Time of Peak'};
        str.nQOI=4;
        
        str.QOI_model_eval = @BBB_Chikv_HBC_model;
        str.POI_baseline=[0.6520;57;1000000;0.5;0.8;100000];
        str.POI_min=[ .01; 1;100000;.001;.001;10000]; 
        str.POI_max=[ 0.8;100;1000000;0.5;0.8;100000];
        str.POI_mode=str.POI_baseline;
        str.POI_pdf='beta';% uniform triangle beta
    otherwise
        error([' str.QOI_model =',str.QOI_model,' is not available'])
end

end


