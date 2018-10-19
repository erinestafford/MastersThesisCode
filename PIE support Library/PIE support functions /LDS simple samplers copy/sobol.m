function samp_sobol =sobol(nsamp,ndim)
%% Sobol Low discrepancy uniform distribution samplier 
% input: nsamp = number of samples, ndim=dimension of samples
% output: samp_sobol(nsamp,ndim) uniformly distributed in (0,1)

samp_sobol=sobolset(ndim,'Skip',nsamp); % Set ndim-dimensional (vector), and the number 
                               % of initial points to omit (Skip = nsamp)
samp_sobol=net(samp_sobol,nsamp); % Get the first nsamp points.
end