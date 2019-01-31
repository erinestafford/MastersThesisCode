function testFit(psol,tdata,ydata,str)
%ub = [0.9,.9, 1,60,3000]';
%lb = [0.4,0.4, 0.5,30,1500]';
c = 1;
for i = 0.5:.002:1
    p = psol;
    p(1) = i;
    err(c) = get_error(p,tdata,ydata,str);
    c = c+1;
end

plot(0.5:.002:1, err)
end