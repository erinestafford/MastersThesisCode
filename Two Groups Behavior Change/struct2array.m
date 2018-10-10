function param_array = struct2array(params, names)
%STRUCT2ARRAY Convert struct to array, using fields given in names

param_array = NaN(size(names));
for i = 1:length(names)
    name = names{i};
    param_array(i) = params.(name);
end

end
