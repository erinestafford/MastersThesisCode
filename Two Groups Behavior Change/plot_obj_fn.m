function [param,val] = plot_obj_fn(param_array, data, array_names, t_in, param_name, start, e)
n = 1;
for i = 1:length(array_names)
    if strcmp(param_name,array_names{i}) == 1
        n = i;
        break;
    end
end
k = 1;
for i = start:.01:e
    param_array(n) = i;
    param(k) = param_array(n);
    val(k) = obj_fn(param_array, data, array_names, t_in);
    k = k+1;
end

plot(param,val);
xlabel(strcat(param_name,' value'));
ylabel('objective function value');

end
