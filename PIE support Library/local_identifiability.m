%------------------------------------------- ANALYZE LOCAL identifiability


function [eig_vec_Sidentifable, GRAD, HESS, SV_HESS, V] = local_identifiability(pfit,str)
%% ANALYZE_identifiability analyze the local identifiability of the parameters
%
% computes the Gradient (GRAD) and Hessian (HESS) at pfit and determines
% which, if any of the fitting parameters are directly identifiable
%
% input:
% pfit = optimal value of fitted parameters
% str = structure - see define_default_params(str)
%
% output:
% eig_vec_Sidentifable = index of p variables that are directly identifiable
% GRAD = gradient of the function at pfit dimensioned GRAD(npvar,1)
% HESS = Hessian of the minimized function at pfit dimensioned
% SV_HESS = singular values of the Hessian dimensioned SV_HESS(npvar,1)
% V = the eigenvectors of the Hessian, corresponding the SV_HESS
% if irank is the index of the first singular value below the desired
% tolerance, then irank is the rank of the Hessian and
% the eigenvectors V(:,irank), irank=1,rS span the identifiable space and
% the eigenvectors V(:,irank), irank=rS+1,npvar span the non-identifiable space
% where is the dimension of pfit

if str.verbose;disp('BEGIN LOCAL IDENTIFIABILITY HESSIAN ANALYSIS');disp(' ');end

% verify that the gradient iszero
[GRAD] = grad_fdm(pfit,str.eval_function);
grad_norm = sqrt(GRAD'*GRAD);

% comute the Hessian at the minimum
[HESS] = hess_fdm(pfit,str.eval_function);
[~,npvar]=size(HESS);
[~,S,V]=svd(HESS);
SV_HESS = diag(S);   % vector of singular values
rcond_est=SV_HESS(npvar)/SV_HESS(1); % reciprocal of condition number



% find small singular values

tolerance = sqrt(max(size(HESS))*eps(max(SV_HESS))); % smallest tolerance to be considered
sqrt_tolerance=sqrt(tolerance); % tmp fix used for practical identifiability ** needs to use residuals SE

rS = sum(SV_HESS>tolerance); % rank of the matrix for structural identifiability
rP = sum(SV_HESS>sqrt_tolerance); % rank of the matrix for practical identifiability
% real tolerance might need to be larger based on the error in the min solver

% identify which sparse linear combinations of variable might be identifiable
% the vectors V(:,rS) span this space.
eig_vec_Sidentifable=(1:rS);
eig_vec_Pidentifable=(1:rP);
% index of indent. variables
eig_vec_NSidentifable=(rS+1:npvar);
eig_vec_NPidentifable=(rP+1:npvar);
% index of nonindent. variables

% identify which parameters are not identifiable
NSident=length(eig_vec_NSidentifable);
NPident=length(eig_vec_NPidentifable);
parm_Sidentifable=(1:npvar);
parm_Pidentifable=(1:npvar);
for ip=npvar:-1:1
    for iv=1:NSident
        ie=rS+iv-1;
        if abs(V(ip,ie)) > tolerance; parm_Sidentifable(ip) = [];break;end
    end
end

for ip=npvar:-1:1
    for iv=1:NPident
        ie=rP+iv-1;
        if abs(V(ip,ie)) > sqrt_tolerance; parm_Pidentifable(ip) = [];break;end
    end
end


if str.verbose

     disp(' ');disp('Hessian') ;disp(HESS);
     
       % compute the Fisher Information matrix
    [JAC]= jac_PIE(pfit,@eval_residual);
     FIM=JAC'*JAC;  % Fisher Information matrix approximation of the Hessian 
     disp(' ');disp('Fisher information matrix') ;disp(FIM);
     
     
    disp(['The norm of the gradient = ',num2str(grad_norm),...
        ' should be small at the minimium']);disp(' ')
    
        
    disp(['The condition number of the Hessian = ',num2str(1/rcond_est)])
    disp([' should be < ',num2str(1./tolerance),...
        ' for all variables to be structually identifiable']); disp(' ')

    if ~isempty(parm_Sidentifable)
        disp('The parameters ');disp(str.plabel(parm_Sidentifable))
        disp(' are structually identifiable'); disp(' ')
    else
        disp('None of the variables are structually identifiable')
    end
    
    if ~isempty(parm_Pidentifable)
        disp('The parameters ');disp(str.plabel(parm_Pidentifable))
        disp(' are practically identifiable'); disp(' ')
    else
        disp('None of the parameters are practically identifiable')
    end
    disp(' ')
    
    if ~isempty(eig_vec_Sidentifable)
        disp(['The vectors ', num2str(eig_vec_Sidentifable),' are structually identifiable'])
    else
        disp('None of the variables are structually identifiable')
    end
    
    
    if ~isempty(eig_vec_Pidentifable)
        disp(['The vectors ', num2str(eig_vec_Pidentifable),' are practically identifiable'])
    else
        disp('None of the variables are practically identifiable')
    end
    
    Singular_values=SV_HESS';
    
    Vectors_identifiable = V(:,1:rS);
    disp('Singular values'); disp(Singular_values)
    disp('The vectors spanning the stuctural identifiable space are');
    disp(Vectors_identifiable)
    
    if rS<npvar
        Vectors_nonidentifiable =V(:,(rS+1):npvar);
        disp('The vectors spanning the stuctural non-identifiable space are')
        disp('Nonidentiviable vectors');disp(Vectors_nonidentifiable)
    end
    
 

end

end


%