
% ------------------------- CURVE_FIT_THROUGH_DATA

function [BasisCoef,BasisLabel]=curve_fit_through_data(pdata,plabel)
% CURVE_FIT_THROUGH_DATA  fit a linear regression through the surface that
% defines the nonidentifiability surface
% ****** this code is not debugged and needs to be replaced with a sparse
% solver ******

[np,ndim]=size(pdata);max_deg=2;
nterms=1 + ndim*max_deg + ndim*(ndim-1)/2;
BasisLabel=strings(nterms,1);

% generate the design matrix for quadratic with cross-terms
BasisExp = zeros(nterms,ndim);
iterm=1 ;
for idim = 1:ndim
    for ideg = 1:max_deg
        iterm=iterm+1 ;
        BasisExp(iterm,idim)=ideg ;
        BasisLabel(iterm)=plabel(idim);
        if ideg>1
            BasisLabel(iterm)=strcat(BasisLabel(iterm),plabel(idim));
        end
    end
end

% add quadratic cross terms
for idim1 = 1:ndim
    for idim2 = idim1+1:ndim
        iterm=iterm+1 ;
        BasisExp(iterm,idim1)=1 ;
        BasisExp(iterm,idim2)=1 ;
        BasisLabel(iterm)=strcat(plabel(idim1),plabel(idim2));
        
    end
end
nterm=iterm;
%  define the design matrix
X=ones(np+1,nterm); Y=zeros(np+1,1); Y(np+1,1)=1;
for ip=1:np
    for it=1:nterm
        for id=1:ndim
            X(ip,it)=X(ip,it)*pdata(ip,id)^BasisExp(it,id);
        end
    end
end
X(np+1,2:nterm)=0;

% X=[X;0.001*eye(nterm,nterm)];Y=[Y;zeros(nterm,1)];
% fit the data normalized so the sum of the coefficients = 1
BasisCoef = linsolve(X,Y);
% resid=Y-X*BasisCoef;

end
