
%------------------------------------------- global_identifiability


function [psfit,fsfit,var_ip_weights]=global_identifiability(tdata,ydata,pfit,~,str)
%% ANALYZE_PROFILE  % extended identifiability analysis using sampling

% input:
%  data from the optimal fit of the model
%
% output:
% p_range(npvar,nrange) = p parameter locations for 1D analysis.
% p_range(ip,ir) is the p(ip), ip=1,npvar value over the range ir=1,nrange
%
% res_profile(npvar,nrange) = minimized MSE of the residuals, where p(ip)
% has been fixed. The res_profile(ip,ir) corresponds to p_range(ip,ir)
%
% pfit_profilen(npvar,nrange,npvar) = pfit_profilen(ip,ir,ip_var) are the
% optimial values of p(ip_var) with variable p(ip) fixed

% future changes 
% add limits for SE as dashed lines in contour plots 

% reference: least squares book
if str.verbose; disp('BEGIN GLOBAL IDENTIFIABILITY ANALYSIS');disp(' '); end

npvar=length(pfit);


%% generate candidate sample points
ncan=str.candidate_points;
nfsamp=str.sample_points ; % =ceil(ncan/10)
pcan=halton(ncan, npvar); %(nsamples, ndimension) halton, sobol, rand
% figure; scatter(pcan(:,1),pcan(:,2),50,'b'); hold on; % scatter plots

%rescale to hyperrectangale
psfitmin=NaN(npvar,1);psfitmax=NaN(npvar,1);
for ip=1:npvar
    psfitmin(ip)=pfit(ip)-str.profile_range;
    psfitmax(ip)=pfit(ip)+str.profile_range;
    pcan(:,ip)=psfitmin(ip) + (psfitmax(ip)-psfitmin(ip))*pcan(:,ip);
end


%% evaluate the function at the candidate points
fval=NaN(ncan);
for ic=1:ncan
    fval(ic) =eval_function(pcan(ic,:)');
end

%% sort function values from low to high
[~, isort]=sort(fval);

%% find the lowest 10% to be the sample point
psamp=NaN(nfsamp,npvar);fsamp=NaN(nfsamp,1);
for is=1:nfsamp % replace this loop with an vector operation
    psamp(is,:)=pcan(isort(is),:);
    fsamp(is)=fval(isort(is));
end


%% solve optimization problem using gradient method starting at these points
psfit=NaN(nfsamp,npvar);fsfit=NaN(npvar,1);
for is=1:nfsamp
    [psfit(is,:), ~, ~, fsfit(is)] = fit_data(tdata,ydata,psamp(is,:)',str);
end


%% identify nonidentiable variables
tol=max(str.min_opts.FunctionTolerance,str.ode_opts.AbsTol);% need better formula
nid=0; nident=NaN(npvar,1);varip=NaN(1,npvar);% number of non-identifiable variables
var_ip_weights = zeros(npvar,1);
for ip=1:npvar
    pmean=mean(psfit(:,ip));
    varip(ip)=(psfit(:,ip)-pmean)'*(psfit(:,ip)-pmean)/nfsamp;
    if varip(ip) > tol % then ip is not identifiable
        nid=nid+1;
        nident(nid)=ip;
        % weights for regularization are calculated such that weights with larger variance
        %are weighted more heavily
        var_ip_weights(ip) = min([1, sqrt(abs(varip(ip)))]);
        var_ip_weights(ip) = 1/var_ip_weights(ip); 
    end
end
if str.verbose; disp(['variance of variables ',num2str(varip)]);end

if nid ==0
    if str.verbose; disp('all variables are identifiable');end
else
    nident(nid+1:end)=[] ;% list of nonidentifiable variables
    if str.verbose;disp(['the nonidentifiable variables are = ', num2str(nident')]); end
end

if str.verbose
    
    
    %% scatter plots of all variables that are nonidentifiable
    
    if str.global_all
        nid=npvar;
        nident=(1:npvar);
    end
    if nid > 1
        
        ndraw=1;
        if str.show_global_identifiability_steps; ndraw=2; end % draw twice if showing steps
        for idraw=1:ndraw
            ip=1;figure;
            for id1=1:nid-1
                for id2=id1+1:nid
                    i1=nident(id1);
                    i2=nident(id2);
                    
                    % fit a curve through the nonidentifible surface ***
                    % not debugged ***************
                    %                     if str.fit_nonidentifible_surface
                    %                         disp(['fitting nonidentifible curve for variables ',num2str([i1,i2])])
                    %                         [BasisCoef,BasisLabel]=curve_fit_through_data([psfit(:,i1),psfit(:,i2)],{str.plabel{i1},str.plabel{i2}})
                    %                     end
                    
                    subplot(nid-1,nid-1,ip);ip=ip+1; % this layout can be improved****
                    
                    %                  if str.show_global_identifiability_steps==1, then show
                    %                 the steps for the first set of variables plotted
                    if idraw==2 && str.show_global_identifiability_steps% draw all the steps
                        scatter(pcan(:,i1),pcan(:,i2),50,'b'); hold on; % scatter plots
                        xlim([psfitmin(i1) psfitmax(i1)]); ylim([psfitmin(i2)  psfitmax(i2)]);
                        if ip == 2; pause;end % pause between plots on the first figure
                        scatter(psamp(:,i1),psamp(:,i2),50,'g','filled');hold on; %
                        if ip == 2; pause;end % pause between plots on the first figure
                        quiver(psamp(:,i1),psamp(:,i2),psfit(:,i1)-psamp(:,i1),psfit(:,i2)-psamp(:,i2),0)
                        xlim([psfitmin(i1) psfitmax(i1)]); ylim([psfitmin(i2)  psfitmax(i2)]);
                    end
                    
                    scatter(pfit(i1),pfit(i2),50,'rS'); hold on; % scatter plots
                    scatter(psfit(:,i1),psfit(:,i2),50,'k','filled')%
                    xlabel(str.plabel{i1}); ylabel(str.plabel{i2})
                    title('scatter plot of solution')
                    
                    
                end
            end
        end
        
        
        if nid > 1 % then we can do 3D scatter plots just do the first one
            if nid==2; nident=[1 2 3];end
            for idraw=1:ndraw
                figure;
                i1=nident(1);
                i2=nident(2);
                i3=nident(3);
                if idraw==2 % draw all the steps
                    scatter3(pcan(:,i1),pcan(:,i2),pcan(:,i3),50,'b'); hold on; % scatter plots
                    scatter3(psamp(:,i1),psamp(:,i2),psamp(:,i3),50,'g','filled');hold on; %
                    hold on; % to see where the point sog
                    quiver3(psamp(:,i1),psamp(:,i2),psamp(:,i3),psfit(:,i1)-psamp(:,i1), ...
                        psfit(:,i2)-psamp(:,i2),psfit(:,i3)-psamp(:,i3),0)
                    
                    xlim([psfitmin(i1) psfitmax(i1)]); ylim([psfitmin(i2)  psfitmax(i2)]);
                    zlim([psfitmin(i3)  psfitmax(i3)]);
                    
                end
                
                scatter3(pfit(i1),pfit(i2),pfit(i3),50,'rS'); hold on; % scatter plots
                scatter3(psfit(:,i1),psfit(:,i2),psfit(:,i3),50,'k','filled')%
                xlabel(str.plabel{i1}); ylabel(str.plabel{i2});zlabel(str.plabel{i3})
                title('scatter plot of optimal paramters')
                
            end
        end
        
    end
end
end
