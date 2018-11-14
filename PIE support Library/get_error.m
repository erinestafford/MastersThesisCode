function [out] = get_error(p,tdata,ydata,str)
%CHIK_CMP_REAL_MODEL returns sum squared difference of model and data

[ydata_fit,~, R0] = str.evaluate_model(p,tdata,str); % evaluate the model
residuals = str.wydata.*(ydata-ydata_fit);
out = sum(sum(residuals.^2));

c = 1.00001 - R0;
if c>0
     out = out* (1+c);
  
end

end