
function contour_slice(pfit,str)
%% CONTOUR_SLICE contour plot of variables pfit(i1) versus pfit(i2)

figure;
ip=1;npvar=length(pfit);
for i1=1:npvar-1
    for i2=i1+1:npvar
        subplot(npvar-1,npvar-1,ip);ip=ip+1; % this layout can be improved****
        
        x1min=pfit(i1);x2min=pfit(i2);
        d1=str.profile_range; d2=str.profile_range;
        % generate a contour plot about the first two variables
        X1 =(pfit(i1)-d1 : d1/11 :pfit(i1)+d1);
        X2 =(pfit(i2)-d2 : d1/11 :pfit(i2)+d2);
        [XX1,XX2] = meshgrid(X1,X2);
        [n1,n2]=size(XX1);
        YY=NaN(n1,n2);
        peval=pfit;
        for ip1=1:n1
            for ip2=1:n2
                peval(i1)=X1(ip1); peval(i2)=X2(ip2);
                YY(ip1,ip2)=str.eval_function(peval);
            end
        end
        % YY
        % define contour levels near minimum
        contour(XX1,XX2,YY,31);hold on
        scatter(x1min,x2min,'*r')
        xlabel(str.plabel{i1}); ylabel(str.plabel{i2})
        title('residuals')
        
    end
end
end