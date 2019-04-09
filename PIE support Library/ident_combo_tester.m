function ident_combo_tester
close all;
clear all;
%% define function and initial data
p=[0.1,5]';
y = @(params,x) (params(1).*params(2)+ params(2))*x;
x_vals = 1:0.1:10;
y_vals = y(p,x_vals);

%% get response from changing b
c = 1;
for i = 1:0.1:5
    y = @(params,x) (params(1)*i + i)*x;
    p0 = .5;
    fn = @(p)norm(y(p,x_vals)-y_vals);
    p_fit(c,:)=lsqnonlin(fn,p0);
    c = c+1;
end
%% visualize parameter interactions
% plot(1:0.1:5,p_fit);
% title('Parameter Interactions for y = abx + bx')
% xlabel('b')
% ylabel('a')
%% define list of possible functions
funcs = @(p)[p(1), p(2), p(1)+p(2), p(1)*p(2),p(1)*p(2)+p(2),log(p(1)),log(p(2)),log(p(1)+p(2))]';
functions = {'a', 'b', 'a+b', 'ab','ab +b','log(a)', 'log(b)','log(a+b)'};

%% get beta_0
%b0 = lasso([1:0.1:5]',p_fit);
x0 = 5;
p0 = [[1:0.1:5]',p_fit];
b0 = y(p0,x0) - x0.*funcs(p0);
%% initial conditions and objective function
B = ones(length(functions),1);
theta = 0.5;
p = 0.5;
%eval_res = @(B)[(1-theta)*(-funcs(p0) - sum((B.*funcs(p0)).^2)) ;theta *sum(abs(B).^p)];
eval_res = @(B)[(1-theta)*(y(p0,x0)- b0 - sum((x0.*B.*funcs(p0)).^2)) ;theta *(B.^p)];

%% find the most likely combo
B_fit = lsqnonlin(eval_res,B);
for i = 1:length(functions)
    fprintf('%10s %10g\n', functions{i},B_fit(i))
end
end