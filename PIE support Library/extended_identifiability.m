
% --------------------------EXTENDED IDENTIFIABILITY - ANALYZE_PROFILE


function [p_range,res_profile,pfit_profile]=extended_identifiability(tdata,ydata,pfit,errfit,str)
%% EXTENDED_IDENTIFIABILITY % leave-one-out profile analysis

% input:
%  data from the optimal fit of the model
%
% output:
% p_range(npvar,str.profile_nsamps) = p parameter locations for 1D analysis.
% p_range(ip,ir) is the p(ip), ip=1,npvar value over the range ir=1,str.profile_nsamps
%
% res_profile(npvar,str.profile_nsamps) = minimized MSE of the residuals, where p(ip)
% has been fixed. The res_profile(ip,ir) corresponds to p_range(ip,ir)
%
% pfit_profilen(npvar,str.profile_nsamps,npvar) = pfit_profilen(ip,ir,ip_var) are the
% optimial values of p(ip_var) with variable p(ip) fixed
%
% reference: least squares book
if str.verbose; disp('BEGIN EXTENDED IDENTIFIABILITY PROFILE ANALYSIS');disp(' '); end

% [pfitnew, ~, ~, errfitnew] =str.evaluate_residuals(tdata,pfit,str);% evaluate the optimal ----- debugging statement
%if norm(pfitnew-pfit) > sqrt(eps); disp('pfit not optimal value in call');keyboard;end


npvar=length(pfit);
p_range=NaN(npvar,str.profile_nsamps);
res_profile=NaN(npvar,str.profile_nsamps);
pfit_profile=NaN(npvar,str.profile_nsamps,npvar);
str.profile_range;

pfit0=pfit;
for ip=1:npvar
    % define range of the parameters
    p_range(ip,:)=linspace(str.lb(ip), str.ub(ip), str.profile_nsamps)';
    
    % leave p(ip) out (freeze at pfit(ip))
    str.remove_index=ip;
    p0=pfit0;
    for ir=1:str.profile_nsamps
        p0(ip)=p_range(ip,ir);
        [pfitr, ~, ~, errpfit] =fit_data(tdata,ydata,p0,str);
        res_profile(ip,ir) =errpfit;
        pfit_profile(ip,ir,:)=pfitr;
    end
end

str.remove_index=0; % reset LOO profile index to zero
figure; 
% label=strings(npvar,1); he
for ip=1:npvar
    xmin=min(p_range(ip,:));
    xmax=max(p_range(ip,:));
    ymin=min(res_profile(ip,:));
    ymax=max(res_profile(ip,:));

    % plot residual
    subplot(npvar,2,2*ip-1); plot(p_range(ip,:),res_profile(ip,:))
    hold on; scatter(pfit(ip),errfit,50,'rS')% mark the optimal
    axis([xmin xmax ymin ymax])
    % plot SE for pfit(ip)
    
    % find the range of the axis (limit ti=o current axis)
    xxlim=xlim;yylim=ylim ;
    xSEmax=min(xxlim(2),pfit(ip)+str.pest_CI95(ip));
    xSEmin=max(xxlim(1),pfit(ip)-str.pest_CI95(ip));
    plot([xSEmax,xSEmax],yylim,'-.k'); hold on; plot([xSEmin,xSEmin],yylim,'-.k')    
  
    
% plot SE for residuals (limit ti=o current axis)
    ySEmax=min(yylim(2),errfit+str.resSE);
    hold on; plot(xxlim,[ySEmax,ySEmax],'-.r') 
%     xlim(xxlim); ylim(yylim);
    
    
    
    title('L1O Profile');xlabel(str.plabel{ip});ylabel('residual')  
    ilegend=1;

                % plot how the other variables change
      for ip2=1:npvar
        if ip2 ~= ip
            subplot(npvar,2,2*ip); plot(p_range(ip,:),pfit_profile(ip,:,ip2),str.linespec{ip2})
            hold on; label{ilegend}= str.plabel{ip2}; ilegend=ilegend+1;
        end
    end
    legend(label);axis tight
    title('L1O Profile');xlabel(['p',num2str(ip)]);ylabel('p')
end
drawnow

if str.verbose
    %     disp('pfit_profile');disp(pfit_profile);
    disp('res_profile');disp(res_profile);
end

end

