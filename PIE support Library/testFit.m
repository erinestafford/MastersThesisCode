function testFit(str,tdata,ydata)
%ub = [0.9,.9, 1,60,3000]';
%lb = [0.4,0.4, 0.5,30,1500]';
c = 1;
for i = 30:1:60
    p = str.psol;
    p(1) = i;
    err(c) = get_error(p,tdata,ydata,str);
    c = c+1;
end

plot(30:1:60, err)