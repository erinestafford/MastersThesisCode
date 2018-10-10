function xpdf = unif2pdf(xunif, str)
%% map  uniformly distributed samples xunif to another distribution
%
% input
% xunif(nsamp,nPOI)-samples with a uniform probability distribution [0,1]
% str.pdf = structure with the name of the desired pdf

% str.pdf  structure with the parameters defining pdf
% str.pdfmin - min range for the pdf
% str.pdfmin - max range for the pdf
% str.pdfmin - mode for the pdf

% output
% xpdf(nsamp,nPOI) - mapped samples with distribution str.pdf

[nsamp,ndim] = size(xunif);

% 1. generate sample with pdf in [0,1]
switch str.pdf
    case 'uniform'
        xpdf=xunif;
        
    case 'triangle'
        % map the mode to the interval [0,1]
        pdfmode=(str.pdfmode-str.pdfmin)/(str.pdfmax-str.pdfmin);
        xpdf=NaN(nsamp,ndim);
        for id=1:ndim% this needs to be vectorized
            for ix=1:nsamp
                if xunif(ix,id) < pdfmode(id)
                    xpdf(ix,id)=sqrt(pdfmode(id)*xunif(ix,id));
                else
                    xpdf(ix,id)=1-sqrt((1-xunif(ix,id))*(1-pdfmode(id)));
                end
                
            end
        end
        
    case 'beta'% shape parameter alpha=2, + mode
        % map the mode to the interval [0,1]
        pdfmode=(str.pdfmode-str.pdfmin)/(str.pdfmax-str.pdfmin);
        pdfalpha=2;% use as default value
        for id=1:ndim
            pdfbeta=1/pdfmode(id);
            xpdf=betainv(xunif,pdfalpha,pdfbeta);
        end
        
    otherwise
        error(['str.pdf= ',str.pdf,' not available'])
end

% 2. map to desired interval

for id=1:ndim
    c1=str.pdfmin(id);
    c2=str.pdfmax(id)-str.pdfmin(id);
    xpdf(:,id)=c1 + c2*xpdf(:,id);
end

end
