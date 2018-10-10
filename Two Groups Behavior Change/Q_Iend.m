function [cumu_inf] = Q_Iend (params, out, t)
%CHIK_Q_CUMU_INFECT ...
[time, out1] = output(t, out(end,:), params,[]);

cumu_inf = out1(end,4);

end