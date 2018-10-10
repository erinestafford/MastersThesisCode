function [] = plot_modelu(t,Y)
%Plot_sir_model
%   takes time span, t, and solved sir matrix, Y, and graphs
Sh = Y(:,1) + Y(:,2);
Ih = Y(:,3) + Y(:,4);
Rh = Y(:,5) + Y(:,6);
Ih_Cumu = Y(:,7) + Y(:,8);
Sv = Y(:,9);
Ev = Y(:,10);
Iv = Y(:,11);

ax1=subplot(2,2,1)
hold on
%plot(t, Sh, ':k', 'linewidth', 2) %plots susceptible graph
plot(t, Ih, 'b', 'linewidth', 2) %plots exposed graph
plot(t, Rh, '--r', 'linewidth', 2) %plots infected graph
plot(t, Ih_Cumu, ':k', 'linewidth', 2) %plots cumulative infected graph

legend('I_h','R_h','I_h Cumu', 'Location', 'best')
hold off

xlabel('Time in Weeks')
ylabel('Host Population')
title('Unbalanced Host Dynamics')


ax3=subplot(2,2,3)
hold on
%plot(t, Sv, ':k', 'linewidth', 2) 
plot(t, Ev, 'b', 'linewidth', 2)
plot(t, Iv, '--r', 'linewidth', 2)
legend('E_v','I_v', 'Location', 'best')

xlabel('Time in Weeks')
ylabel('Vector Population')
title('Unbalanced Vector Dynamics')
linkaxes([ax1,ax3],'xy');
end

