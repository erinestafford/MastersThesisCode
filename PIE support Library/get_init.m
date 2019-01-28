function init = get_init(str, p)
param = get_p_struct(str, p);

init =  ...
    [param.H0 *param.theta1 - param.init_cumulative_infected*param.theta1,
     param.H0* param.theta2 - param.init_cumulative_infected*param.theta2,
     param.init_cumulative_infected * param.theta1,
     param.init_cumulative_infected * param.theta2,
     0,
     0,
     param.init_cumulative_infected * param.theta1,
     param.init_cumulative_infected * param.theta2,
     param.K_v*0.75,
     0,
     0];

end