function samp_sobol_n =sobol_n(nsamp,ndim)
%% Sobol Low discrepancy normal distribution samplier 
% input: nsamp = number of samples, ndim=dimension of samples
% output: samp_sobol(nsamp,ndim) normally distributed samples mean=0, std=1

samp_sobol_n =sobol(nsamp,ndim);% generagte uniformly distributed samples

% map to normal distribution using the inverse cumulative distribution 
% function (cdf) for the normal distribution with
% mean MU(=0) and standard deviation SIGMA (=1)
samp_sobol_n=0.5*norminv(samp_sobol_n,0,ndim); 
end