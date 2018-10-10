

function [POI_ESA,QOI_ESA]=QOI_ESA(str)
%% QOI_ESA Extended Sensitivity Anaysis

% This calculates QOI responses around the baseline set of parameters
% and creates one at a time sensitivity analysis plots
%
% input: determines the range for each POI(ip)
% str.POI_baseline(ip)
% str.POI_min(ip)
% str.POI_max(ip)

POI_ranges = [ str.POI_min,  str.POI_max];% POI ranges

[POI_ESA, QOI_ESA] = getData(str.POI_baseline, POI_ranges, str.QOI_model_eval, str.number_ESA_samples);

% These are the str.POI_baseline at the baseline
str.QOI_baseline = QOI_ESA.base;

%% Response Plots

% We asign the figures to the structure 'ESA_plots', 
% you do not have to call figure on each entry.
% this is done for display purposes when publishing this example
ESA_plots = responsePlots(POI_ESA, QOI_ESA, ...
    'paramNames',string(str.POI_names), ...
    'quantNames',string(str.QOI_names));


nplots=length(str.QOI_names);
for iplot=1:nplots
    figure(ESA_plots(iplot))
end


end

