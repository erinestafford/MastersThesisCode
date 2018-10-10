function params = array2struct(param_array, names)
%ARRAY2STRUCT Convert array to struct, using fields given in names

params = struct();
for i = 1:length(names)
    name = names{i}; 
    params.(name) = param_array(i);
end

end