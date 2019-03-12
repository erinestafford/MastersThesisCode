
function POIout = POI_constraints(POI)
%% POI_constraints define some POIs as functions of other POIs
POIout = POI;
POIout(:,2)=1 - POI(:,1);

% example of what a POI constraint would look like
%         POIout(:,1)=1+POI(:,2);
end

