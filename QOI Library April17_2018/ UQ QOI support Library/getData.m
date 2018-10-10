function [param_data,quant_data] = getData(baseParams_,baseRanges_,evalFcn_,varargin)
% eg.
% getData([.1,.2],[0,1; 0.01,.1], @(x) x(1,:)*x(2,:)

%% Input Management
p = inputParser;

addRequired(p,'baseParams',@isnumeric);
addRequired(p,'baseRanges',@isnumeric);
addRequired(p,'evalFcn',@(fh) isa(fh,'function_handle'));

defaultNumPoints = 10;
addOptional(p,'numPoints',defaultNumPoints,@isnumeric);

parse(p, baseParams_, baseRanges_, evalFcn_, varargin{:});

baseParams = p.Results.baseParams;
baseRanges = p.Results.baseRanges;
evalFcn = p.Results.evalFcn;
nPoints = p.Results.numPoints;
%
nBaseParams = length(baseParams);
[nBaseRanges,two] = size(baseRanges);

assert(nBaseParams == nBaseRanges, 'Every parameter needs a range');
assert(two == 2, 'Param ranges are two columns, [ min, max ]');
%%
% Evaluate at the base point
baseQuants = evalFcn(baseParams);

param_data.base = baseParams;
quant_data.base = baseQuants;

param_data.range = NaN(nBaseParams,nPoints);
quant_data.range = NaN(nBaseParams,length(baseQuants),nPoints);

% First data point is baseline
for i = 1:nBaseParams
    params = baseParams; % copy to mutate
    if isnan(baseRanges(i,1)) || isnan(baseRanges(i,1)) || baseRanges(i,1) > baseRanges(i,2)
        continue % Don't calulate the param if the range is not a proper range
    end
    range = linspace(baseRanges(i,1),baseRanges(i,2),nPoints);
    param_data.range(i,:) = range;
    for j = 1:nPoints
        params(i) = range(j);
        % Calculate and save quants
        out = evalFcn(params);
        quant_data.range(i,:,j) = out;
    end
end

end