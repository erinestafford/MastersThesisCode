function R0 = QOI_R0(POIs, ode_soln)
% input: POIs and old_soln structure from ode solver
% output: Reproductive number

beta = POIs(1);
gamma = POIs(2);

% R0 for basic SIR
R0 = beta / gamma;

end
