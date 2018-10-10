function [y, pop, name, firstweek] = data_from_idx_2015(db, c)

name = db.names{c};
pop = db.pops(c) * 1000;

country_data = db.output(c,:);

firstweek = find(country_data,1);

y = country_data(firstweek:end);

end