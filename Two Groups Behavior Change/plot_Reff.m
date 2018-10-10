function[Reff] = plot_Reff(t,Y,p)
figure()
Reff = zeros(size(t));
 i = 1;
while i <= length(t)
   Reff(i) = calc_Reff(p,transpose(Y(i,:)));
    i = i + 1;
end
plot(t, Reff, 'b', 'linewidth', 2);
xlabel('Time')
ylabel('Effective Reproductive Number')
title('R_e over Time')