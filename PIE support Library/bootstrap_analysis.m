%-------------------------- BOOTSTRAP_ANALYSIS


function [str]=bootstrap_analysis(tdata,ydata,pfit,str)
%% BOOTSTRAP_ANALYSIS  % estimate the uncertainty in parameters using
%    bootstrap analysis

% input:
% tdata,ydata original data
% pfit optimal fitting parameters
% data from the optimal fit of the model
% str strure
%
% output:
% str.pest_mean=mean(pest_BS,2); % define best Beta as the mean of bootstrapped Betas
% str.pest_STD= std(pest_BS,0,2) ; % standar deviation of the parameter estimates
% str.pest_SE = pest_STD/sqrt(str.nbootstrap); % Standard Error
% str.pest_CI95 = 1.96*pest_SE ;  % 95% confidence bounds delta

% reference: Hastie Tip book

if str.verbose; disp(' ');disp('BEGIN BOOTSTRAP ANALYSIS');disp(' '); end

npvar=length(pfit);
[ntdata,nzdim]=size(ydata);

blockhalfwith=floor(str.nsamps_per_BS_block/2);% block half width
nybeg=blockhalfwith+1; % beginning index for the blocks
nyend=ntdata-blockhalfwith;% ending index for the blocks
nblockcenters=nyend-nybeg+1;% number of block centers
nblocks=ceil(ntdata/str.nsamps_per_BS_block); % number of blocks selected each bootstrap

% define weights for bootstrap analysis
pest_BS=NaN(npvar,str.nbootstrap);
wydata=str.wydata; % save weights before bootstrap

for ib=1:str.nbootstrap % do bootstrap str.nbootstrap times
    wdataBS=zeros(ntdata,nzdim); % initialize BS weigths to zero
    
    index_bs=nybeg+ceil(nblockcenters*rand(nblocks,1))-1;% random centers for blocks
    
    for ip=1:nblocks
        
        for ibb=index_bs(ip)-blockhalfwith:index_bs(ip)+blockhalfwith % loop over points in a block
            wdataBS(ibb,:)=wdataBS(ibb,:)+1; % update weight of points in a block
        end
        
    end
    
    str.wydata=wydata.*sqrt(wdataBS); % use the square root since the weights are wydata^2
    % fit the data
    [pest_BS(:,ib), ~, ~, ~] =fit_data(tdata,ydata,pfit,str);% save fitted parameters
end
str.wydata=wydata; % restore the weights

str.pest_mean=mean(pest_BS,2); % define the mean of bootstrapped parameters
str.pest_STD= std(pest_BS,0,2) ; % standard deviation of the parameter estimates
str.pest_SE = str.pest_STD/sqrt(str.nbootstrap); % Standard Error
zstar=1.96 ;% for 95% confidence interval (assumes Gaussian distribution)
str.pest_CI95 = zstar*str.pest_SE ;  % 95% confidence bounds delta

% compute the correlation coefficients
str.corrcoef = corrcoef(pest_BS');


if str.verbose

    disp('    mean pfit     95% CI delta')
    disp([str.pest_mean,str.pest_CI95])
    
    %     boxplot(pest_BS',str.plabel(1:npvar)); % matlab statistics toolbox boxplot
    %     title('boxplot of fitted parameters')
    %
    figure; [forLegend] = bplot(pest_BS'); % open source version of boxplot
    title('boxplot of fitted parameters');legend(forLegend(1:4),'Location','northeast');
    set(gca,'XTick',1:npvar); set(gca,'XTickLabel',str.plabel(1:npvar));
    
    
    % scatterplot of the correlations of the bootstrap solutions
    %     corrplot(pest_BS',str.plabel(1:npvar),'a') % requires econ toolbox
    figure; [~,ax]=plotmatrix(pest_BS');
    title('correlation scatter plots of bootstrap solutions')
    for ip=1:npvar
        ax(ip,1).YLabel.String=str.plabel(ip);
        ax(npvar,ip).XLabel.String=str.plabel(ip);
    end

% print correlation coefficients 
disp(' Correlation coefficients'); disp(str.corrcoef);disp(' ')
    
% compute linear correlations and plot
int=(1:1:npvar);
ncombos=nchoosek(npvar,2);
combos=nchoosek(int,2);

% solve directly for y as a function of x
% *** change this to doing a PCA analysis ***
figure;nbox=ceil(sqrt(ncombos));
for i=1:ncombos
    
% linear regression for variable(2) = beta(1) + beta(2)*variable(1)
A=[ones(str.nbootstrap,1),pest_BS(combos(i,1),:)'];
ATA=A'*A;
B=pest_BS(combos(i,2),:)';
beta=ATA\(A'*B);

subplot(nbox,nbox,i); 
scatter(pest_BS(combos(i,1),:)',pest_BS(combos(i,2),:)');hold on
xx=[min(pest_BS(combos(i,1),:));max(pest_BS(combos(i,1),:))];
yy = beta(1)+beta(2)*xx;
plot(xx,yy);
xlabel(strjoin([str.plabel(combos(i,1))])); 
ylabel(strjoin([str.plabel(combos(i,2))]));
ltitle2=[num2str(beta(2),3),str.plabel(combos(i,1))];
ltitle1=[str.plabel(combos(i,2)),' = ',num2str(beta(1),3),' + '];
title([{strjoin(ltitle1)},{strjoin(ltitle2)}])
end
hold on;
% [ax4,h3]=suplabel('Bootstrap analysis'  ,'t');

end

end
