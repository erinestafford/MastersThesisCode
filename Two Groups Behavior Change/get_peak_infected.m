function [peak_inf] = get_peak_infected(out)
    peak_inf = max(out(:,3) + out(:,4));
end
