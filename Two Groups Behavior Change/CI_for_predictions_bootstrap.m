function CI_for_predictions_bootstrap(nsamps_per_BS_block,nbootstrap,real,tspan,params,opt_params,array_names,lb,ub,full_count)
%% Bootstrap for CI

wydata = ones(size(real'));
npvar=length(struct2array(opt_params,array_names));
[ntdata,nzdim]=size(real');
blockhalfwith=floor(nsamps_per_BS_block/2);% block half width
nybeg=blockhalfwith+1; % beginning index for the blocks
nyend=ntdata-blockhalfwith;% ending index for the blocks
nblockcenters=nyend-nybeg+1;% number of block centers
nblocks=ceil(ntdata/nsamps_per_BS_block); % number of blocks selected each bootstrap
% define weights for bootstrap analysis
pest_BS=NaN(npvar,nbootstrap);
temp_wydata=wydata; % save weights before bootstrap
obj_fn2 = @(parray,wydata)obj_fn(parray, real, array_names, tspan,wydata);
for ib=1:nbootstrap % do bootstrap str.nbootstrap times
    wdataBS=zeros(ntdata,nzdim); % initialize BS weigths to zero
    
    index_bs=nybeg+ceil(nblockcenters*rand(nblocks,1))-1;% random centers for blocks
    
    for ip=1:nblocks
        
        for ibb=index_bs(ip)-blockhalfwith:index_bs(ip)+blockhalfwith % loop over points in a block
            wdataBS(ibb,:)=wdataBS(ibb,:)+1; % update weight of points in a block
        end
        
    end
    
    wydata=temp_wydata.*sqrt(wdataBS); % use the square root since the weights are wydata^2
    % fit the data
    pfit =optimizer(@(p)obj_fn2(p,wydata), lb, ub, params);% save fitted parameters
    pfit.theta1 = 1 - pfit.theta2;
    pest_BS(:,ib) = struct2array(pfit,array_names);
end
wydata = temp_wydata;
pest_mean=mean(pest_BS,2); % define the mean of bootstrapped parameters
pest_STD= std(pest_BS,0,2) ; % standard deviation of the parameter estimates
pest_SE = pest_STD/sqrt(nbootstrap); % Standard Error
zstar=1.96 ;% for 95% confidence interval (assumes Gaussian distribution)
pest_CI95 = zstar*pest_SE ;  % 95% confidence bounds delta

str.corrcoef = corrcoef(pest_BS');
disp('    mean pfit     95% CI     all data')
disp([pest_mean,pest_CI95,struct2array(opt_params,array_names)'])
p_mean = array2struct(pest_mean,array_names);
init_mean = get_init_conditions(p_mean, 0);
[t_mean,out_mean] = balance_and_solve(tspan, init_mean, p_mean);

p_up = array2struct(pest_mean +pest_CI95 ,array_names);
init_up = get_init_conditions(p_up, 0);
[t_up,out_up] = balance_and_solve(tspan, init_up, p_up);

p_low = array2struct(pest_mean -pest_CI95 ,array_names);
init_low = get_init_conditions(p_low, 0);
[t_low,out_low] = balance_and_solve(tspan, init_low, p_low);
 
figure()
ciplot(out_low(:,7)+out_low(:,8),out_up(:,7)+out_up(:,8),tspan,'k')
hold on
plot(tspan, out_mean(:,7)+out_mean(:,8),'-r')
plot(tspan,real,'*')
end