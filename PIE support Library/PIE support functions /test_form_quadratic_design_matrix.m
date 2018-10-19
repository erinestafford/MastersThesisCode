function test_form_quadratic_design_matrix

ndim=2;max_deg=2;nx=11;
labelX =  {'X1', 'X2', 'X3', 'X4', 'X5','X6'}; % Default labels

% func = @(x,y) x.^2;
xdata=NaN(nx,ndim);
for ix=1:nx
    for iy=1:nx
        xdata(ix,1)=ix;
        xdata(ix,2)=1 -  ix + ix^2;
    end
end
% plot(xdata(:,1),xdata(:,2),'*')

[BasisExp,BasisLabel]=fit_quad(xdata,labelX)

end

function [BasisCoef,BasisLabel]=fit_quad(xdata,labelX)

[nx,ndim]=size(xdata);
nterms=1 + ndim*max_deg + ndim*(ndim-1)/2;
BasisLabel=strings(nterms,1);

% generate the design matrix for quadratic with cross-terms
BasisExp = zeros(nterms,ndim);
iterm=1 ;
for idim = 1:ndim
    for ideg = 1:max_deg
        iterm=iterm+1 ;
        BasisExp(iterm,idim)=ideg ;
        BasisLabel(iterm)=labelX(idim);
        if ideg>1
            BasisLabel(iterm)=strcat(BasisLabel(iterm),labelX(idim));
        end
    end
end

% add quadratic cross terms
for idim1 = 1:ndim
    for idim2 = idim1+1:ndim
        iterm=iterm+1 ;
        BasisExp(iterm,idim1)=1 ;
        BasisExp(iterm,idim2)=1 ;
        BasisLabel(iterm)=strcat(labelX(idim1),labelX(idim2));
        
    end
end

%  define the design matrix
X=ones(nx+1,nterm); Y=zeros(nx+1,1); Y(nx+1,1)=1;
for ix=1:nx
    for it=1:nterm
        for id=1:ndim
            X(ix,it)=X(ix,it)*xdata(ix,id)^BasisExp(it,id);
        end
    end
end
X(nx+1,2:nterm)=0;


% fit the data normalized so the sum of the coefficients = 1
BasisCoef=linsolve(X,Y);


end
