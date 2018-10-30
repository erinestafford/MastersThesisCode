%------------------------------------------- PRE_ANALYSIS

function pre_analysis(tdata,ydata,zsol,str)
%% PRE_ANALYSIS analyze the data for consistency
% currently just plots the data

[~,nydim]=size(ydata);
[~,nzdim]=size(zsol);
switch str.data
    case 'chikv'
        if str.verbose
            figure;
            disp('model parameters');disp(str) % print structure values
            plot(tdata,ydata,'b.', 'markersize' ,10); hold on;  % plot the original data
            plot(tdata,zsol(:,7)+zsol(:,8),'k'); hold on;  % plot the original data
            title([str.data,' ydata and solution(black line)']) ;xlabel('tdata'); ylabel('ydata');
        end
    otherwise
        if str.verbose
            figure;
            disp('model parameters');disp(str) % print structure values
            for iz=1:nydim
                plot(tdata,ydata(:,iz),'b.'); hold on;  % plot the original data
            end
            for iz=1:nzdim
                plot(tdata,zsol(:,iz),'k'); hold on;  % plot the original data
            end
            title([str.data,' ydata and solution(black line)']) ;xlabel('tdata'); ylabel('ydata');
        end
end
end
