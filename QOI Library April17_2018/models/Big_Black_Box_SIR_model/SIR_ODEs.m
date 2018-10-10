function dydt = SIR_ODEs(t, y, beta, gamma)
% Return time derivatives for a basic SIR model

% unpack the y vector to mnemonic variables
S = y(1); I = y(2); R = y(3);
rho=0.00;
% Calculate the time derivatives 
lambda=beta*I; % simplifed force of infection 
dSdt = -lambda * S + rho*R ;
dIdt =  lambda * S  - gamma * I;
dRdt =              + gamma * I - rho*R;

% repack the derivatives to mnemonic variables
dydt = NaN(size(y)); % preallocate storage 
dydt(1)=dSdt; dydt(2)=dIdt; dydt(3)=dRdt;
end