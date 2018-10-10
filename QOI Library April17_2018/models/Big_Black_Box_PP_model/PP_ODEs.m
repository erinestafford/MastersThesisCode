function dydt = PP_ODEs(t, y, alpha,beta, gamma,delta)
% Return time derivatives for a basic SIR model

% unpack the y vector to mnemonic variables
pred = y(1); prey = y(2);

% Calculate the time derivatives 
dpreydt = alpha * prey - beta*pred*prey ;
dpreddt =  delta * pred*prey - gamma*pred;
% repack the derivatives to mnemonic variables
dydt = NaN(size(y)); % preallocate storage 
dydt(1)=dpreddt; dydt(2)=dpreydt; 
end