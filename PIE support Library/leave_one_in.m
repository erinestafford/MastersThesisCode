function leave_one_in(str)
%% Leave-one-in analysis
% freeze 1, look at n-1 other variables
% if one is frozen and another is now identifiable => correlation
global tdata ydata 
npvar=length(str.psol);
pfit0=str.psol;
for ip=1:npvar
    % fix one
    % preform global identifiability analysis on rest
    str.remove_index=ip;
    p0=pfit0;
    [pfit,ydata_fit,residuals,errfit] = fit_data(tdata,ydata,p0,str);
%     [str]=str.bootstrap_analysis(tdata,ydata,pfit,str);
%     [eig_vec_Sidentifable, GRAD, HESS, SV_HESS, V] = str.local_identifiability(pfit,str);
%     [p_range, res_profile]=str.extended_identifiability(tdata,str.ydata,pfit,errfit,str);
    [psfit,fsfit,varip]=str.global_identifiability(tdata,str.ydata,pfit,errfit,str);
end

end