function [R0] = Q_R0_model (params, out, t)
%CHIK_Q_CUMU_INFECT ...
%[time, out1] = output(t, out, params, []);

R0 = calc_R0(params, out)

end