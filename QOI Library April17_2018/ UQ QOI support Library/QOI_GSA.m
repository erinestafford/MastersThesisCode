function [POI_samp,QOI_samp]=QOI_GSA(str)
%% QOI_GSA Global Sensitivity Anaysis

% generate the samples
ndim=length(str.POI_baseline);
nsamp=str.number_GSA_samples;
xunif=str.sampler_GSA(nsamp,ndim);% sobol rand
pdfstr.pdf=str.POI_pdf;
pdfstr.pdfmin=str.POI_min;
pdfstr.pdfmax=str.POI_max;
pdfstr.pdfmode=str.POI_mode;
POI_samp = unif2pdf(xunif, pdfstr);

%% define the constrained POIs
POI_samp = str.POI_constraints(POI_samp);

%% POI versus POI correlation plots
% scatterplot of the correlations of the POIs
%    corrplot(pest_BS',str.plabel(1:npvar),'a')% requires econ toolbox
figure; [~,ax]=plotmatrix(POI_samp);
title('correlation scatter plots of POIs')
for ip=1:str.nPOI
    ax(ip,1).YLabel.String=str.POI_names(ip);
    ax(str.nPOI,ip).XLabel.String=str.POI_names(ip);
end


% evaluate the model
QOI_samp=NaN(nsamp,str.nQOI);
for ix=1:nsamp
    QOI_samp(ix,:)=str.QOI_model_eval(POI_samp(ix,:));
end

%% QOI versus QOI correlation plots
%scatterplot of the correlations of the  QOIs
figure; [~,ax]=plotmatrix(QOI_samp);
title('correlation scatter plots of QOIs')
for iq=1:str.nQOI
    ax(iq,1).YLabel.String=str.QOI_names(iq);
    ax(str.nQOI,iq).XLabel.String=str.QOI_names(iq);
end

%% QOI versus POI correlation plots
%scatterplot of the correlations of the bootstrap solutions
figure; [~,ax]=plotmatrix(POI_samp,QOI_samp);
title('correlation scatter plots of QOIs')
for iq=1:str.nQOI
    ax(iq,1).YLabel.String=str.QOI_names(iq);
end
for ip=1:str.nPOI
    ax(str.nQOI,ip).XLabel.String=str.POI_names(ip);
end

for iq=1:str.nQOI
    figure;
    histogram(QOI_samp(:,iq),'Normalization','probability')
    title(str.QOI_model_name);ylabel('Probability');xlabel(str.QOI_names(iq));
end


end
