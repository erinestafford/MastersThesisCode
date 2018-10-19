quad_fn = @(x,p) x.^2 + x+p(1);
x1 = -20:2:20;
x2 = -19:2:21; 
p1 = [2,3]';
p2 = [3,4]';
data1 = quad_fn(x1,p1);
data2 = quad_fn(x2,p2);

t = -20:1:21;
k=1;
for i = 1:2:42
    data(i) =  data1(k);
    data(i+1) = data2(k);
    k = k+1;
end
for i = 1:1:42
    data_fit(i) =  quad_fn(t(i),p1);
end

plot(t,data,'.')

quad_min = @(p)[quad_fn(t,p) - data_fit]*[quad_fn(t,p) - data_fit]';
p0 = (p1+p2)/2;
pfit = fmincon(quad_min,p0)

figure;
ip=1;npvar=length(pfit);
for i1=1:npvar-1
    for i2=i1+1:npvar
        subplot(npvar-1,npvar-1,ip);ip=ip+1; % this layout can be improved****
        
        x1min=pfit(i1);x2min=pfit(i2);
        d1=2; d2=2;
        % generate a contour plot about the first two variables
        X1 =(pfit(i1)-d1:1/11 :pfit(i1)+d1);
        X2 =(pfit(i2)-d2:1/11 :pfit(i2)+d2);
        [XX1,XX2] = meshgrid(X1,X2);
        [n1,n2]=size(XX1);
        YY=NaN(n1,n2);
        peval=pfit;
        for ip1=1:n1
            for ip2=1:n2
                peval(i1)=X1(ip1);
                peval(i2)=X2(ip2);
                YY(ip1,ip2)=quad_min(peval);
            end
        end
        % YY
        % define contour levels near minimum
        contour(XX1,XX2,YY,31);hold on
        scatter(x1min,x2min,'*r')
        title('residuals')
        
    end
end