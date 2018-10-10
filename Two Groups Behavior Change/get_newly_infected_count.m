function [newly_infected] = get_newly_infected_count(real_data)
newly_infected = real_data;
newly_infected(2:end) = real_data(2:end) - real_data(1:(end-1));
end
