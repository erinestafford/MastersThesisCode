function plots = responsePlots(paramData_, quantData_, varargin)
% Parameters
p = inputParser;

addRequired(p,'paramData',@isstruct); % ADDME ndims check?
addRequired(p,'quantData',@isstruct); % FIXME lost isnumeric check w/ isstruct

addOptional(p,'paramNames',{},@isstring);
addOptional(p,'quantNames',{},@isstring);

parse(p, paramData_, quantData_, varargin{:});

paramData = p.Results.paramData;
quantData = p.Results.quantData;
paramNames = p.Results.paramNames;
quantNames = p.Results.quantNames;
%%
param_range = paramData.range;
quant_range = quantData.range;

[nParams_,nPoints_] = size(param_range);
[nParams,nQuants,nPoints] = size(quant_range);

assert(nParams_ == nParams, 'Parameter dimension mismatch between params and quants');
assert(nPoints_ == nPoints, 'Number of points mismatch between params and quants');

% Init basic param strings, if needed
if length(paramNames) ~= nParams
    paramNames = basicNames(nParams, 'Param');
end
% Init basic quant strings, if needed
if length(quantNames) ~= nQuants
    quantNames = basicNames(nQuants, 'Quant');
end

%%
% Get maxes and min for pretty plotting
xpt_max = squeeze(max(param_range,[],2));
xpt_min = squeeze(min(param_range,[],2));

yval_max = squeeze(max(quant_range,[],3));
yval_min = squeeze(min(quant_range,[],3));
for i=1:nQuants

    if nargout == 1
        plots(i) = figure('Visible','off');%'Units','normalized','Position',[.5 1 .4 .4])
    else
        figure();
    end
    for j=1:nParams
        a = subplot('Position', [.88*(j-1)/nParams+.12, 0.12, .90/nParams-.03, .85]); % HARD
        axis(a,'tight');
        set(a,'defaultlinelinewidth',1.5);

        x_ = squeeze(param_range(j,:));
        y_ = squeeze(quant_range(j,i,:))';

        hold(a,'on')
        plot(a, x_, y_, ...
            paramData.base(j), quantData.base(i), '*','MarkerSize',14);
      
        xlim(a, [xpt_min(j) xpt_max(j)])
        xlabel(a,['POI = ', paramNames{j}],'fontsize',22)
        if j > 1
            set(a,'YTickLabel',{})
        else
            ylabel(a, ['QOI = ',quantNames{i}],'fontsize',18)
        end
%         keyboard
%        ylim(a, [yval_min(j,i) yval_max(j,i)+eps])
        hold(a,'off')
        % for title, change last entry in subplot's Position to .82-ish
%         title(paramNames{j},'fontsize',18)
    end
end

end