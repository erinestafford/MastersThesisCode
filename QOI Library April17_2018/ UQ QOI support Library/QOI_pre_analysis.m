function QOI_pre_analysis(str)
%% QOI_pre_analysis check the problem
% add simple checks that must be true to prevent future problems 

% check that mode and baseline values are between min and max
for ip=1:str.nPOI
    if str.POI_mode(ip) < str.POI_min(ip) || str.POI_mode(ip) > str.POI_max(ip)
        disp('str.POI_min,str.POI_mode,str.POI_max')
        disp([str.POI_min,str.POI_mode,str.POI_max])
        keyboard
        error(' POI_mode not between POI_min and POI_max')
    end
    
    if str.POI_baseline(ip) < str.POI_min(ip) || str.POI_baseline(ip) > str.POI_max(ip)
        disp('str.POI_min,str.POI_baseline,str.POI_max')
        disp([str.POI_min,str.POI_baseline,str.POI_max])
        error(' POI_baseline not between POI_min and POI_max')
    end
end

end