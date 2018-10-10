function [USI,RSI]=QOI_LSA(str)
%% QOI_LSA  local sensitivity analysis of QOIs
% computes the unscaled and relative sensitivity matrices and writes them
% to the file str.LSA_LaTeX_filename

% output
% USI = unscaled_sensitivity_indicies
% RSI = relative_sensitivity_indicies

% future changes
% 1. combine the two getJacobian calls so the Jac is computed only once

disp('Local Sensitivity Matrices')
disp(['column variables =',str.POI_names])
USI = getJacobian(str.POI_baseline,str.QOI_model_eval,'raw',true);
table_USI = table(USI,'RowNames',str.QOI_names);
disp(table_USI)


% Multiply by QOI/POI at the baseline for relative sensitivity analysis

RSI = getJacobian(str.POI_baseline,str.QOI_model_eval);
table_RSI = table(RSI,'RowNames',str.QOI_names);
disp(table_RSI)

% Will save .tex files to current dir unless given an 'outputDir'

LaTeX_matrix(RSI,str.QOI_names,str.POI_names,'filename',str.LSA_LaTeX_filename)
disp(['Sensitivity Matrix written to LaTeX file ',str.LSA_LaTeX_filename])

end