function init = get_init(str, p)
param = zeros(size(str.p0));
if str.remove_index > 0
    for(j = 1:length(str.p0))
        if j < str.remove_index
            param(j) = p(j);
        elseif j == str.remove_index
            param(j) = str.p0(j);
        else
            param(j) = p(j-1);
        end
    end
else
    param = p;
end
init =  ...
    [1000 *(1-param(1)) - 40*(1-param(1)),
     1000* param(1) - 40*param(1),
     40 * (1-param(1)),
     40 * param(1),
     0,
     0,
     40 * (1-param(1)),
     40 * param(1),
     2000,
     0,
     0];
end