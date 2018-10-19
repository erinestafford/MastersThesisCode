function [out] = get_error(p,tdata,ydata,str)
%CHIK_CMP_REAL_MODEL returns sum squared difference of model and data

[ydata_fit,~] = str.evaluate_model(p,tdata,str); % evaluate the model
residuals = ydata-ydata_fit;
out = sum(sum(residuals.^2));

end