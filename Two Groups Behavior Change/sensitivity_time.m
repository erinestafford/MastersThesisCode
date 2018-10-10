function [] = sensitivity_time(params, out1, t1)

sens = zeros(size(t1));
 i = 1;

while i < length(t1)
   Q1 = @(params) Q_Reff(params, out1, [0 i]);
   Q2 = @(params) Q_Iend(params,out1, [0 i]);
   Q3 = @(params) Q_R0(params,out1, [0 i]);
   sens(i) = chik_sensitivity_analysis(Q2, params, 'theta2');
   i = i + 1;
end
sens
plot(t1,sens)

figure()

% sensitivity_sigmah1 = chik_sensitivity_analysis(Q1, params, 'sigma_h1');
% sensitivity_theta1 = chik_sensitivity_analysis(Q1, params, 'theta1');
% sensitivity_theta2 = chik_sensitivity_analysis(Q1, params, 'theta2');
% sensitivity_pi1 = chik_sensitivity_analysis(Q1, params, 'pi1');
% sensitivity_pi2 = chik_sensitivity_analysis(Q1, params, 'pi2');
% sensitivity_K_v = chik_sensitivity_analysis(Q1, params, 'K_v');
% sensitivity_theta0 = chik_sensitivity_analysis(Q1, params, 'theta0');
% %q2
% sensitivity_theta1 = chik_sensitivity_analysis(Q2, params, 'theta1');
%sensitivity_theta2 = chik_sensitivity_analysis(Q2, params, 'theta2');
% sensitivity_pi1 = chik_sensitivity_analysis(Q2, params, 'pi1');
% sensitivity_pi2 = chik_sensitivity_analysis(Q2, params, 'pi2');
% sensitivity_K_v = chik_sensitivity_analysis(Q2, params, 'K_v');
% sensitivity_theta0 = chik_sensitivity_analysis(Q2, params, 'theta0');
% %q3
% sensitivity_theta1 = chik_sensitivity_analysis(Q3, params, 'theta1');
% sensitivity_theta2 = chik_sensitivity_analysis(Q3, params, 'theta2');
 %sensitivity_pi1 = chik_sensitivity_analysis(Q3, params, 'pi1');
% sensitivity_pi2 = chik_sensitivity_analysis(Q3, params, 'pi2');
% sensitivity_K_v = chik_sensitivity_analysis(Q3, params, 'K_v');
% sensitivity_theta0 = chik_sensitivity_analysis(Q3, params, 'theta0');

title('Sensitivity Over Time')
xlabel('Time')
ylabel('Sensitivity Index')
%plot(i, sensitivity_theta2, '*b')
hold on

end