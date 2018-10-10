function [Rinf] = Q_Rinf_model (params, out, t)
%CHIK_Q_CUMU_INFECT ...
[time, out1] = output(t, out, params, []);

Rinf = calc_Reff(params, out)

end