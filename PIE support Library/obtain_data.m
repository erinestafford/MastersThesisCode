%------------------------------------------- DEFINE_DATA


function [tdata,ydata,zsol,str]=obtain_data(str)
%% DEFINE_DATA define the data to be fit
% the structure values in str are used to define
% input:
% str = structue (see the function define_default_params
% output:
% tdata = time array of dimension (ntime,1)
% ydata = observational array of dimension (nydata,nydim), where nydata >= ntime
% zsol = solution of the problem, when it exists, with dimension (ntime,nsol)
% for comparison and =[] when the solution is not available.
% nsol=number of solution components

switch str.data
    case 'read' % read data from a file ------ not implimented yet
        % read tdata, ydata, and weighs from file str.data2
        % Read in the file
        fh = fopen(str.data2, 'rS');
        if fh == -1
            error('File %SV_HESS not found.', fname);
        end
    case 'chikv_read'
        addpath('/Users/erinstafford/Documents/GitHub/MastersThesisCode/data_chik');
        country = 'Guadeloupe';
        [real2014, ~, ~, firstWeek2014] = get_data(country);
        ydata = real2014;
        tend = length(ydata);
        tdata = (firstWeek2014)*7:7:((tend+firstWeek2014-1)*7);
        zsol = str.evaluate_model(str.psol,tdata,str);
    otherwise % generate data
        tdata=(str.tbeg: (str.tend-str.tbeg)/(str.ntdata-1) : str.tend)'; % times for data
        % define the model and generate the data to be fit
        [ydata,zsol] = str.evaluate_model(str.psol,tdata,str);
        % define weights for the data
        % str.wydata=ones(length(ydata),1); % this is the default value
        %ydata = ydata+str.noise_sd*randn(size(ydata));
        ydata=ydata+str.noise_sd*randn(size(ydata)).*max(abs(ydata));% add normally distributed noise   
   
end

% store the solution and size
[str.ntdata, str.nzdim]=size(zsol);
[str.ntdata, str.nydim]=size(ydata);
str.nydata=str.ntdata*str.nydim;

% if the data weights have not been define, set the weights = 1
if ~isfield(str, 'wydata')
    str.wydata=ones(size(ydata));
end

% if the problem is to be standardized, define the standardization scalar
switch str.normalize
    case 'none'
        str.lambda_scaled=str.sqrt_lambda;
    case 'zsol'
        str.lambda_scaled=str.sqrt_lambda*norm(zsol);
    otherwise
        error(['str.normalize = ',str.normalize,' not defined'])
end



end
