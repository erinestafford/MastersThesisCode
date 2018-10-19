quad_fn = @(x,p) p(1)*x.^2 + p(2)*x + p(3);
x = -20:2:20;
p = [1,2,3]';
data = quad_fn(x,p);

y=data+0.25*randn(size(data)).*data;

f2=polyfit(x,y,2)

figure()
plot(x,quad_fn(x,f2),'-',  x, y, '.')

res_quad = quad_fn(x,f2) - y;
[xc,lags] = xcorr(res_quad,50,'coeff')
conf99 = sqrt(2)*erfcinv(2*.01/2);
lconf = -conf99/sqrt(length(x));
upconf = conf99/sqrt(length(x));
figure

stem(lags,xc,'filled')
ylim([lconf-0.03 1.05])
hold on
plot(lags,lconf*ones(size(lags)),'r','linewidth',2)
plot(lags,upconf*ones(size(lags)),'r','linewidth',2)
title('Sample Autocorrelation with 99% Confidence Intervals')

lin_fn = @(x,p)p(1)*x + p(2);
f1=polyfit(x,y,1);
res_lin = lin_fn(x,f1) - y;

figure()
plot(x,lin_fn(x,f1),'-',  x, y, '.')

res_lin = lin_fn(x,f1) - y;
[xc,lags] = xcorr(res_lin,50,'coeff');
conf99 = sqrt(2)*erfcinv(2*.01/2);
lconf = -conf99/sqrt(length(x));
upconf = conf99/sqrt(length(x));
figure

stem(lags,xc,'filled')
ylim([lconf-0.03 1.05])
hold on
plot(lags,lconf*ones(size(lags)),'r','linewidth',2)
plot(lags,upconf*ones(size(lags)),'r','linewidth',2)
title('Sample Autocorrelation with 99% Confidence Intervals')
