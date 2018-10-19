%-------------------------- CROSS-VALIDATION_ANALYSIS


function [CVindex,CVtrainMSE,CVtestMSE]=cross_validation_analysis(tdata,ydata,pfit,str)
%% CROSS-VALIDATION_ANALYSIS  % identify the most relevant parameters
% at this time, the CV is only backward subset selection and analyses the
% impact of removing just one variable.

% input:
% tdata,ydata original data
% pfit optimal fitting parameters
% data from the optimal fit of the model
% str structure
%
% output:
% CV_pfit_index - indicies of recommended CV parameters
% pfit_train_error - estimated standard deviation for pfit
% pfit_test_error - estimated standard deviation for pfit

% reference: Hastie Tip book

if str.verbose; disp('BEGIN CROSS-VALIDATION ANALYSIS');disp(' '); end

npvar=length(pfit);
[ntdata,nzdim]=size(ydata);

nsamp_per_fold=round(ntdata/str.nCV_folds); % number of samples per fold
index_CV=zeros(str.nCV_folds+1,1);

for ifold=2:str.nCV_folds+1
    index_CV(ifold)=index_CV(ifold-1)+nsamp_per_fold;
end
index_CV(str.nCV_folds+1)=min(max(index_CV(str.nCV_folds+1),ntdata),ntdata);

% prealocate storage
CVtrainMSE=NaN(npvar+1,1);CVtestMSE=NaN(npvar+1,1);CVindex=NaN(npvar+1,npvar);
for iCV=0:npvar
    
    pfitBSS=pfit;
    if iCV>0
        str.remove_index=iCV;
        str.remove_xvalue=0;
        pfitBSS(iCV)=0;
    end
    
    wydata=str.wydata;
    trainMSE=0; testMSE=0; ntrain=0;ntest=0;% initialize test and training errors to zero
    for ifold=1:str.nCV_folds % use ifold for test error
        ifbeg=index_CV(ifold)+1;
        ifend=index_CV(ifold+1);
        str.wydata=wydata;
        str.wydata(ifbeg:ifend)=0; %zero weights for test data
        
        % fit training data
        
        [pfitCV, ~, residtrain, ~] =fit_data(tdata,ydata,pfitBSS,str) ;
        
        % evaluate test error
        ntest_data=ifend-ifbeg+1;
        ntrain=ntrain+ntdata-ntest_data;% number of training data points
        ntest=ntest+ ntest_data;% number of training data points
        str.wydata=wydata;
        
        if iCV==0
            [resid, ~] = eval_residual(pfitCV,tdata,ydata,str);
            
        else
            pfitCV(iCV)=[]; % remove element being set to zero
            [resid, ~] = eval_residual(pfitCV,tdata,ydata,str);
        end
        
        
        trainMSE=trainMSE+sum(sum(residtrain.*residtrain));
        residtest=resid(ifbeg:ifend);
        testMSE=testMSE+sum(sum(residtest.*residtest));
    end
    CVtrainMSE(iCV+1)=trainMSE/ntrain;
    CVtestMSE(iCV+1)=testMSE/ntest;
    CVindex(iCV+1,:)=(1:npvar);
    if iCV >0; CVindex(iCV+1,iCV)=0;end
end

if str.verbose
    disp('   CVtrainMSE    CVtestMSE     CVindex')
    disp([CVtrainMSE(:),CVtestMSE(:),CVindex(:,:)])
    
    [CVtestMSEmin,imin] = min(CVtestMSE(2:npvar));
    disp(['parameter ', num2str(imin),' = ',str.plabel{imin},' is the least important',...
        ' with CV test error ratio = ',num2str(CVtestMSE(imin+1)/CVtestMSE(1))])
    disp('If CV test error ratio  is close to 1, this parameter might be redundant')
    
end

end
