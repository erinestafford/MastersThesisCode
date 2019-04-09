function [indices]=Sobol_GSA(str)
%% Global Sensitivity Anaysis with Sobol Indices

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
%POI_samp = str.POI_constraints(POI_samp); %not needed

%% evaluate the model
QOI_samp=NaN(nsamp,str.nQOI);
for ix=1:nsamp
    QOI_samp(ix,:)=str.QOI_model_eval(POI_samp(ix,:));
end
%% Global Sobol Sensitivity Indicies 

variq=NaN(1,str.nQOI);% gives overall variance in QOIs
for iq = 1:str.nQOI
    qmean=mean(QOI_samp(:,iq));
    variq(iq)=(QOI_samp(:,iq)-qmean)'*(QOI_samp(:,iq)-qmean)/nsamp;
end

varip=NaN(1,ndim);%calculate conditional variances

baseline_POI_samp = ones(size(POI_samp));
for i = 1:ndim
    for j = 1:nsamp
        baseline_POI_samp(j,i) = str.POI_baseline(i);
    end
end

temp_POI_samp= baseline_POI_samp;
for ip = 1:ndim
    for i = 1:nsamp
        temp_POI_samp(:,ip) = POI_samp(:,ip);
    end
    QOI_samp=NaN(nsamp,str.nQOI);
    for ix=1:nsamp
        QOI_samp(ix,:)=str.QOI_model_eval(temp_POI_samp(ix,:));
    end
    temp_POI_samp = baseline_POI_samp;
    for iq = 1:str.nQOI
        qmean=mean(QOI_samp(:,iq));
        varip(ip)=(QOI_samp(:,iq)-qmean)'*(QOI_samp(:,iq)-qmean)/nsamp;
    end
end
varip
variq
%calculate the first order sobol indices
indices = NaN(ndim,str.nQOI);
for i = 1:ndim
    for j = 1:str.nQOI
        indices(i,j) = varip(i)/variq(j);
    end
end
indices= indices';
end