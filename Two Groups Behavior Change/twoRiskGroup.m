%% Main script for running model with no and high risk groups and no behavior change
close all; 
addpath('../data_chik');
country = 'Guadeloupe';
[real2014, pop, name, firstWeek2014] = get_data(country,"linear");
full_count = real2014;
real = full_count;
init_infected_h = real(1);
tend = length(real);
tspan = [(firstWeek2014)*7:7:((tend+firstWeek2014-1)*7)];
tend = (tend+firstWeek2014-1);

%switch L_MODEL
%CASE 'SINGLE'
%CASE 'DOUBLE'
%commit
%make struct with model and params
%% Parameter values

param_struct = ...
    {'beta_h', 0.24;
     'beta_v', 0.24;
     'gamma_h', 1/6;
     'mu_h', 1/(70*365);
     'nu_h', 1/3;
     'psi_v', 0.3;
     'mu_v', 1/17;
     'nu_v', 1/11;
     'sigma_h1', 10; %low risk contacts
     'sigma_h2', 30; %high risk contacts
     'sigma_v', 0.5;
     'H0', pop;
     'theta1', .3; %proportion of population in group 1 - low risk
     'theta2', .7;% proportion of population in group 2 - high risk
     'theta0', .8; % no risk group
     'init_cumulative_infected', init_infected_h;
     'K_v' , pop * 2;
     'pi1', 0.1; %proportion that continues to be bitten in infected group 1
     'pi2', 0.4; %proportion that continues to be bitten in infected group 2
    }';
params = struct(param_struct{:});
array_names = param_struct(1,:);
params.H0 = params.H0 * (1 - params.theta0);
%% Plot Cumulative vs. Newly Infected
% figure()
% subplot(1,2,1)
% plot_data(full_count, tspan)
% 
% subplot(1,2,2)
% newly_infected = get_newly_infected_count(real);
% plot(tspan,newly_infected, '*')

%% Test Parameter Values
%  params.H0 =  10000;
%  params.K_v = 1000000;
% 
%  params.init_cumulative_infected = 10;
% init = ...
%     [params.H0 * params.theta1 - params.init_cumulative_infected*params.theta1,
%     params.H0 * params.theta2 - params.init_cumulative_infected*params.theta2,
%     params.init_cumulative_infected * params.theta1,
%     params.init_cumulative_infected * params.theta2,
%     0,
%     0,
%     params.init_cumulative_infected * params.theta1,
%     params.init_cumulative_infected * params.theta2,
%     params.K_v,
%     0,
%     0];
% [t_model_b,out_model_b] = balance_and_solve([0:500], init, params);
% figure()
% plot(t_model_b,out_model_b(:,7)+out_model_b(:,8))
% hold on
% params.pi2 = 0.5;
% [t_model_b,out_model_b] = balance_and_solve([0:500], init, params);
% plot(t_model_b,out_model_b(:,7)+out_model_b(:,8))
%% Plot ODE Solutions
% 
%  params.H0 =  10000;
%  params.K_v = 1000000;
% 
%  params.init_cumulative_infected = 10;
% init = ...
%     [params.H0 * params.theta1 - params.init_cumulative_infected*params.theta1,
%     params.H0 * params.theta2 - params.init_cumulative_infected*params.theta2,
%     params.init_cumulative_infected * params.theta1,
%     params.init_cumulative_infected * params.theta2,
%     0,
%     0,
%     params.init_cumulative_infected * params.theta1,
%     params.init_cumulative_infected * params.theta2,
%     params.K_v,
%     0,
%     0];
% [t_model_b,out_model_b] = balance_and_solve([0:500], init, params);
% [t_model,out_model] = output([0:500], init, params,[]);
% 
% figure()
% plot_model(t_model,out_model)
% figure()
% plot_model(t_model_b,out_model_b)


%% Parameter Estimation
lb = struct2array(params,array_names);
ub = struct2array(params,array_names);



 [lb, ub] = range(lb, ub, 'theta2', .01, .8, array_names);
 [lb, ub] = range(lb, ub, 'init_cumulative_infected', params.init_cumulative_infected * 0.1, params.init_cumulative_infected * 10, array_names);
 [lb, ub] = range(lb, ub, 'K_v', params.H0, params.H0 * 10, array_names);
 [lb, ub] = range(lb, ub, 'pi1', .001, .5, array_names);
 [lb, ub] = range(lb, ub, 'pi2', .001, .8, array_names);

