function [y, pop, name, firstweek] = data_from_entry(entry, which)

if exist('which','var')
    switch which
        case 'linear'
            count = entry.count_linear;
        case 'sparse'
            count = entry.count_sparse;
        case 'confirmed'
            count = entry.count_confirmed;
        case 'linear_newinf'
            inter = entry.count_linear;
            count = [inter(1), inter(2:end) - inter(1:end-1)];
        otherwise
            count = entry.count; 
    end
else
    count = entry.count_linear;
end

firstweek = entry.first_week;
y = count(firstweek:end);
pop  = entry.population;
name = entry.name;

end