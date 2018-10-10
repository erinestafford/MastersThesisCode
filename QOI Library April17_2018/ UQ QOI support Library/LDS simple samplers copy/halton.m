function samp_halton =halton(nsamp,ndim)
%% Halton Low discrepancy uniform distribution samplier 
% input: nsamp = number of samples, ndim=dimension of samples
% output: samp_halton(nsamp,ndim) uniformly distributed in (0,1)

% Set ndim-dimensional (vector) with omiting (Skip = nsamp)                                            
samp_halton=haltonset(ndim,'Skip',nsamp); 
samp_halton=net(samp_halton,nsamp); % extract the first nsamp points.

end