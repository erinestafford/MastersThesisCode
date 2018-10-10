function [] = plot_two_models(t1,Y1,t2,Y2,data)
%plot_both plots number infected for model and real data
title('Effect of Risk Groups', 'fontsize', 18);
xlabel('Time in weeks', 'fontsize', 16)
ylabel('Population', 'fontsize', 16)
hold on
t1 = t1'./7;
plot(t1,(Y1(:,7) + Y1(:,8)), '--b', 'linewidth', 2)
t2 = t2'./7;
plot(t2,(Y2(:,7) + Y2(:,8)), 'r', 'linewidth', 2)
%plot(t1,data, '*');
%t3 = t3'./7;
%plot(t3,(Y3(:,7) + Y3(:,8)), ':k', 'linewidth', 2)
%legend('Baseline', '\theta_0 = 0.75', '\theta_0 = 0.5', 'Location', 'best')


end