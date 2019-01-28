%------------------------------------------- FIT_DATA

function [pfit, ydata_fit, residuals, errfit] =fit_data(tdata,ydata,p0,str)
%% FIT_DATA  fit the model to ydata
% input: tdata, ydata,

% check if a variable is to be fixed
if length(str.lb)>=1
    lb = str.lb;
    ub = str.ub;
end

if str.remove_index > 0
    str.remove_xvalue=p0(str.remove_index);
    p0(str.remove_index)=[]; % shrink p0
    if ~isEmpty(str.lb)
        lb(str.remove_index)=[];
        ub(str.remove_index)=[];
    end
end

switch str.min_method
    case 'lsqnonlin' % nonlinear least-squares
        [pfit,errfit] = lsqnonlin(str.eval_residual,p0,[],[],str.min_opts,tdata,ydata,str);
    case 'fminunc' % general  quasi-Newton method
        options = optimoptions(@fminunc,'Algorithm','quasi-newton');
        [pfit,errfit] = fminunc(str.eval_function,p0,options); % tdata,ydata,str in global
    case 'chikv_optimize' % general  quasi-Newton method
        options = optimset('Algorithm','interior-point'); 
        [pfit, errfit] = fmincon(@(p)get_error(p,tdata,ydata,str), p0,[],[],[],[],str.lb,str.ub);%, options);
        
 % tdata,ydata,str in global
    case 'MPP' % Moore-Penrose pseudo inverse for linear problems
        if str.nydata ~=1; error('MPP can only be used for 1D arrays');end
        pfit=linsolve(str.A'*str.A, str.A'*ydata); % str.A is the design matrix
        
        % Regularization hasn't been implemented yet
        switch str.regularization; case 'none'; otherwise
            error(['str.regularization =',str.regularization,' not yet availible for MPP option'])
        end
    otherwise
        error(['str.min_method =',str.min_method,' not available'])
end

% evaluate fit at the data points
[residuals, ydata_fit] = str.eval_residual(pfit,tdata,str.ydata,str);

% restore missing variables
if str.remove_index > 0 % if a point is missing add it back in
    pfit = [pfit(1:str.remove_index-1);
    str.remove_xvalue;  
    pfit(str.remove_index:end)];
end

% [ydata, ydata_fit]

end