opt_params1 = params;
opt_params1.theta2 = 0.6520;
opt_params1.theta1 = 1 - opt_params1.theta2;
opt_params1.K_v = 932000;
opt_params1.pi1 = 0.5;
opt_params1.pi2 = 0.8;
opt_params1.init_cumulative_infected = 57;

% obj_fn1 = @(parray)obj_fn(parray, real, array_names, tspan, ones(length(real),1));
% [opt_params1] = optimizer(obj_fn1, lb, ub, params);
%  opt_params1.theta1 = 1 - opt_params1.theta2;
%  opt_params1
% 
%  init1 = get_init_conditions(opt_params1, 0);
%  [t1,out1] = balance_and_solve(tspan, init1, opt_params1);

 
% R01 = calc_Reff(opt_params1, out1(1,:));
%Reff1 = calc_Reff(opt_params1, out1(30,:))
%Rinf = calc_Rinf(opt_params1, out1(end,:))
%peak = get_peak_infected(out1);

% 
% figure()
% plot_model(t1, out1);
figure()
plot_both(t1, out1, tspan, real);

%  
%  %calc b_h's
%  [bT1, rhoh1, rhov1] = calc_b_T(opt_params1, init1);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh1*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh1*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2
%  
% figure()
% plot(t1,(out1(:,7) + out1(:,8)), 'b')
% drawnow
% plot_Reff(t1,out1, opt_params1)
%  
% opt_params1.pi2 = 0.4;
%  tspan = [1:7:100000];
%  init2 = get_init_conditions(opt_params1, 0);
%  [t2,out2] = balance_and_solve(tspan, init2, opt_params1);
% figure()
% plot_model(t2, out2);
%  figure()
%  plot_both(t1, out1, tspan, real);
% figure()
% plot(t2,(out2(:,7) + out2(:,8)), 'b')
%  R02 = calc_Reff(opt_params1, out2(1,:))
% opt_params1
% plot_Reff(t2,out2, opt_params1)
% figure()
% plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, t1, 'pi1', .001, 1);
% figure()
% plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, t1, 'pi2', .001, 1);
% 
% R01 = calc_R0(opt_params1, out1(1,:))
% Reff = calc_Reff(params, out_model(1,:))
% [peak] = get_peak_infected(out_model)
% bT = calc_b_T(params, init)
% out_model(end,4)
% plot_Reff(t_model,out_model,params);
% plot_model(t_model,out_model)
% drawnow
% figure()
% plot(t_model,out_model(:,2))
%% Compare ChikV and Zika
% opt_params1.pi1 = 0.8;
% opt_params1.pi2 = 1;
% init1 = get_init_conditions(opt_params1, tspan);
% [t2,out2] = balance_and_solve([0 tspan], init1, opt_params1);
% R02 = calc_R0(opt_params1, out2(1,:))
% Reff2 = calc_Reff(opt_params1, out1(30,:))
% figure()
% plot_two_models(t1,out1,t2,out2,real)
% % comparing models - sum squared
% difference = cmp_models(out1,out2, real)

% %calc b_h's
%  [bT2, rhoh2, rhov2] = calc_b_T(opt_params1, init1);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh2*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh2*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2
%% Compare Risk Groups 1/2 high and 1/2 no
% opt_params1.theta0 = .75;
% opt_params1.theta2 = 1; %high
% opt_params1.theta1 = 0; % low
% init2 = get_init_conditions(opt_params1, tspan);
% [t2,out2] = balance_and_solve([0 tspan], init2, opt_params1);
% R01 = calc_R0(opt_params1, out2(1,:))
% figure()
% plot_two_models(t1,out1,t2,out2,real)

% %calc b_h's
%  [bT3, rhoh3, rhov3] = calc_b_T(opt_params1, init2);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh3*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh3*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Compare Number of Risk Groups 
%Theta0 same as baseline, combine theta1 & theta2 with same avg bites as
%baseline = 4.608 (reducing to two risk groups)
% opt_params.theta1 = 0;
% opt_params.theta2 = 1;
% opt_params1.sigma_h2 = 23.04;
% init2 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t2,out2] = balance_and_solve(tspan, init2, opt_params1);
% R02 = calc_R0(opt_params1, out2(1,:))

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init2);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

% %Reducing to one risk group, same avg bites as baseline = 4.2948
% opt_params1.H0 = pop;
% opt_params1.theta0 = 0;
% opt_params1.sigma_h1 = 4.608;
% opt_params1.sigma_h2 = 4.608;
% init3 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t3,out3] = balance_and_solve(tspan, init3, opt_params1);
% R03 = calc_R0(opt_params1, out3(1,:))
% 
% figure()
% plot_two_models(t1,out1,t2,out2,t3,out3,real);

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init3);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Reducing theta0
%theta0 is .75, theta1 & theta2 are .125, sigmah1 is 10, avg bites same

