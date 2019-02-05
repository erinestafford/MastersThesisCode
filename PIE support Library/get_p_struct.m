function params = get_p_struct(str, p)
param = zeros(size(str.p0));
if str.remove_index > 0 % not right
    for(j = 1:length(str.p0))
        if j < str.remove_index
            param(j) = p(j);
        elseif j == str.remove_index
            param(j) = str.remove_xvalue;
        else
            param(j) = p(j-1);
        end
    end
else
    param = p;
end
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
     'H0', 100;
     'theta1', 0.3; %proportion of population in group 1 - low risk 1-param(1)
     'theta2', 0.7;% proportion of population in group 2 - high risk param(1)
     'theta0', .8; % no risk group
     'init_cumulative_infected', param(1);
     'K_v' , param(2);
     'pi1', 0.6; %proportion that continues to be bitten in infected group 1 param(2)
     'pi2', 0.8; %proportion that continues to be bitten in infected group 2 param(3)
    }';
params = struct(param_struct{:});
end