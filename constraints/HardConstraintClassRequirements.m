function [ numUnmetRequirements ] = HardConstraintClassRequirements( schedule, rooms )
    
        coursemappings = schedule.courseMappings;
        
        numUnmetRequirements = 0;
        
        for i = 1:length(coursemappings)
            courseReqs = getFeatures(coursemappings(i).course.featuresReq);
            roomFeat = getFeatures(rooms(coursemappings(i).room.roomID).features);
            isSubset = all(ismember(courseReqs, roomFeat));
            if isSubset ~= 1
                numUnmetRequirements = numUnmetRequirements + 1;
            end
        end
end

%return array of feature IDs from a list of feature
function [featuresreqs] = getFeatures( features )
    featureIDs = [];
    if isempty(features) ~= 1
        featureIDs = zeros(length(features),1);
        for i = 1:length(features)
            featureIDs(i) = features(i).featureID;
        end
        featureIDs = sort(featureIDs);       
    end
    
    featuresreqs = featureIDs;
    

end
