function [t,out, te,ye,ie] = output(t_in, Y, param, options)

dydt_fn = @(t,Y) RHS_eq_twoGroup(t, Y, param);

if numel(options) ~= 0
    [t, out, te, ye, ie] = ode45(dydt_fn, t_in, Y, options);
else
    [t, out] = ode45(dydt_fn, t_in, Y);
end

end