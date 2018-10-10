function [] = derivatives_time(t1, init, parameters)
out1 = zeros(7, length(t1));
for i = 1:length(t1)
    [t, out] = output(t1, init, parameters, []);
    y = out(i,:);
    out1(:,i) = RHS_eq_twoGroup(t, y, parameters);
end
figure()
hold on
plot(t1, out1(1,:), 'g');
plot(t1, out1(2,:), 'r');
plot(t1, out1(3,:), 'b');
legend('S_h','I_h','R_h', 'Location', 'best')
end