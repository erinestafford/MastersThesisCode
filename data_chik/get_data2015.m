function [y, pop, name, firstweek] = get_data2015(country_name)

addpath('../lib') % for strdist

db = create_database_2015();
bestidx = 1;
bestdist = intmax;
uname = upper(country_name);
for i = 1:length(db.names)
    cdist = strdist(upper(db.names{i}), uname);
    if cdist < bestdist
        bestidx = i;
        bestdist = cdist;
    end
end

c = bestidx;

[y, pop, name, firstweek] = data_from_idx_2015(db, c);

end