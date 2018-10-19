function [t,out] = output_chikv(t_in, Y, param, str, options)

dydt_fn = @(t,Y) str.ode_function(Y, str, param);

if numel(options) ~= 0
    [t, out, te, ye, ie] = ode45(dydt_fn, t_in, Y, options);
else
    [t, out] = ode45(dydt_fn, t_in, Y);
end

end