% opt_params1.theta0 = 0.75;
% opt_params1.H0 = pop * (1 - opt_params1.theta0);
% opt_params1.theta1 = 0.5;
% opt_params1.theta2 = 0.5;
% opt_params1.sigma_h1 = 10;
% opt_params1.sigma_h2 = 26.864;
% init2 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t2,out2] = balance_and_solve(tspan, init2, opt_params1);
% R02 = calc_R0(opt_params1, out2(1,:))

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init2);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

% %theta0 is .5, theta1 is .2, theta2 is .3, sigmah2 is 12, avg bites same
% opt_params1.theta0 = 0.5;
% opt_params1.H0 = pop * (1 - opt_params1.theta0);
% opt_params1.sigma_h1 = 5.0;
% opt_params1.sigma_h2 = 13.432;
% opt_params1.theta1 = 0.5;
% opt_params1.theta2 = 0.5;
% init3 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t3,out3] = balance_and_solve(tspan, init3, opt_params1);
% R03 = calc_R0(opt_params1, out3(1,:))
% figure()
% plot_two_models(t1,out1,t2,out2,t3,out3,real);

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init3);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Compare Risk Groups -- High Risk, No Risk
% opt_params1.sigma_h1 = 10;
% opt_params1.sigma_h2 = 30;
% opt_params1.theta1 = 0;
% opt_params1.theta2 = .14316;
% opt_params1.theta0 = 1 - opt_params1.theta2;
% init3 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t3,out3] = balance_and_solve(tspan, init3, opt_params1);
% t3
% R0 = calc_R0(opt_params1, out3(1,:))
% figure()
% plot_two_models(t1,out1,t3,out3,real)

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init3);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Compare Risk Groups -- Low Risk, No Risk
% opt_params1.theta2 = 0;
% opt_params1.theta1 = .42948;
% opt_params1.theta0 = 1 - opt_params1.theta1;
% init4 = get_init_conditions(opt_params1, 0);
% opt_params1
% [t4,out4] = balance_and_solve(tspan, init4, opt_params1);
% R0 = calc_R0(opt_params1, out4(1,:))
% figure()
% plot_two_models(t1,out1,t4,out4,real)

% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init4);
%  %b_h1
%  opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Compare Risk Groups start w/baseline 1/2 high -> low and 1/2 low ->no
% opt_params1.theta0 = opt_params1.theta0 + 1/2*((1 - opt_params1.theta0) * opt_params1.theta1);
% opt_params1.theta2 = opt_params1.theta2*(1/2); %high
% opt_params1.theta1 = opt_params1.theta1  - (1/2)*opt_params1.theta1 + (opt_params1.theta2*(1/2)); % low
% init2 = get_init_conditions(opt_params1, tspan);
% [t2,out2] = balance_and_solve([0 tspan], init2, opt_params1);
% R02 = calc_R0(opt_params1, out2(1,:))
% figure()
% plot_two_models(t1,out1,t2,out2,real)
% 
% %calc b_h's
%  [bT, rhoh, rhov] = calc_b_T(opt_params1, init2);
%  %b_h1
%  sigh1 = opt_params1.sigma_h1
%  b_h1 = rhoh*opt_params1.sigma_h1
%  %B_H2
%  sigh2 = opt_params1.sigma_h2
%  b_h2 = rhoh*opt_params1.sigma_h2
%  %average
%  averageSigma = (opt_params1.sigma_h1+ opt_params1.sigma_h2)/2
%  b_h = (b_h1+b_h2)/2

%% Plot Objective Functions
% figure()
% r = linspace(lb(9), ub(9), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'sigma_h1', r);
% 
% figure()
% r = linspace(lb(10), ub(10), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'sigma_h2', r);
% 
% figure()
% r = linspace(lb(15), ub(15), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'init_cumulative_infected', r);
% 
% figure()
% r = linspace(lb(13), ub(13), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'theta1', r);
% 
% figure()
% r = linspace(lb(14), ub(14), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'theta2', r);
% 
% figure()
% r = linspace(lb(16), ub(16), 100);
% [param,val] = plot_obj_fn(struct2array(opt_params1, array_names), real, array_names, tspan, 'K_v', r);



