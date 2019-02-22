function [] = leave_one_in(tdata,ydata,pfit,str)
%% Leave-one-in analysis
% freeze 1, look at n-1 other variables
% if one is frozen and another is now identifiable => correlation

npvar=length(pfit);
for ip=1:npvar
    % fix one
    % preform global identifiability analysis on rest
end

end