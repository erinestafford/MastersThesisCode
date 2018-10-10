function [] = plot_both(t,Y,tspan,data)
%plot_both plots number infected for model and real data
title('Real Infected Count and Model Infected Count', 'fontsize', 18);
xlabel('Time in weeks', 'fontsize', 16)
ylabel('Population', 'fontsize', 16)
hold on
tmodel = t.*7;
plot(tspan,data, '*');
plot(t,(Y(:,7) + Y(:,8)), 'b')
legend('Real infected count','Model infected count', 'Location', 'best')


end