%% Making 3 week predictions
% first 10 data points
data10 = real(1:10);
tdata10 = tspan(1:10);
obj_fn10 = @(parray)obj_fn(parray, data10, array_names, tdata10, ones(length(data10),1));
[opt_params10] = optimizer(obj_fn10, lb, ub, params);
 opt_params10.theta1 = 1 - opt_params10.theta2;
init10 = get_init_conditions(opt_params10, 0);
[t10,out10] = balance_and_solve(tspan, init10, opt_params10);
figure();
plot(tspan, out10(:,7)+out10(:,8),'-r')
hold on
plot(tspan,full_count,'*')
plot(tspan(10)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
plot(tspan(13)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
%% 20 data points
data20 = real(1:25);
tdata20 = tspan(1:25);
obj_fn20 = @(parray)obj_fn(parray, data20, array_names, tdata20, ones(length(data20),1));
[opt_params20] = optimizer(obj_fn20, lb, ub, params);
 opt_params20.theta1 = 1 - opt_params20.theta2;
init20 = get_init_conditions(opt_params20, 0);
[t20,out20] = balance_and_solve(tspan, init20, opt_params20);
figure();
plot(tspan./7, out20(:,7)+out20(:,8),'-r')
hold on
plot(tspan./7,full_count,'*')
plot(tspan(25)/7*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
plot(tspan(28)/7*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
%%
CI_for_predictions_bootstrap(5,5,data20,tdata20,params,opt_params20,array_names,lb,ub,full_count)
%% 30 data points
data30 = real(1:30);
tdata30 = tspan(1:30);
weights = ones(length(data30),1);
weights(30) = 10;
weights(29) = 10;
weights(28) = 10;
obj_fn30 = @(parray)obj_fn(parray, data30, array_names, tdata30, weights);
[opt_params30] = optimizer(obj_fn30, lb, ub, params);
init30 = get_init_conditions(opt_params30, 0);
[t30,out30] = balance_and_solve(tspan, init30, opt_params30);
figure();
plot(tspan, out30(:,7)+out30(:,8),'-r')
hold on
plot(tspan,full_count,'*')
plot(tspan(30)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
plot(tspan(33)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))

%% 40 data points
data40 = real(1:40);
tdata40 = tspan(1:40);
obj_fn40 = @(parray)obj_fn(parray, data40, array_names, tdata40, ones(length(data40),1));
[opt_params40] = optimizer(obj_fn40, lb, ub, params);
init40 = get_init_conditions(opt_params40, 0);
[t40,out40] = balance_and_solve(tspan, init40, opt_params40);
figure();
plot(tspan, out40(:,7)+out40(:,8),'-r')
hold on
plot(tspan,full_count,'*')
plot(tspan(40)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
plot(tspan(43)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))

%% 50 data points
data50 = real(1:50);
tdata50 = tspan(1:50);
obj_fn50 = @(parray)obj_fn(parray, data50, array_names, tdata50, ones(length(data50),1));
[opt_params50] = optimizer(obj_fn50, lb, ub, params);
init50 = get_init_conditions(opt_params50, 0);
[t50,out50] = balance_and_solve(tspan, init50, opt_params50);
figure();
plot(tspan, out50(:,7)+out50(:,8),'-r')
hold on
plot(tspan,full_count,'*')
plot(tspan(50)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))
plot(tspan(53)*ones(size(tspan)),0:max((out1(:,7)+out1(:,8)))/(length(tspan)-1):max((out1(:,7)+out1(:,8))))

%%
tsim = [0:7:100*7];
init1 = get_init_conditions(opt_params1, 0);
[t1,out1] = balance_and_solve(tsim, init1, opt_params1);
figure()
plot(tsim./7, out1(:,7)+out1(:,8))
hold on
opt_params2 = opt_params1
opt_params2.theta2 = opt_params1.theta2/2;
opt_params2.theta1 = 1 - opt_params1.theta2;

init2 = get_init_conditions(opt_params2, 0);
[t2,out2] = balance_and_solve(tsim, init2, opt_params2);
plot(tsim./7, out2(:,7)+out2(:,8))

%%
tsim = [0:7:100*7];
init1 = get_init_conditions(opt_params1, 0);
[t1,out1] = balance_and_solve(tsim, init1, opt_params1);
figure()
plot(tsim./7, out1(:,7)+out1(:,8))
hold on
opt_params2 = opt_params1;
opt_params2.pi2 = opt_params1.pi2/2;
opt_params2.pi1 = opt_params1.pi1/2;

init2 = get_init_conditions(opt_params2, 0);
[t2,out2] = balance_and_solve(tsim, init2, opt_params2);
plot(tsim./7, out2(:,7)+out2(:,8))