function names = basicNames(n,prefix)
% Init basic param strings, if needed
names = cell(n,1);
for i = 1:n
    names{i} = strcat(prefix,num2str(i));
end
end