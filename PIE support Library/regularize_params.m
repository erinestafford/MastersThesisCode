function regularize_params(weights) 

global str ydata tdata

str.regularize = 'regularize_weighted';
str.lambda = 0.8;
str.reg_weights = weights;

[pfit,ydata_fit,residuals,errfit] = fit_data(tdata,ydata,str.p0,str);
if str.verbose 
    disp('The pfit solution values are');
    pfit
end
 [str] = str.analyze_residuals(tdata,str.ydata,ydata_fit,residuals,str);
 [str]=str.bootstrap_analysis(tdata,ydata,pfit,str);
 str.pfit=str.pest_mean; % add option to use mean value as the solution 
 [eig_vec_Sidentifable, GRAD, HESS, SV_HESS, V] = str.local_identifiability(pfit,str);
[p_range, res_profile]=str.extended_identifiability(tdata,str.ydata,pfit,errfit,str);


[psfit,fsfit,ident]=str.global_identifiability(tdata,str.ydata,pfit,errfit,str);

end