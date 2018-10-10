function [ ] = plot_data(count, tspan)
%plot_data plots real data
hold on
title('Real Infected Count', 'fontsize', 18)
xlabel('Time in weeks', 'fontsize', 16)
ylabel('Population', 'fontsize', 16)
plot(tspan./7, count,'*')
legend('Total cases', 'Location', 'best')

end
