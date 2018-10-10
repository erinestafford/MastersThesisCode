function sobol_halton_example
%% test simple versions of sobol and halton low discrepancy samples 

close all;

ndim = 2 ; % dimension 
nsamp = 1000; % Vector size.
nbins = 100; % Number of bins used to calculate the histogram.

% Returns an ndim-by-nsamp matrix (size vector = nsamp).
samp_rand = rand(nsamp,ndim); 
samp_sobol=sobol(nsamp,ndim);
samp_halton=halton(nsamp,ndim);

% Returns an ndim-by-nsamp matrix (size vector = nsamp).
samp_rand_n = randn(nsamp,ndim); 
samp_sobol_n=sobol_n(nsamp,ndim);
samp_halton_n=halton_n(nsamp,ndim);
size(samp_rand_n)

subplot(3,1,1);
hist(samp_rand(:,1),nbins);
title('randn iid normal distribution');

subplot(3,1,2);
hist(samp_sobol(:,1),nbins);
title('Sobol LDS normal distribution'); 

subplot(3,1,3);
hist(samp_halton(:,1),nbins);
title('Halton LDS normal distribution');

figure
subplot(3,1,1);
plot(samp_rand(:,1), samp_rand(:,2),'.')
title('randn MC');

subplot(3,1,2);
plot(samp_sobol(:,1), samp_sobol(:,2),'.')
title('Sobol LDS'); 

subplot(3,1,3);
plot(samp_halton(:,1), samp_halton(:,2),'.')
title('Halton LDS');

% return
%-------- normal distributions
figure
subplot(3,1,1);
% plot(samp_rand_n(:,1), samp_rand_n(:,2),'.')
hist(samp_rand_n(:,1),nbins);
title('randn iid iid normal distribution');

subplot(3,1,2);
% plot(samp_sobol_n(:,1), samp_sobol_n(:,2),'.')
hist(samp_sobol_n(:,1),nbins);
title('Sobol LDS normal distribution'); 

subplot(3,1,3);
% plot(samp_halton_n(:,1), samp_halton_n(:,2),'.')
hist(samp_halton_n(:,1),nbins);
title('Halton LDS normal distribution');

figure
subplot(3,1,1);
plot(samp_rand_n(:,1), samp_rand_n(:,2),'.')
title('randn iid normal distribution');

subplot(3,1,2);
plot(samp_sobol_n(:,1), samp_sobol_n(:,2),'.')
title('Sobol LDS normal distribution'); 

subplot(3,1,3);
plot(samp_halton_n(:,1), samp_halton_n(:,2),'.')
title('Halton LDS normal distribution');

% compute means and standard deviations
rand_mean=mean(samp_rand)
rand_std=std(samp_rand)

rand_n_mean=mean(samp_rand_n)
rand_n_std=std(samp_rand_n)

sobol_mean=mean(samp_sobol)
sobol_std=std(samp_sobol)

sobol_n_mean=mean(samp_sobol_n)
sobol_n_std=std(samp_sobol_n)

halton_mean=mean(samp_halton)
halton_std=std(samp_halton)

halton_n_mean=mean(samp_halton_n)
halton_n_std=std(samp_halton_n)

whos % check that memory is being handled properly
end
