function test_ext_ident(p,tdata,ydata,str,index)
lb = str.lb(index);
ub = str.ub(index);
str.remove_index = index;
c = 1;

for i = lb:str.profile_range:ub
p(index) = i;
[pfit(:,c),~, residuals, ~] =fit_data(tdata,ydata,p,str);
str.remove_index = 0;
err(c) = get_error(pfit(:,c),tdata,ydata,str);
str.remove_index = 1;
c = c+1;
end

end