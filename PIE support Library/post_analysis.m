
%------------------------------------------- POST_ANALYSIS

function [diff_sol] = post_analysis(tdata,ydata,zsol,pfit,str)
%% POST_ANALYSIS analyze the best fit parameters
% right now, just a bunch of plots

 % plot the solution of the original problem 
linespecsol={'-k','-.k','-k',':k','-k','-.k','--k',':k'}; % Default line types
linespecfit={'-r','-.r','-r',':r','-r','-.r','--r',':r'}; % Default line types
[~, nzdim]=size(zsol);
[~, nydim]=size(ydata);

tdata_extend=(str.tbeg: (str.tend-str.tbeg)/(str.ntdata-1) : 2*str.tend - str.tbeg)' ;

p=str.psol;
[~,zsol_extend] = str.evaluate_model(str.psol,tdata_extend,str);

p=str.pfit;
[~,zfit_extend] = str.evaluate_model(pfit,tdata_extend,str);



figure
for iz=1:nzdim
%     plot(str.tdata,str.ydata(:,iz),'*b'); hold on; % fix dim problem
    plot(tdata_extend,zsol_extend(:,iz),linespecsol{iz}) ; hold on;
    plot(tdata_extend,zfit_extend(:,iz),linespecfit{iz}) ;hold on;
end

for iy=1:nydim
plot(tdata,ydata(:,iy),'b*');hold on;
end
xlabel('time tdata');ylabel('z and y');title('black = solution data, red=fit')
title([{'Data fit in first half of domain and then extrapolated'}, ...
    {'data (blue *)  solution (black), fit (red)'}]);


% compare solution with fit solution
[~,zfit] = str.evaluate_model(pfit,tdata,str);
diff=zsol-zfit; % difference between true solution and fit solution
dt=(tdata(end)-tdata(1))/length(tdata);
diff_sol=sqrt(dt*sum(diff.*diff));
if str.verbose
    disp(' ')
    disp(['L2 difference between the fit and solution = ',num2str(diff_sol)])
end

% generate a conto2ur plot for variables i1 and i2
str.contour_slice(pfit,str); % set str.contour_slice=@none to stop plotting


end

