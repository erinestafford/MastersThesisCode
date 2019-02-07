function [str] = analyze_residuals_chikv(tdata,ydata,ydata_fit,residuals,str)
%% ANALYZE_RESIDUALS analyze the goodness of fit
%
% 1. compare mean and median of residual
% 2. Randomness test: check for randomness of the signs of the residuals.
% 3. Autocorrelation test: check whether the residuals are uncorrelated.
%      test if a short sequences of residuals are correlated to indicate trends.
% 4. periodogram white noise test (not implemented yet)
%
% input:
% str = structure of method parameters - see function define_default_params(str)
% ydata_fit = fit to the observational data
% residuals = residuals of the fit to the observational data = ydata-ydata_fit
%
% output:
% str.resmean=mean(res1d(:)); % this should be close to zero
% str.resstd=std(res1d(:));
% str.resmedian=median(res1d(:));
% str.resmad=mad(res1d(:));
% str.res_pos_ratio=res_pos/(res_pos+res_neg);
% str.autcor_trend=trend_pos/(trend_pos+trend_neg);

% future additions
% separate the residuals for each observible. They are currenlty all lumped
% together
% 
% compute and plot the coefficient of variation - the normalized standard error 
[~,nydim]=size(ydata);
% reference: least squares book
if str.verbose; disp('BEGIN RESIDUAL ANALYSIS TESTS');disp(' '); 
   figure;
   % plot residuals versus time 
    subplot(3,nydim,1)
    plot(tdata,residuals(1:length(tdata)),'*');
    xlabel('time');ylabel(['residuals ',num2str(1)]);
    
    
    % plot residuals versus time 
    subplot(3,nydim,nydim+1)
    plot(ydata,residuals(1:length(ydata)),'*');
    xlabel(['ydata ',num2str(1)]);ylabel(['residuals ',num2str(1)]);
       
        
    % plot the data and fit versus time 
    subplot(3,nydim,2*nydim+1)
    plot(tdata,ydata,'.');hold on;
    plot(tdata,ydata_fit,'k');
    xlabel('time');ylabel(['ydata and ydata fit',num2str(1)]);

end

[ntdata,nydim]=size(residuals);nresid=ntdata*nydim;

% convert residuals to a 1d array  *** stop gap, need to analyze each y
% separately
res1d=reshape(residuals,nresid,1);

%1. compare mean and median of res1d
resmean=mean(res1d(:)); % this should be close to zero
resstd=std(res1d(:));
resSE=sqrt(resstd)/sqrt(ntdata);
resmedian=median(res1d(:));
resmad=mad(res1d(:));

str.resmean=resmean; % this should be close to zero
str.resstd=resstd;
str.resSE=resSE;
str.resmedian=resmedian;
str.resmad=resmad;

if str.verbose
    disp('Gaussian process models about the data fit should satisfy the conditions')
    disp(['residual mean = ',num2str(str.resmean),' approx ', num2str(str.resmedian),...
        ' = residual median'])
    disp(['residual STD  = ',num2str(str.resstd),' approx ', num2str(str.resmad),...
        ' = residual  MAD'])
end

% 2. Randomness test: check for randomness of the signs of the res1d.
% Ref. Hansen page 14
res_pos=sum(res1d>0) ;
res_neg=sum(res1d<0) ;
str.res_pos_ratio=res_pos/(res_pos+res_neg);

% is this within expected bounds?
if str.verbose
    disp(' ')% add a blank line
    disp(['Randomness test that the ratio of positive to negative res1d = ', ...
        num2str(str.res_pos_ratio), ' is close to 0.5'])
end

% 3 Autocorrelation test: check whether the res1d are uncorrelated.
% test if a short sequences of res1d are correlated to indicate trends.
% Hansen page 15
nterms=6;
%remove mean of res1d before doing analysis


reszero=res1d-str.resmean;
res2=reszero.^2;
autocor=zeros(size(res1d));trend_threshold=zeros(nresid,1);

reshift=circshift(reszero,1);% shift elements by one
% [res1d, reshift]
autocorrelation=(reszero.*reshift);
for i=1:nresid-nterms
    autocor(i)=abs(sum(autocorrelation(i:i+nterms-2)));
    trend_threshold(i)=sum(res2(i:i+nterms-1));
end
trend_threshold=trend_threshold/sqrt(nterms-1);

% autcor_trend=[autocor,trend_threshold,autocor-trend_threshold]
trend_pos=sum(trend_threshold>0) ;
trend_neg=sum(trend_threshold<0) ;

str.autcor_trend=trend_pos/(trend_pos+trend_neg);

if str.verbose
    disp(' ')% add a blank line
    disp(['No residual trend indicated if the trend threshold = ' ...
        ,num2str(trend_pos),' > ',num2str(trend_neg),' = autocorrelation'])
end

%4. periodogram white noise test: check for randomness of the res1d. Hansen (page 15)
% Check if the sequence of res1d behaves like white noise using the normalized
% cumulative periodogram. White noise has a flat spectrum.
% ---- not implemented yet
% The periodogram power spectral density (PSD) estimate, res_periodogram, of the
% res1d in terms of the frequency vector, freq, in cycles per unit time.

% [res_periodogram, freq] = periodogram(res1d) ; % in statistics toolbox
% plot(freq,10*log10(res_periodogram))
% xlabel('ydata index')
% ylabel('dB')
% title('Periodogram of res1d')

conf99 = sqrt(2)*erfcinv(2*.01/2);
lconf = -conf99/sqrt(length(residuals));
upconf = conf99/sqrt(length(residuals));
figure
[xc,lags] = xcorr(residuals,50,'coeff');
stem(lags,xc,'filled')
ylim([lconf-0.03 1.05])
hold on
plot(lags,lconf*ones(size(lags)),'r','linewidth',2)
plot(lags,upconf*ones(size(lags)),'r','linewidth',2)
title('Sample Autocorrelation with 99% Confidence Intervals')
end
